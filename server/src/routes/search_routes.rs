use axum::{
    extract::{Query, State},
    middleware::from_fn_with_state,
    routing::get,
    Router,
};

use crate::{
    enums::errors::AppError,
    middlware::search_middleware::search_permission_check,
    models::{
        requests::SearchQueryParams,
        response::{AppResponse, RouteResponse},
        search::AddressesSearch,
        state::AppState,
    },
};

async fn search_addresses(
    query: Query<SearchQueryParams>,
    State(state): State<AppState>,
) -> RouteResponse<Vec<AddressesSearch>> {
    let result = state
        .rqw_client
        .get(format!(
            "http://localhost:3200/search?q={}&format=jsonv2&addressdetails=1&extratags=1&namedetails=1&layer=address,poi&accept-language=sr-Latn&limit=50",
            query.search_query
        ))
        .send()
        .await
        .map_err(AppError::default_response)?;

    let data = result
        .json::<Vec<AddressesSearch>>()
        .await
        .map_err(AppError::critical_error)?;

    let mut filtered_data: Vec<AddressesSearch> = data
        .into_iter()
        .filter(|item| {
            item.osm_type != "relation"
                && item.address.road.is_some()
                && item.address.house_number.is_some()
                && (item.address.city.is_some() || item.address.suburb.is_some())
        })
        .collect();

    filtered_data.sort_by(|a, b| a.address.postcode.cmp(&b.address.postcode));

    Ok(AppResponse::default_response(filtered_data))
}

pub fn search_routes(state: &AppState) -> Router<AppState> {
    return Router::new().nest(
        "/search",
        Router::new()
            .route("/addresses", get(search_addresses))
            .layer(from_fn_with_state(state.clone(), search_permission_check)),
    );
}
