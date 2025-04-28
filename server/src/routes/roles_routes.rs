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

async fn list_roles(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    //! DO NOT LIST OUT OWNER ROLE
    let statement = format!(
        "SELECT
            {}
        FROM
            roles
        WHERE
            company_id IS NULL
                OR
            company_id = $1;",
        fields
    );

    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(&statement, &[&session.user.company_id])
        .await
        .map_err(AppError::default_response)?;

    let value = rows.serialize_list(true);

    return Ok(AppResponse::default_response(value));
}

pub fn roles_routes() -> Router<AppState> {
    return Router::new().nest("/roles", Router::new().route("/list", get(list_roles)));
}
