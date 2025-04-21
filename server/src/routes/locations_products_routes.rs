use axum::{
    extract::{Path, State},
    routing::{delete, get, post},
    Extension, Json, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession,
        locations_products::InsertLocationProduct,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn create_location_products(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertLocationProduct>,
) -> RouteResponse<i64> {
    let mut statement = String::from(
        "INSERT INTO locations_products (product_id, location_id, expiration_date) VALUES ", //* values are added dynamically below
    );

    for i in 0..payload.amount {
        statement.push_str(&format!("($1, $2, $3)",));
        if i < payload.amount - 1 {
            statement.push_str(", ");
        }
    }
    statement.push_str(";");

    let conn = state.get_db_conn().await?;

    conn.query(
        &statement,
        &[
            &payload.id,
            &session.user.location_id,
            &payload.expiration_date,
        ],
    )
    .await
    .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(payload.amount));
}

// async fn create_location_products_barcode(
//     State(state): State<AppState>,
//     Extension(session): Extension<AuthSession>,
//     Json(payload): Json<InsertLocationProductByBarcode>,
// ) -> RouteResponse<i64> {
//     let mut conn = state.get_db_conn().await?;

//     let tx = conn.transaction().await.map_err(AppError::critical_error)?;

//     let product_row = tx.query_one(
//         "SELECT id FROM products WHERE barcode = $1 AND (company_id IS NULL OR company_id = $2);",
//         &[&payload.barcode, &session.user.company_id],
//     ).await.map_err(AppError::critical_error)?;

//     let product_id = product_row
//         .try_get::<&str, Uuid>("id")
//         .map_err(AppError::critical_error)?;

//     let mut statement =
//         String::from("INSERT INTO locations_products (product_id, location_id) VALUES ");

//     for i in 0..payload.amount {
//         statement.push_str(&format!("($1, $2)",));
//         if i < payload.amount - 1 {
//             statement.push_str(", ");
//         }
//     }

//     statement.push_str(";");

//     let res = tx
//         .query(&statement, &[&product_id, &session.user.location_id])
//         .await;

//     if res.is_err() {
//         tx.rollback().await.map_err(AppError::critical_error)?;
//         res.map_err(AppError::critical_error)?;
//     }

//     return Ok(AppResponse::default_response(payload.amount));
// }

async fn list_location_products_group_by_expiration(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;
    let statement = format!(
        "
    SELECT
        locations_products.product_id, expiration_date, COUNT(*)
    FROM
        locations_products
    WHERE
        product_id = $1
            AND
        location_id = $2
    GROUP BY
        expiration_date, locations_products.product_id
    ORDER BY
        expiration_date;"
    );
    let rows = conn
        .query(&statement, &[&id, &session.user.location_id.unwrap()])
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

async fn delete_location_products_amount(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path((product_id, amount)): Path<(Uuid, i64)>,
) -> RouteResponse<i64> {
    let statement = String::from(
        "WITH rows_to_delete AS (
            SELECT id
            FROM locations_products
            WHERE product_id = $1 AND location_id = $2
            ORDER BY expiration_date
            LIMIT $3
        )
        DELETE FROM locations_products
        WHERE id IN (SELECT id FROM rows_to_delete);",
    );

    let conn = state.get_db_conn().await?;

    conn.query(
        &statement,
        &[&product_id, &session.user.location_id, &amount],
    )
    .await
    .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(amount));
}

async fn delete_location_products(
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
) -> RouteResponse<Uuid> {
    let statement = format!("DELETE FROM locations_products WHERE id = $1;");

    let conn = &state.get_db_conn().await?;

    let _ = conn
        .query_one(&statement, &[&id])
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(id));
}

// async fn delete_location_products_barcode(
//     State(state): State<AppState>,
//     Extension(session): Extension<AuthSession>,
//     Path((barcode, amount)): Path<(String, i64)>,
// ) -> RouteResponse<i64> {
//     let statement = String::from(
//         "WITH rows_to_delete AS (
//             SELECT
//                 locations_products.id as id
//             FROM
//                 products
//             LEFT JOIN locations_products
//                 ON locations_products.product_id = products.id
//             WHERE products.barcode = $1 AND locations_products.location_id = $2
//             LIMIT $3
//         )
//         DELETE FROM locations_products
//         WHERE id IN (SELECT id FROM rows_to_delete);",
//     );

//     let conn = state.get_db_conn().await?;

//     conn.query(&statement, &[&barcode, &session.user.location_id, &amount])
//         .await
//         .map_err(AppError::critical_error)?;

//     return Ok(AppResponse::default_response(amount));
// }

pub fn location_products_routes() -> Router<AppState> {
    return Router::new().nest(
        "/locations-products",
        Router::new()
            .route("/", post(create_location_products))
            .route(
                "/list/{id}/grouped/expiration-date",
                get(list_location_products_group_by_expiration),
            )
            .route("/{id}", delete(delete_location_products))
            // .route("/barcode/{barcode}", post(create_location_products_barcode))
            .route(
                "/{product_id}/amount/{amount}",
                delete(delete_location_products_amount),
            ), // .route(
               // "/barcode/{barcode}/amount/{amount}",
               // delete(delete_location_products_barcode),
               // ),
    );
}
