use std::{
    collections::{HashMap, HashSet},
    vec,
};

use axum::{
    extract::{Path, Query, State},
    routing::{delete, get, patch, post},
    Extension, Json, Router,
};
use serde_json::Value;
use tokio_postgres::types::ToSql;
use uuid::Uuid;

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models, requests::CerbosAttrValue},
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        cerbos::{CerbosCheck, CerbosResource},
        locations::{InsertLocation, UpdateLocation},
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::{SerializeList, SerializeToJson},
    utils::request_utils::convert_filter_type,
};

async fn create_location(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertLocation>,
) -> RouteResponse<Uuid> {
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::critical_error)?;

    let row = tx
        .query_one(
            "INSERT INTO locations
            (title, owner_id, longitude, latitude)
        VALUES
            ($1, $2, $3, $4)
        RETURNING id;",
            &[
                &payload.title,
                &session.user.id,
                &payload.longitude,
                &payload.latitude,
            ],
        )
        .await
        .map_err(AppError::default_response)?;
    let location_id: Uuid = row.try_get("id").map_err(AppError::default_response)?;

    if let Some(contacts) = payload.contacts {
        let contact_statement = tx
            .prepare(
                "
            INSERT INTO
                locations_contacts
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
                    &Uuid::new_v4(),
                    &location_id, // this is the parent_id i.e. location's id
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
                ],
            )
            .await
            .map_err(AppError::critical_error)?;
        }
    }

    //* locations_users user and owner role are added automatically via trigger

    Ok(AppResponse::default_response(location_id))
}

async fn read_location(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(model): Extension<Models>,
    Extension(action): Extension<Actions>,
    Path(id): Path<Uuid>,
) -> RouteResponse<Value> {
    let query_string = format!(
        "SELECT {}
        FROM
            locations
        WHERE
            locations.id = $1;",
        fields
    );

    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(&query_string, &[&id])
        .await
        .map_err(AppError::default_response)?;

    let principal = session.user.to_principal();

    let location_resource = CerbosResource {
        id: id.to_string(),
        kind: model.to_string(),
        scope: None,
        attr: None,
    };

    let check = CerbosCheck {
        principal,
        resources: vec![location_resource],
        model,
        action,
    };

    let permissions = check.get_permissions(&state).await?;

    if let Some(perm) = permissions.get(&id.to_string()) {
        if perm == &true {
            let data = row.serialize_row_to_json(true);

            Ok(AppResponse::default_response(data))
        } else {
            Err(AppError::forbidden_response(
                "No permission to perform this action on this model. | MODEL location | ACTION read.",
            ))
        }
    } else {
        Err(AppError::forbidden_response(
            "No permission to perform this action on this model. | MODEL location | ACTION read.",
        ))
    }
}

async fn list_location(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    params: Query<QueryParams>,
) -> RouteResponse<Value> {
    let sql_params = vec![
        session.user.id.to_string(),
        params.limit.to_string(),
        (params.limit * params.page).to_string(),
    ];

    let inputs_dyn: Vec<Box<dyn ToSql + Sync + Send>> = sql_params
        .iter()
        .map(convert_filter_type)
        .collect::<Vec<_>>();

    let inputs_dyn = inputs_dyn
        .iter()
        .map(|input| input.as_ref() as &(dyn ToSql + Sync))
        .collect::<Vec<_>>();

    let query_string = format!(
        "SELECT {}
        FROM
            locations_users
        LEFT JOIN locations
            ON locations_users.location_id = locations.id
        WHERE
            locations_users.user_id = $1
        ORDER BY
            title
        LIMIT $2
        OFFSET $3;",
        fields
    );

    let conn = state.get_db_conn().await?;

    let rows = conn
        .query(&query_string, &inputs_dyn)
        .await
        .map_err(AppError::default_response)?;

    let data = rows.serialize_list(true);

    Ok(AppResponse::default_response(data))
}

async fn update_location(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(model): Extension<Models>,
    Extension(action): Extension<Actions>,
    Path(id): Path<Uuid>,
    Json(payload): Json<UpdateLocation>,
) -> RouteResponse<Uuid> {
    let mut conn = state.get_db_conn().await?;
    let location_row = conn
        .query_one(
            "SELECT company_id FROM locations WHERE locations.id = $1;",
            &[&id],
        )
        .await
        .map_err(AppError::critical_error)?;
    let company_id: Uuid = location_row.get("company_id");

    let principal = session.user.to_principal();
    let resource = CerbosResource {
        id: id.to_string(),
        kind: model.to_string(),
        scope: None,
        attr: Some(HashMap::from([(
            "company_id".to_string(),
            CerbosAttrValue::Uuid(company_id),
        )])),
    };

    let check = CerbosCheck {
        model,
        action,
        principal,
        resources: vec![resource],
    };
    let has_permission = check.check_permission(&state).await?;

    if has_permission {
        let tx = conn.transaction().await.map_err(AppError::critical_error)?;
        let statement = "UPDATE locations SET title = COALESCE($2, title) WHERE id = $1;";

        tx.execute(statement, &[&id, &payload.title])
            .await
            .map_err(AppError::critical_error)?;

        if let Some(contacts) = payload.contacts {
            if contacts.is_empty() {
                tx.execute(
                    "DELETE FROM locations_contacts WHERE parent_id = $1;",
                    &[&id],
                )
                .await
                .map_err(AppError::critical_error)?;
                let _ = tx.commit().await.map_err(AppError::critical_error)?;
                return Ok(AppResponse::default_response(id));
            }

            let existing_contact_rows = tx
                .query(
                    "SELECT id FROM locations_contacts WHERE parent_id = $1;",
                    &[&id],
                )
                .await
                .map_err(AppError::critical_error)?;

            let existing_ids: HashSet<Uuid> = existing_contact_rows
                .iter()
                .map(|row| {
                    let id: Uuid = row.get("id");
                    return id;
                })
                .collect();
            let payload_ids: HashSet<Uuid> = contacts
                .iter()
                .filter(|c| c.id.is_some())
                .map(|c| c.id.unwrap())
                .collect();

            let to_remove: Vec<&Uuid> = existing_ids.difference(&payload_ids).collect();

            tx.execute(
                "DELETE FROM locations_contacts WHERE id = ANY($1) AND parent_id = $2;",
                &[&to_remove, &id],
            )
            .await
            .map_err(AppError::critical_error)?;

            let contact_statement = tx
                .prepare(
                    "
            INSERT INTO
                locations_contacts
            (
                id, parent_id, title, prefix, value, is_public,
                place_id, latitude, longitude, bounding_box, contact_type,
                iso_3, is_primary
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            ON CONFLICT (id) DO UPDATE
            SET
                title = COALESCE(EXCLUDED.title, locations_contacts.title),
                prefix = COALESCE(EXCLUDED.prefix, locations_contacts.prefix),
                value = COALESCE(EXCLUDED.value, locations_contacts.value),
                is_public = COALESCE(EXCLUDED.is_public, locations_contacts.is_public),
                bounding_box = COALESCE(EXCLUDED.bounding_box, locations_contacts.bounding_box),
                latitude = COALESCE(EXCLUDED.latitude, locations_contacts.latitude),
                longitude = COALESCE(EXCLUDED.longitude, locations_contacts.longitude),
                place_id = COALESCE(EXCLUDED.place_id, locations_contacts.place_id),
                contact_type = COALESCE(EXCLUDED.contact_type, locations_contacts.contact_type),
                iso_3 = COALESCE(EXCLUDED.iso_3, locations_contacts.iso_3),
                is_primary = COALESCE(EXCLUDED.is_primary, locations_contacts.is_primary);",
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

        let _ = tx.commit().await.map_err(AppError::critical_error)?;

        return Ok(AppResponse::default_response(id));
    } else {
        return Err(AppError::forbidden_response(
            "No permission to perform action. MODEL locations | ACTION update",
        ));
    }
}

async fn delete_location(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            "DELETE FROM locations WHERE id = $1 AND owner_id = $2 RETURNING id;",
            &[&id, &session.user.id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let data = row.try_get("id").map_err(AppError::default_response)?;

    Ok(AppResponse::default_response(data))
}

pub fn locations_routes() -> Router<AppState> {
    return Router::new().nest(
        "/locations",
        Router::new()
            .route("/", post(create_location))
            .route("/list", get(list_location))
            .route("/{id}", get(read_location))
            .route("/{id}", patch(update_location))
            .route("/{id}", delete(delete_location)),
    );
}
