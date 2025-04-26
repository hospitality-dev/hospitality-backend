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

async fn list_manufacturers(
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;
    let stmt = format!(
        "SELECT {} FROM manufacturers WHERE (
    is_default = TRUE AND company_id IS NULL
) OR (is_default = FALSE AND company_id IS NOT NULL AND company_id = $1);",
        fields
    );
    let rows = conn
        .query(&stmt, &[&session.user.company_id.unwrap()])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn manufacturers_routes() -> Router<AppState> {
    return Router::new().nest("/manufacturers", Router::new());
}
