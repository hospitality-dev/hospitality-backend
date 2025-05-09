use std::collections::HashMap;

use axum::{
    extract::{Path, State},
    routing::{delete, get, post},
    Extension, Json, Router,
};
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession,
        locations_available_products::InsertLocationAvailableProduct,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
};

async fn create_locations_available_products(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertLocationAvailableProduct>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            "INSERT INTO
                locations_available_products (product_id, location_id)
            VALUES
                ($1, $2)
            RETURNING
                product_id;",
            &[&payload.product_id, &session.user.location_id],
        )
        .await
        .map_err(AppError::default_response)?;

    let id = row
        .try_get("product_id")
        .map_err(AppError::default_response)?;

    return Ok(AppResponse::default_response(id));
}

async fn read_locations_available_products(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<HashMap<Uuid, Uuid>> {
    // * Returns product_id as the key and the id as the value
    // * to allow deleting the row when a product is deactivated

    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT
                locations_available_products.id,
                locations_available_products.product_id
            FROM
                locations_available_products
            LEFT JOIN products
                ON products.id = locations_available_products.product_id
            WHERE
                (
                    products.company_id IS NULL
                        OR
                    products.company_id = $1
                )
                    AND
                locations_available_products.location_id = $2;",
            ),
            &[&session.user.company_id, &session.user.location_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data: HashMap<Uuid, Uuid> = rows
        .into_iter()
        .map(|row| {
            let product_id = row.get("product_id");
            let id = row.get("id");
            return (product_id, id);
        })
        .collect();
    Ok(AppResponse::default_response(data))
}

async fn delete_locations_available_products(
    Path(id): Path<Uuid>,
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<Uuid> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            "DELETE FROM
                locations_available_products
            WHERE
                id = $1
                    AND
                location_id = $2
            RETURNING
                id;",
            &[&id, &session.user.location_id],
        )
        .await
        .map_err(AppError::default_response)?;

    let id = row.try_get("id").map_err(AppError::default_response)?;
    Ok(AppResponse::default_response(id))
}

pub fn locations_available_products_routes() -> Router<AppState> {
    return Router::new().nest(
        "/locations-available-products",
        Router::new()
            .route("/", post(create_locations_available_products))
            .route("/{id}", get(read_locations_available_products))
            .route("/{id}", delete(delete_locations_available_products)),
    );
}
