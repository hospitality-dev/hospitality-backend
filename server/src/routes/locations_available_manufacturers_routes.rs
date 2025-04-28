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
        locations_available_manufacturers::InsertLocationAvailableManufacturers,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
};

async fn create_locations_available_manufacturers(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertLocationAvailableManufacturers>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            "INSERT INTO
                locations_available_manufacturers (manufacturer_id, location_id)
            VALUES
                ($1, $2)
            RETURNING
                manufacturer_id;",
            &[&payload.manufacturer_id, &session.user.location_id],
        )
        .await
        .map_err(AppError::default_response)?;

    let id = row
        .try_get("manufacturer_id")
        .map_err(AppError::default_response)?;

    return Ok(AppResponse::default_response(id));
}

async fn read_locations_available_manufacturers(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<HashMap<Uuid, Uuid>> {
    // * Returns manufacturer_id as the key and the id as the value
    // * to allow deleting the row when a manufacturer is deactivated

    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT
                locations_available_manufacturers.id,
                locations_available_manufacturers.product_id
            FROM
                locations_available_manufacturers
            LEFT JOIN manufacturers
                ON manufacturers.id = locations_available_manufacturers.product_id
            WHERE
                (
                    manufacturers.company_id IS NULL
                        OR
                    manufacturers.company_id = $1
                )
                    AND
                locations_available_manufacturers.location_id = $2;",
            ),
            &[&session.user.company_id, &session.user.location_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data: HashMap<Uuid, Uuid> = rows
        .into_iter()
        .map(|row| {
            let manufacturer_id = row.get("manufacturer_id");
            let id = row.get("id");
            return (manufacturer_id, id);
        })
        .collect();
    Ok(AppResponse::default_response(data))
}

async fn delete_locations_available_manufacturers(
    Path(id): Path<Uuid>,
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<Uuid> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            "DELETE FROM
                locations_available_manufacturers
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

pub fn locations_available_manufacturer_routes() -> Router<AppState> {
    return Router::new().nest(
        "/locations-available-manufacturers",
        Router::new()
            .route("/", post(create_locations_available_manufacturers))
            .route("/{id}", get(read_locations_available_manufacturers))
            .route("/{id}", delete(delete_locations_available_manufacturers)),
    );
}
