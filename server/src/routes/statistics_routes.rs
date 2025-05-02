use axum::{extract::State, Extension, Router};
use serde_json::Value;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn last_month_purchase_per_date(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let stmt = "SELECT purchased_at::DATE AS purchased_at, SUM(total) AS total
    FROM
        purchases
    WHERE
        purchased_at IS NOT NULL
            AND
        purchased_at >= NOW() - INTERVAL '30 days'
            AND
        purchases.location_id = $1
    GROUP BY
        purchased_at::DATE
    ORDER BY
        purchased_at::DATE;";
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(stmt, &[&session.user.location_id.unwrap()])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

async fn last_month_purchase_per_suppiler(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let stmt = "SELECT suppliers.title, SUM(total) as total
    FROM
        purchases
    INNER JOIN stores
        ON purchases.store_id = stores.id
    INNER JOIN suppliers
        ON stores.parent_id = suppliers.id
    WHERE
        purchases.location_id = $1
            AND
        purchased_at IS NOT NULL
            AND
        purchased_at >= NOW() - INTERVAL '30 days'
    GROUP BY
        suppliers.title, suppliers.id
    ORDER BY
        total;";

    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(stmt, &[&session.user.location_id.unwrap()])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn statistics_routes() -> Router<AppState> {
    return Router::new().nest(
        "/statistics",
        Router::new()
            .route(
                "/purchases/month",
                axum::routing::get(last_month_purchase_per_date),
            )
            .route(
                "/purchases/month/suppliers",
                axum::routing::get(last_month_purchase_per_suppiler),
            ),
    );
}
