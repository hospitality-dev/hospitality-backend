use axum::{
    extract::{Path, State},
    routing::{delete, get, post},
    Extension, Json, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        products::InsertProduct,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::{SerializeList, SerializeToJson},
};

async fn create_product(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertProduct>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            "INSERT INTO products
        (title, description, category_id, barcode, weight, volume, subcategory_id, image_id, company_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id;",
            &[
                &payload.title,
                &payload.description,
                &payload.category_id,
                &payload.barcode,
                &payload.weight,
                &payload.volume,
                &payload.subcategory_id,
                &payload.image_id,
                &session.user.company_id
            ],
        )
        .await
        .map_err(AppError::critical_error)?;

    let id = row.try_get("id").map_err(AppError::default_response)?;

    Ok(AppResponse::default_response(id))
}

async fn read_product_with_barcode(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Path(barcode): Path<String>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            &format!(
                "SELECT
                    {}
                FROM
                    products
                WHERE
                    barcode = $1
                        AND
                    (
                        products.company_id IS NULL
                            OR
                        products.company_id = $2
                    );",
                fields
            ),
            &[&barcode, &session.user.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data = row.serialize_row_to_json(true);

    return Ok(AppResponse::default_response(data));
}

async fn read_product(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Path(id): Path<Uuid>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            &format!(
                "SELECT
                    {}
                FROM
                    products
                WHERE
                    products.id = $1
                        AND
                    (
                        products.company_id IS NULL
                            OR
                        products.company_id = $2
                    );",
                fields
            ),
            &[&id, &session.user.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data = row.serialize_row_to_json(true);

    return Ok(AppResponse::default_response(data));
}

async fn list_product(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT {fields}
                FROM
                    products
                WHERE
                    (products.company_id = $1
                        OR
                    products.company_id IS NULL)
                GROUP BY
                    {fields}
                ORDER BY
                    products.title;",
                fields = fields
            ),
            &[&session.user.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    Ok(AppResponse::default_response(rows.serialize_list(true)))
}

async fn list_product_by_category(
    Extension(fields): Extension<AllowedFieldsType>,

    Extension(session): Extension<AuthSession>,
    Path(category_id): Path<Uuid>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT {fields}
                FROM
                    products
                WHERE
                    products.category_id = $1
                        AND
                    (
                        company_id = $2
                            OR
                        company_id IS NULL
                    )
                GROUP BY
                    {fields}
                ORDER BY
                    products.title;",
                fields = fields
            ),
            &[&category_id, &session.user.company_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    Ok(AppResponse::default_response(rows.serialize_list(true)))
}

async fn list_product_by_category_active(
    Extension(fields): Extension<AllowedFieldsType>,

    Extension(session): Extension<AuthSession>,
    Path(category_id): Path<Uuid>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT
                    {fields}, COUNT(locations_products.id),
                    (
                        SELECT EXISTS
                            (
                                SELECT 1
                                FROM
                                    locations_products
                                WHERE
                                    expiration_date <= NOW() + INTERVAL '7 days'
                                        AND
                                    locations_products.product_id = products.id
                            )
                    ) as has_about_to_expire
                FROM
                    products
                LEFT JOIN locations_available_products
                    ON locations_available_products.product_id = products.id
                LEFT JOIN locations_products
                    ON locations_products.product_id = products.id
                WHERE
                    products.category_id = $1
                            AND
                        (
                            (
                                products.company_id = $2
                                    AND
                                locations_available_products.location_id = $3
                            )
                                OR
                            products.company_id IS NULL
                        )
                GROUP BY
                    {fields}
                ORDER BY
                    products.title;",
                fields = fields
            ),
            &[
                &category_id,
                &session.user.company_id,
                &session.user.location_id,
            ],
        )
        .await
        .map_err(AppError::critical_error)?;

    Ok(AppResponse::default_response(rows.serialize_list(true)))
}

async fn delete_product(
    Path(id): Path<Uuid>,
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> RouteResponse<Uuid> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            "DELETE FROM products WHERE id = $1 AND company_id IS NOT NULL AND company_id = $2 RETURNING id;",
            &[&id, &session.user.company_id],
        )
        .await
        .map_err(AppError::default_response)?;

    let id = row.try_get("id").map_err(AppError::default_response)?;
    Ok(AppResponse::default_response(id))
}

// TODO: UPDATE PRODUCT MUST HAVE A SAFEGUARD

pub fn product_routes() -> Router<AppState> {
    Router::new().nest(
        "/products",
        Router::new()
            .route("/", post(create_product))
            .route("/{id}", get(read_product))
            .route("/barcode/{barcode}", get(read_product_with_barcode))
            .route("/list", get(list_product))
            .route("/list/active", get(list_product))
            .route(
                "/list/category/{category_id}",
                get(list_product_by_category),
            )
            .route(
                "/list/category/{category_id}/active",
                get(list_product_by_category_active),
            )
            .route("/{id}", delete(delete_product)),
    )
}
