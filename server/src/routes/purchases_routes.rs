use axum::{
    extract::State,
    routing::{get, post},
    Extension, Json, Router,
};
use postgres_types::ToSql;
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        purchases::{InsertPurchase, InvoiceData},
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
    utils::transform_utils::{extract_items, format_receipt},
};

async fn create_purchase(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertPurchase>,
) -> RouteResponse<Uuid> {
    let p = state
        .rqw_client
        .get(&payload.url)
        .header("Content-Type", "application/json")
        .header("accept", "application/json")
        .send()
        .await
        .map_err(AppError::default_response)?
        .json::<InvoiceData>()
        .await
        .map_err(AppError::critical_error)?;

    let receipt = format_receipt(&p.journal);
    let items = extract_items(&receipt);

    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::db_error)?;

    let supplier_id: Uuid = tx
        .query_one(
            "SELECT id FROM suppliers WHERE title = $1;",
            &[&p.invoice_request.business_name],
        )
        .await
        .map_err(AppError::db_error)?
        .try_get("id")
        .map_err(AppError::default_response)?;

    let store_id: Uuid = tx
        .query_one(
            "INSERT INTO stores (title, parent_id, is_default) VALUES ($1, $2, FALSE) ON CONFLICT (id) DO NOTHING RETURNING id;",
            &[&p.invoice_request.location_name, &supplier_id],
        )
        .await
        .map_err(AppError::db_error)?
        .try_get("id")
        .map_err(AppError::default_response)?;

    let payment_type = if let Some(payment) = p.invoice_request.payments.get(0) {
        payment.payment_type
    } else {
        0
    };
    let purchase_row = tx
        .query_one(
            "INSERT INTO purchases
    (purchased_at, company_id, location_id, owner_id, url, total, payment_type, tax_id, transaction_type, invoice_type,
    invoice_counter_extension, invoice_number, store_id, currency_title)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, 'RSD')
     RETURNING id;",
            &[
                &p.invoice_result.sdc_time,
                &session.user.company_id.unwrap(),
                &session.user.location_id.unwrap(),
                &session.user.id,
                &payload.url.to_string(),
                &p.invoice_result.total_amount,
                &payment_type,
                &p.invoice_request.tax_id,
                &p.invoice_request.transaction_type,
                &p.invoice_request.invoice_type,
                &p.invoice_result.invoice_counter_extension,
                &p.invoice_result.invoice_number,
                &store_id
            ],
        )
        .await
        .map_err(AppError::db_error)?;

    let purchase_id: Uuid = purchase_row.get("id");

    let mut purchase_items_stmt = String::from(
        "INSERT INTO
            purchase_items
        (
            company_id, location_id, parent_id, product_id,
            owner_id, title, price_per_unit, quantity, unit_of_measurement
        )
        VALUES ",
    );

    let items_count = items.len();
    let mut params: Vec<&(dyn ToSql + Sync)> = Vec::new();

    let company_id = &session.user.company_id.unwrap();
    let location_id = &session.user.location_id.unwrap();
    let user_id = &session.user.id;

    params.push(company_id);
    params.push(location_id);
    params.push(&purchase_id);
    params.push(&supplier_id);
    params.push(user_id);
    for (idx, item) in items.iter().enumerate() {
        purchase_items_stmt.push_str(&format!(
            "($1, $2, $3, (SELECT product_id FROM products_aliases WHERE products_aliases.title = ${title} AND products_aliases.supplier_id = $4 LIMIT 1), $5, TRIM(${title}), ${}, ${}, ${})",
            (7 + (idx * 4)).to_string(),
            (8 + (idx * 4)).to_string(),
            (9 + (idx * 4)).to_string(),
            title =(6 + (idx * 4)).to_string()
        ));
        params.push(&item.0 as &(dyn ToSql + Sync));
        params.push(&item.1 as &(dyn ToSql + Sync));
        params.push(&item.2 as &(dyn ToSql + Sync));
        params.push(&item.4 as &(dyn ToSql + Sync));
        if idx < items_count - 1 {
            purchase_items_stmt.push_str(", ");
        }
    }
    purchase_items_stmt.push_str(";");

    tx.execute(&purchase_items_stmt, &params)
        .await
        .map_err(AppError::db_error)?;

    tx.commit().await.map_err(AppError::db_error)?;
    return Ok(AppResponse::default_response(purchase_id));
}

async fn list_purchases(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;
    let rows = conn
        .query(
            &format!(
                "SELECT
                {}, stores.title as business_location_title, suppliers.title as business_title
            FROM
                purchases
            LEFT JOIN stores
                ON stores.id = purchases.store_id
            LEFT JOIN suppliers
                ON suppliers.id = stores.parent_id
            WHERE
                location_id = $1;",
                fields
            ),
            &[&session.user.location_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn purchases_routes() -> Router<AppState> {
    return Router::new().nest(
        "/purchases",
        Router::new()
            .route("/", post(create_purchase))
            .route("/list", get(list_purchases)),
    );
}
