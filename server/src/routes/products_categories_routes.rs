use axum::{
    extract::{Path, State},
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
        products_categories::InsertProductCategory,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::{SerializeList, SerializeToJson},
};

async fn create_products_categories(
    State(state): State<AppState>,
    Json(payload): Json<InsertProductCategory>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            "INSERT INTO products_categories
     (title, parent_id, company_id, is_default)
     VALUES ($1, $2, $3, FALSE)
     RETURNING id;",
            &[&payload.title, &payload.parent_id, &payload.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data = row.try_get("id").map_err(AppError::default_response)?;
    Ok(AppResponse::default_response(data))
}

async fn read_products_categories(
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query_one(
            &format!(
                "SELECT {}
                FROM
                    products_categories
                LEFT JOIN products_categories
                    ON products_categories.parent_id = $1
                WHERE
                    id = $1
                        AND
                    (products_categories.company_id = $2
                        OR
                    products_categories.company_id IS NULL);",
                fields
            ),
            &[&id],
        )
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(
        rows.serialize_row_to_json(true),
    ));
}

async fn list_products_categories(
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;
    let rows = conn
        .query(
            &format!(
                "SELECT {}
                FROM
                    products_categories
                WHERE
                    parent_id IS NULL
                        AND
                    (company_id = $1 OR company_id IS NULL)
                ORDER BY title;",
                fields
            ),
            &[&session.user.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub fn products_categories_routes() -> Router<AppState> {
    Router::new().nest(
        "/products-categories",
        Router::new()
            .route("/", post(create_products_categories))
            .route("/{id}", get(read_products_categories))
            .route("/list", get(list_products_categories)),
    )
}
