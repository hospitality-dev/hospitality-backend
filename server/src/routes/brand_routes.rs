use axum::{
    extract::{Path, State},
    routing::{get, post},
    Extension, Json, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        brands::InsertBrand,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn create_brand(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertBrand>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;
    let id: Uuid = conn
        .query_one(
            "INSERT INTO brands (title, parent_id, company_id) VALUES ($1, $2, $3) RETURNING id;",
            &[
                &payload.title,
                &payload.parent_id,
                &session.user.company_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    return Ok(AppResponse::default_response(id));
}

async fn list_brands(
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
    Path(parent_id): Path<Uuid>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;
    let stmt = format!(
        "SELECT {}
        FROM
            brands
        WHERE
            (
                is_default = TRUE
                    AND
                company_id IS NULL
            )
                OR
            (
                is_default = FALSE
                    AND
                company_id IS NOT NULL
                    AND
                company_id = $1
            )
                AND
            parent_id = $2;
            ;",
        fields
    );
    let rows = conn
        .query(&stmt, &[&session.user.company_id.unwrap(), &parent_id])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn brand_routes() -> Router<AppState> {
    return Router::new().nest(
        "/brands",
        Router::new()
            .route("/list/{parent_id}", get(list_brands))
            .route("/", post(create_brand)),
    );
}
