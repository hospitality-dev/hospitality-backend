use axum::{
    extract::State,
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
        suppliers::InsertSupplier,
    },
    traits::db_traits::SerializeList,
};

async fn create_supplier(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertSupplier>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;
    let id: Uuid = conn
        .query_one(
            "INSERT INTO suppliers (title, owner_id, company_id) VALUES ($1, $2, $3) RETURNING id;",
            &[
                &payload.title,
                &session.user.id,
                &session.user.company_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    return Ok(AppResponse::default_response(id));
}

pub async fn list_suppliers(
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT
        {}
    FROM
        suppliers
    WHERE
        company_id IS NULL
            OR
        company_id = $1;",
                fields
            ),
            &[&session.user.company_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn suppliers_routes() -> Router<AppState> {
    return Router::new().nest(
        "/suppliers",
        Router::new()
            .route("/list", get(list_suppliers))
            .route("/", post(create_supplier)),
    );
}
