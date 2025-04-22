use axum::{extract::State, routing::get, Extension, Json, Router};
use serde_json::Value;
use uuid::Uuid;

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

async fn list_purchase_items(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Json(parent_id): Json<Uuid>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;
    let rows = conn
        .query(
            &format!(
                "SELECT {} FROM purchase_items WHERE parent_id = $1 AND location_id = $2;",
                fields
            ),
            &[&parent_id, &session.user.location_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn purchase_items_routes() -> Router<AppState> {
    return Router::new().nest(
        "/purchase-items",
        Router::new().route("/list/{parent_id}", get(list_purchase_items)),
    );
}
