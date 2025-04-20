use std::collections::{HashMap, HashSet};

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models, requests::CerbosAttrValue},
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        cerbos::{CerbosCheck, CerbosResource},
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        users::{InsertUser, UpdateUser},
    },
    traits::db_traits::{SerializeList, SerializeToJson},
    utils::{
        db_utils::{db_conn, WhereBuilder},
        request_utils::convert_filter_type,
    },
    AppState,
};
use argon2::{
    password_hash::{rand_core::OsRng, SaltString},
    Argon2, PasswordHasher,
};
use axum::{
    extract::{Path, Query, State},
    routing::{delete, get, patch, post},
    Extension, Json, Router,
};
use deadpool_postgres::GenericClient;
use is_empty::IsEmpty;
use serde_json::Value;
use tokio_postgres::types::ToSql;
use uuid::Uuid;

async fn create_user(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertUser>,
) -> RouteResponse<Uuid> {
    if payload.password1 != payload.password2 {
        return Err(AppError::default_response(format!(
            "Passwords do not match - {}",
            payload.username
        )));
    }

    let argon2 = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);
    let password_hash = argon2
        .hash_password(payload.password1.as_bytes(), &salt)
        .map_err(AppError::critical_error)?
        .to_string();

    let mut conn = db_conn(&state.db_pool)
        .await
        .map_err(AppError::default_response)?;
    let tx = conn
        .transaction()
        .await
        .map_err(AppError::default_response)?;

    let row = tx
        .query_one(
            "INSERT INTO
                users
                    (first_name, last_name, username, image_id,
                    date_of_birth, date_of_employment, date_of_termination, pw_hsh)
            VALUES
                ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING id;",
            &[
                &payload.first_name,
                &payload.last_name,
                &payload.username,
                &payload.image_id,
                &payload.date_of_birth,
                &payload.date_of_employment,
                &payload.date_of_termination,
                &password_hash,
            ],
        )
        .await;
    if row.is_err() {
        tracing::error!("INSERTING INTO USERS FAILED");
        tx.rollback().await.map_err(AppError::db_error)?;
        return Err(AppError::default_response(row.err().unwrap()));
    }
    let row = row.unwrap();
    let user_id: Uuid = row.try_get("id").map_err(AppError::default_response)?;

    if let Some(contacts) = payload.contacts {
        let contact_statement = tx.prepare("INSERT INTO users_contacts (parent_id, prefix, value, type, title) VALUES ($1, $2, $3, $4, $5);").await.map_err(AppError::critical_error)?;

        for contact in contacts {
            tx.execute(
                &contact_statement,
                &[
                    &user_id,
                    &contact.prefix,
                    &contact.value,
                    &contact.contact_type.to_string(),
                    &contact.title,
                ],
            )
            .await
            .map_err(AppError::critical_error)?;
        }
    }

    let row = tx
        .execute(
            "INSERT INTO
                locations_users (user_id, location_id, role_id)
                VALUES
                    ($1, $2, $3);",
            &[&user_id, &session.user.location_id, &payload.role_id],
        )
        .await;

    if row.is_err() {
        tracing::error!("INSERTING INTO LOCATIONS_USERS FAILED");
        tx.rollback().await.map_err(AppError::critical_error)?;
        return Err(AppError::critical_error(row.err().unwrap()));
    }

    tx.commit().await.map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(user_id));
}

async fn update_user(
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
    Extension(model): Extension<Models>,
    Extension(session): Extension<AuthSession>,
    Extension(action): Extension<Actions>,
    Json(payload): Json<UpdateUser>,
) -> RouteResponse<Uuid> {
    if payload.is_empty() {
        return Err(AppError::default_response(
            "Update payload does not have at least one field with data.",
        ));
    }

    let mut conn = db_conn(&state.db_pool)
        .await
        .map_err(AppError::default_response)?;

    let location_row = conn
        .query_one(
            "SELECT
                users.id, locations_users.location_id
            FROM
                users
            LEFT JOIN locations_users ON
                locations_users.user_id = users.id
            WHERE
                users.id = $1
                    AND
                locations_users.location_id = $2;",
            &[&id, &session.user.location_id],
        )
        .await
        .map_err(AppError::critical_error)?;
    let user_id: Uuid = location_row.get("id");
    let location_id: Uuid = location_row.get("location_id");

    let principal = session.user.to_principal();
    let resource = CerbosResource {
        id: id.to_string(),
        kind: model.to_string(),
        scope: None,
        attr: Some(HashMap::from([
            ("id".to_string(), CerbosAttrValue::Uuid(user_id)),
            (
                "location_id".to_string(),
                CerbosAttrValue::Uuid(location_id),
            ),
        ])),
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
        tx.execute(
            "UPDATE users
                SET
                    first_name = COALESCE($2, first_name),
                    last_name = COALESCE($3, last_name),
                    username = COALESCE($4, username),
                    image_id = COALESCE($5, image_id)
                WHERE
                    id = $1
                RETURNING id;",
            &[
                &id,
                &payload.first_name,
                &payload.last_name,
                &payload.username,
                &payload.image_id,
            ],
        )
        .await
        .map_err(AppError::db_error)?;

        if let Some(contacts) = payload.contacts {
            if contacts.is_empty() {
                tx.execute("DELETE FROM users_contacts WHERE parent_id = $1;", &[&id])
                    .await
                    .map_err(AppError::db_error)?;
            } else {
                let existing_contact_rows = tx
                    .query(
                        "SELECT id FROM users_contacts WHERE parent_id = $1;",
                        &[&id],
                    )
                    .await
                    .map_err(AppError::db_error)?;

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
                    "DELETE FROM users_contacts WHERE id = ANY($1) AND parent_id = $2;",
                    &[&to_remove, &id],
                )
                .await
                .map_err(AppError::critical_error)?;

                let contact_statement = tx
                    .prepare(
                        "INSERT INTO
                            users_contacts
                                (
                                    id, parent_id, title, prefix, value, is_public,
                                    place_id, latitude, longitude, bounding_box, contact_type,
                                    iso_3, is_primary
                                )
                            VALUES
                                ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
                            ON CONFLICT (id) DO UPDATE
                            SET
                                title = COALESCE(EXCLUDED.title, users_contacts.title),
                                prefix = COALESCE(EXCLUDED.prefix, users_contacts.prefix),
                                value = COALESCE(EXCLUDED.value, users_contacts.value),
                                is_public = COALESCE(EXCLUDED.is_public, users_contacts.is_public),
                                bounding_box = COALESCE(EXCLUDED.bounding_box, users_contacts.bounding_box),
                                latitude = COALESCE(EXCLUDED.latitude, users_contacts.latitude),
                                longitude = COALESCE(EXCLUDED.longitude, users_contacts.longitude),
                                place_id = COALESCE(EXCLUDED.place_id, users_contacts.place_id),
                                contact_type = COALESCE(EXCLUDED.contact_type, users_contacts.contact_type),
                                iso_3 = COALESCE(EXCLUDED.iso_3, users_contacts.iso_3),
                                is_primary = COALESCE(EXCLUDED.is_primary, users_contacts.is_primary);",
                    )
                    .await
                    .map_err(AppError::critical_error)?;

                for contact in contacts {
                    tx.execute(
                        &contact_statement,
                        &[
                            &contact.id.unwrap_or(Uuid::new_v4()),
                            &id, // this is the parent_id i.e. users's id
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
        }

        if payload.role_id.is_some() {
            tx.execute(
                "UPDATE locations_users
                    SET
                        role_id = COALESCE($1, role_id)
                    WHERE
                        user_id = $2
                            AND
                        location_id = $3;",
                &[&payload.role_id, &id, &location_id],
            )
            .await
            .map_err(AppError::db_error)?;
        }

        let _ = tx.commit().await.map_err(AppError::db_error)?;

        return Ok(AppResponse::default_response(id));
    } else {
        return Err(AppError::forbidden_response(
            "User has no permission to peform this action. MODEL users | ACTION update",
        ));
    }
}

async fn read_user(
    Path(id): Path<Uuid>,
    State(state): State<AppState>,
    Extension(fields): Extension<AllowedFieldsType>,
    Extension(session): Extension<AuthSession>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            format!(
                "SELECT
                    {}, locations.company_id, locations_users.location_id, locations_users.role_id
                FROM
                    users
                LEFT JOIN locations_users
                    ON locations_users.user_id = users.id
                LEFT JOIN locations
                    ON locations.id = locations_users.location_id
                LEFT JOIN roles
                    ON roles.id = locations_users.role_id
                WHERE
                    users.id = $1
                        AND
                    locations_users.location_id = $2;",
                fields
            )
            .as_str(),
            &[&id, &session.user.location_id],
        )
        .await
        .map_err(AppError::default_response)?;

    let company_id: Uuid = row.get("company_id");
    let location_id: Uuid = row.get("location_id");

    let principal = session.user.to_principal();
    let mut resource_attr: HashMap<String, CerbosAttrValue> = HashMap::new();
    resource_attr.insert(String::from("id"), CerbosAttrValue::Uuid(id));
    resource_attr.insert(
        String::from("company_id"),
        CerbosAttrValue::Uuid(company_id),
    );
    resource_attr.insert(
        String::from("location_id"),
        CerbosAttrValue::Uuid(location_id),
    );

    let resource = CerbosResource {
        id: id.to_string(),
        scope: None,
        kind: String::from("users"),
        attr: Some(resource_attr),
    };

    let check = CerbosCheck {
        action: Actions::View(id),
        principal,
        model: Models::Users,
        resources: vec![resource],
    };

    check.check_permission(&state).await?;

    let user = row.serialize_row_to_json(true);
    return Ok(AppResponse::default_response(user));
}

async fn list_user(
    State(state): State<AppState>,
    params: Query<QueryParams>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    (company_id, location_id): (Option<Uuid>, Option<Uuid>),
) -> RouteResponse<Value> {
    if company_id.is_none() && location_id.is_none() {
        return Err(AppError::default_response(
            "Incorrect USER list path params - missing both company_id & location_id.",
        ));
    }

    let mut attr: HashMap<String, CerbosAttrValue> = HashMap::new();

    let path_id = company_id.unwrap_or(location_id.unwrap_or(Uuid::nil()));
    let path_id_field_where_clause = if let Some(company_id) = company_id {
        attr.insert(
            String::from("company_id"),
            CerbosAttrValue::Uuid(company_id),
        );

        "locations.company_id = $1"
    } else if let Some(location_id) = location_id {
        attr.insert(
            String::from("location_id"),
            CerbosAttrValue::Uuid(location_id),
        );

        "locations_users.location_id = $1"
    } else {
        ""
    };

    // * =======================================
    // * Specific check due to need for checking if a user
    // * is allowed to read certain users, not just in general (the model)

    let principal = session.user.to_principal();

    let resource = CerbosResource {
        id: String::from("users-list"),
        kind: Models::Users.to_string(),
        scope: None,
        attr: Some(attr),
    };

    let check = CerbosCheck {
        model: Models::Users,
        action: Actions::List,
        principal,
        resources: vec![resource],
    };

    check.check_permission(&state).await?;

    // * =======================================

    let filters = match &params.0.filters {
        Some(f) => serde_json::from_str(f.as_str()).unwrap_or(None::<Value>),
        None => None,
    };
    let mut sql_params = vec![
        path_id.to_string(),
        params.limit.to_string(),
        (params.limit * params.page).to_string(),
    ];
    let mut builder = WhereBuilder::new(&Models::Users, Some(sql_params.len()));
    let (filter_where, filter_params) = builder.build_where_clause(&filters)?;

    sql_params.extend(filter_params);

    let statement = format!(
        "SELECT
            {},
            (SELECT
                json_build_object('id', roles.id, 'title', roles.title)
            FROM
                locations_users
            JOIN
                roles ON locations_users.role_id = roles.id
            WHERE
                locations_users.user_id = users.id
            LIMIT 1) AS role
        FROM
            users
        JOIN locations_users
            ON users.id = locations_users.user_id
        JOIN locations
            ON locations.id = locations_users.location_id
        WHERE
            {}
                AND
            {}
        GROUP BY
            users.id
        ORDER BY
            first_name
        LIMIT $2
        OFFSET $3;",
        fields, path_id_field_where_clause, filter_where
    );

    let inputs_dyn: Vec<Box<dyn ToSql + Sync + Send>> = sql_params
        .iter()
        .map(convert_filter_type)
        .collect::<Vec<_>>();

    let inputs_dyn = inputs_dyn
        .iter()
        .map(|input| input.as_ref() as &(dyn ToSql + Sync))
        .collect::<Vec<_>>();

    let conn = db_conn(&state.db_pool)
        .await
        .map_err(AppError::default_response)?;

    let rows = conn
        .query(statement.as_str(), &inputs_dyn)
        .await
        .map_err(AppError::default_response)?;

    let users = rows.serialize_list(true);

    return Ok(AppResponse::default_response(users));
}

async fn list_user_company_id(
    state: State<AppState>,
    params: Query<QueryParams>,
    session: Extension<AuthSession>,
    fields: Extension<AllowedFieldsType>,
    Path(company_id): Path<Uuid>,
) -> RouteResponse<Value> {
    list_user(state, params, session, fields, (Some(company_id), None)).await
}
async fn list_user_location_id(
    state: State<AppState>,
    params: Query<QueryParams>,
    session: Extension<AuthSession>,
    fields: Extension<AllowedFieldsType>,
    Path(location_id): Path<Uuid>,
) -> RouteResponse<Value> {
    list_user(state, params, session, fields, (None, Some(location_id))).await
}

async fn delete_user(
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
    Extension(session): Extension<AuthSession>,
) -> RouteResponse<Uuid> {
    let conn = state.get_db_conn().await?;

    let row = conn
        .query_one(
            "DELETE FROM users WHERE id = $1 AND id != $2 RETURNING id;",
            &[&id, &session.user.id],
        )
        .await
        .map_err(AppError::default_response)?;

    let id: Uuid = row.try_get("id").map_err(AppError::default_response)?;

    return Ok(AppResponse::default_response(id));
}

pub fn users_routes() -> Router<AppState> {
    return Router::new().nest(
        "/users",
        Router::new()
            .route("/", post(create_user))
            .route("/{id}", get(read_user))
            .route("/list/company/{company_id}", get(list_user_company_id))
            .route("/list/location/{location_id}", get(list_user_location_id))
            .route("/{id}", patch(update_user))
            .route("/{id}", delete(delete_user)),
    );
}
