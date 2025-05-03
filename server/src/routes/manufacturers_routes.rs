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
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::db_error)?;
    let id: Uuid = tx
        .query_one(
            "INSERT INTO manufacturers (title, owner_id, company_id) VALUES ($1, $2, $3) RETURNING id;",
            &[&payload.title, &session.user.id, &session.user.company_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    if let Some(contacts) = payload.contacts {
        let contact_statement = tx
            .prepare(
                "INSERT INTO manufacturers_contacts
            (
                id, parent_id, title, prefix, value, is_public,
                place_id, latitude, longitude, bounding_box, contact_type,
                iso_3, is_primary
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);",
            )
            .await
            .map_err(AppError::critical_error)?;

        for contact in contacts {
            tx.execute(
                &contact_statement,
                &[
                    &contact.id.unwrap_or(Uuid::new_v4()),
                    &id, // this is the parent_id i.e. location's id
                    &contact.title,
                    &contact.prefix,
                    &contact.value,
                    &contact.is_public,
                    &contact.place_id,
                    &contact.latitude,
                    &contact.longitude,
                    &contact.bounding_box,
                    &contact.contact_type.to_string(),
                    &contact.iso_3,
                    &contact.is_primary,
                ],
            )
            .await
            .map_err(AppError::critical_error)?;
        }
    }
    tx.execute("INSERT INTO locations_available_manufacturers (manufacturer_id, location_id) VALUES ($1, $2);", &[&id, &session.user.location_id.unwrap()]).await.map_err(AppError::db_error)?;

    tx.commit().await.map_err(AppError::db_error)?;

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
        "SELECT {}, locations_available_manufacturers.id AS availability_id
        FROM
            manufacturers
        LEFT JOIN locations_available_manufacturers
            ON manufacturers.id = locations_available_manufacturers.manufacturer_id
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
