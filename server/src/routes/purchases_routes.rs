use axum::{extract::State, routing::post, Extension, Json, Router};
use postgres_types::ToSql;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession,
        purchases::{InsertPurchase, InvoiceData},
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    utils::transform_utils::{extract_items, format_receipt},
};

pub async fn create_purchase(
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

    let payment_type = if let Some(payment) = p.invoice_request.payments.get(0) {
        payment.payment_type
    } else {
        0
    };
    let purchase_row = tx
        .query_one(
            "INSERT INTO purchases
    (purchased_at, company_id, location_id, owner_id, url, total, payment_type, address,
    business_title, business_location_title, tax_id, transaction_type, invoice_type,
    invoice_counter_extension, invoice_number)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8,
     $9, $10, $11, $12, $13, $14, $15)
     RETURNING id;",
            &[
                &p.invoice_result.sdc_time,
                &session.user.company_id.unwrap(),
                &session.user.location_id.unwrap(),
                &session.user.id,
                &payload.url.to_string(),
                &p.invoice_result.total_amount,
                &payment_type,
                &p.invoice_request.address,
                &p.invoice_request.business_name,
                &p.invoice_request.location_name,
                &p.invoice_request.tax_id,
                &p.invoice_request.transaction_type,
                &p.invoice_request.invoice_type,
                &p.invoice_result.invoice_counter_extension,
                &p.invoice_result.invoice_number,
            ],
        )
        .await
        .map_err(AppError::db_error)?;

    let purchase_id: Uuid = purchase_row.get("id");

    let mut purchase_items_stmt = String::from(
        "INSERT INTO purchase_items
    (title, company_id, location_id, parent_id, product_id, owner_id)
    VALUES ",
    );

    let items_count = items.len();
    let mut params: Vec<&(dyn ToSql + Sync)> = Vec::new();

    let company_id = &session.user.company_id.unwrap();
    let location_id = &session.user.location_id.unwrap();

    params.push(company_id);
    params.push(location_id);
    params.push(&purchase_id as &(dyn ToSql + Sync));
    params.push(&None::<Uuid> as &(dyn ToSql + Sync));
    params.push(&session.user.id as &(dyn ToSql + Sync));
    for (idx, item) in items.iter().enumerate() {
        purchase_items_stmt.push_str(&format!(
            "(${}, $2, $3, $4, $5, $6)",
            if idx == 0 {
                params.insert(0, &item.0 as &(dyn ToSql + Sync));
                String::from("1")
            } else {
                params.push(&item.0 as &(dyn ToSql + Sync));

                (idx + 6).to_string()
            }
        ));
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

pub fn purchases_routes() -> Router<AppState> {
    return Router::new().nest(
        "/purchases",
        Router::new().route("/", post(create_purchase)),
    );
}
