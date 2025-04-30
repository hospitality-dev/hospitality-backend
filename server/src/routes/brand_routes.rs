use axum::{
    extract::{Path, Query, State},
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
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn create_brand(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertBrand>,
) -> RouteResponse<Uuid> {
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::db_error)?;

    let id: Uuid = tx
        .query_one(
            "INSERT INTO brands (title, parent_id, owner_id, company_id) VALUES ($1, $2, $3, $4) RETURNING id;",
            &[
                &payload.title,
                &payload.parent_id,
                &session.user.id,
                &session.user.company_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    tx.execute(
        "INSERT INTO locations_available_brands (brand_id, location_id) VALUES ($1, $2);",
        &[&id, &session.user.location_id.unwrap()],
    )
    .await
    .map_err(AppError::db_error)?;

    tx.commit().await.map_err(AppError::db_error)?;
    return Ok(AppResponse::default_response(id));
}

async fn list_brands(
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
    query: Query<QueryParams>,
    Path(parent_id): Path<Uuid>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;
    let sort = query.to_query_sort();
    let stmt = format!(
        "SELECT {}, locations_available_brands.id AS availability_id
        FROM
            brands
        LEFT JOIN locations_available_brands
            ON locations_available_brands.brand_id = brands.id
        WHERE
            (
                company_id IS NULL
                    OR
                company_id = $1
            )
                AND
            parent_id = $2
            {sort};",
        fields,
        sort = sort
    );
    let rows = conn
        .query(&stmt, &[&session.user.company_id.unwrap(), &parent_id])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn brand_routes() -> Router<AppState> {
    return Router::new().nest(
        "/brands",
        Router::new()
            .route("/list/{parent_id}", get(list_brands))
            .route("/", post(create_brand)),
    );
}
