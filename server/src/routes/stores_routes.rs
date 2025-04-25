use axum::{
    extract::{Path, State},
    Extension, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn list_stores(
    State(state): State<AppState>,
    Path(parent_id): Path<Uuid>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT {} FROM stores WHERE parent_id = $1 ORDER BY title;",
                fields
            ),
            &[&parent_id],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn stores_routes() -> Router<AppState> {
    return Router::new().nest(
        "/stores",
        Router::new().route("/list", axum::routing::get(list_stores)),
    );
}
