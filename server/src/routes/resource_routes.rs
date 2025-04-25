use std::collections::HashSet;

use crate::{
    enums::errors::AppError,
    models::{
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};
use axum::{
    extract::{Query, State},
    routing::get,
    Router,
};
use common::consts::COUNTRIES_FIELDS;
use itertools::Itertools;
use serde_json::Value;

async fn countries(
    State(state): State<AppState>,
    query: Query<QueryParams>,
) -> RouteResponse<Value> {
    let query_fields = query.0.fields.unwrap_or("".into());
    let fields: HashSet<&str> = query_fields.split(",").collect::<HashSet<&str>>();

    let allowed_fields: HashSet<&str> = fields
        .intersection(&HashSet::from_iter(COUNTRIES_FIELDS))
        .map(|item| *item)
        .collect();

    let allowed_fields = allowed_fields.iter().join(", ");

    let conn = state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!("SELECT {} FROM countries ORDER BY title;", allowed_fields),
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
