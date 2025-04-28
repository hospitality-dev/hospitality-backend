use axum::{
    extract::{Query, State},
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
        manufacturers::InsertManufacturer,
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn create_manufacturer(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertManufacturer>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;
    let id: Uuid = conn
        .query_one(
            "INSERT INTO manufacturers (title, company_id) VALUES ($1, $2) RETURNING id;",
            &[&payload.title, &session.user.company_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    return Ok(AppResponse::default_response(id));
}

async fn list_manufacturers(
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
    query: Query<QueryParams>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;
    let sort = query.to_query_sort();
    let stmt = format!(
        "SELECT {}
        FROM
            manufacturers
        WHERE
            company_id IS NULL
                OR
            company_id = $1
            {sort};",
        fields,
        sort = sort
    );
    let rows = conn
        .query(&stmt, &[&session.user.company_id.unwrap()])
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn manufacturers_routes() -> Router<AppState> {
    return Router::new().nest(
        "/manufacturers",
        Router::new()
            .route("/list", get(list_manufacturers))
            .route("/", post(create_manufacturer)),
    );
}
