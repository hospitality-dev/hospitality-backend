use axum::{extract::State, routing::get, Router};
use serde_json::Value;

use crate::{
    enums::errors::AppError,
    models::{
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn countries(State(state): State<AppState>) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let rows = conn
        .query(
            "SELECT id, title, iso3, phonecode FROM countries ORDER BY title;",
            &[],
        )
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn resource_routes() -> Router<AppState> {
    return Router::new().nest(
        "/resources",
        Router::new().route("/list/countries", get(countries)),
    );
}
