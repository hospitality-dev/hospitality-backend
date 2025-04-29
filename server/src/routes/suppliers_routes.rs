use std::collections::{HashMap, HashSet};

use axum::{
    extract::{Path, State},
    routing::{get, patch, post},
    Extension, Json, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models, requests::CerbosAttrValue},
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        cerbos::{CerbosCheck, CerbosResource},
        response::{AppResponse, RouteResponse},
        state::AppState,
        suppliers::{InsertSupplier, UpdateSupplier},
    },
    traits::db_traits::SerializeList,
};

async fn create_supplier(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Json(payload): Json<InsertSupplier>,
) -> RouteResponse<Uuid> {
    let conn = &state.get_db_conn().await?;
    let id: Uuid = conn
        .query_one(
            "INSERT INTO suppliers (title, owner_id, company_id) VALUES ($1, $2, $3) RETURNING id;",
            &[
                &payload.title,
                &session.user.id,
                &session.user.company_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::db_error)?
        .get("id");

    return Ok(AppResponse::default_response(id));
}

pub async fn list_suppliers(
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    State(state): State<AppState>,
) -> RouteResponse<Value> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT
        {}
    FROM
        suppliers
    WHERE
        company_id IS NULL
            OR
        company_id = $1;",
                fields
            ),
            &[&session.user.company_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

pub async fn update_supplier(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(model): Extension<Models>,
    Extension(action): Extension<Actions>,
    Path(id): Path<Uuid>,
    Json(payload): Json<UpdateSupplier>,
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
        let statement = "UPDATE suppliers SET title = COALESCE($2, title) WHERE id = $1;";

        tx.execute(statement, &[&id, &payload.title])
            .await
            .map_err(AppError::critical_error)?;

        if let Some(contacts) = payload.contacts {
            if contacts.is_empty() {
                tx.execute(
                    "DELETE FROM suppliers_contacts WHERE parent_id = $1;",
                    &[&id],
                )
                .await
                .map_err(AppError::critical_error)?;
                let _ = tx.commit().await.map_err(AppError::critical_error)?;
                return Ok(AppResponse::default_response(id));
            }

            let existing_contact_rows = tx
                .query(
                    "SELECT id FROM suppliers_contacts WHERE parent_id = $1;",
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
                "DELETE FROM suppliers_contacts WHERE id = ANY($1) AND parent_id = $2;",
                &[&to_remove, &id],
            )
            .await
            .map_err(AppError::critical_error)?;

            let contact_statement = tx
                .prepare(
                    "
            INSERT INTO
                suppliers_contacts
            (
                id, parent_id, title, prefix, value, is_public,
                place_id, latitude, longitude, bounding_box, contact_type,
                iso_3, is_primary
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            ON CONFLICT (id) DO UPDATE
            SET
                title = COALESCE(EXCLUDED.title, suppliers_contacts.title),
                prefix = COALESCE(EXCLUDED.prefix, suppliers_contacts.prefix),
                value = COALESCE(EXCLUDED.value, suppliers_contacts.value),
                is_public = COALESCE(EXCLUDED.is_public, suppliers_contacts.is_public),
                bounding_box = COALESCE(EXCLUDED.bounding_box, suppliers_contacts.bounding_box),
                latitude = COALESCE(EXCLUDED.latitude, suppliers_contacts.latitude),
                longitude = COALESCE(EXCLUDED.longitude, suppliers_contacts.longitude),
                place_id = COALESCE(EXCLUDED.place_id, suppliers_contacts.place_id),
                contact_type = COALESCE(EXCLUDED.contact_type, suppliers_contacts.contact_type),
                iso_3 = COALESCE(EXCLUDED.iso_3, suppliers_contacts.iso_3),
                is_primary = COALESCE(EXCLUDED.is_primary, suppliers_contacts.is_primary);",
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

pub fn suppliers_routes() -> Router<AppState> {
    return Router::new().nest(
        "/suppliers",
        Router::new()
            .route("/", post(create_supplier))
            .route("/list", get(list_suppliers))
            .route("/{id}", patch(update_supplier)),
    );
}
