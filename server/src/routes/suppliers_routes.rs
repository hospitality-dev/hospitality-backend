use axum::{extract::State, routing::get, Extension, Router};
use serde_json::Value;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

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
        (
            is_default = TRUE
                AND
            company_id IS NULL
                AND
            owner_id IS NULL
        )
            OR
        (
            is_default = FALSE
                AND
            company_id = $1
        );",
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
        Router::new().route("/list", get(list_suppliers)),
    );
}
