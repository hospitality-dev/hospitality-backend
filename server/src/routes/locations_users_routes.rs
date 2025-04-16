use std::collections::HashMap;

use axum::{
    extract::{Path, Query, State},
    routing::{delete, get, post},
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
        locations_users::InsertLocationsUsers,
        requests::QueryParams,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
    utils::{db_utils::WhereBuilder, request_utils::convert_filter_type},
};

async fn create_locations_users(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Json(payload): Json<InsertLocationsUsers>,
) -> RouteResponse<Uuid> {
    let statement =
        "INSERT INTO locations_users (user_id, location_id, role_id) VALUES ($1, $2, $3) RETURNING user_id;";

    let conn = &state.get_db_conn().await?;

    let row = conn
        .query_one(
            statement,
            &[
                &payload.user_id,
                &session.user.location_id,
                &payload.role_id,
            ],
        )
        .await
        .map_err(AppError::default_response)?;

    let id = row.get("user_id");

    return Ok(AppResponse::default_response(id));
}

async fn list_locations_users(
    params: Query<QueryParams>,
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
) -> RouteResponse<Value> {
    let filters = match &params.0.filters {
        Some(f) => serde_json::from_str(f.as_str()).unwrap_or(None::<Value>),
        None => None,
    };
    let mut sql_params = Vec::new();

    sql_params.push(session.user.company_id.unwrap_or_default().to_string());

    let (filter_where, filter_params) =
        WhereBuilder::new(&Models::LocationsUsers, Some(sql_params.len()))
            .build_where_clause(&filters)?;

    sql_params.extend(filter_params);

    let statement = format!(
        "SELECT {}
        FROM
            locations_users
        INNER JOIN locations ON
            locations.id = locations_users.location_id
        WHERE
            locations.company_id = $1
                AND
            {};",
        fields, filter_where
    );

    let inputs_dyn: Vec<Box<dyn ToSql + Sync + Send>> = sql_params
        .iter()
        .map(convert_filter_type)
        .collect::<Vec<_>>();

    let inputs_dyn = inputs_dyn
        .iter()
        .map(|input| input.as_ref() as &(dyn ToSql + Sync))
        .collect::<Vec<_>>();

    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(&statement, &inputs_dyn)
        .await
        .map_err(AppError::default_response)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

async fn delete_locations_users(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(user_id): Path<Uuid>,
    Extension(model): Extension<Models>,
    Extension(action): Extension<Actions>,
) -> RouteResponse<Uuid> {
    let mut conn = state.get_db_conn().await?;

    let user = conn
        .query_one(
            "SELECT
            locations_users.id, locations_users.location_id, locations.company_id
    FROM
        locations_users
    JOIN locations
        ON locations_users.location_id = locations.id
    WHERE
        locations_users.user_id = $1
            AND
        locations_users.location_id = $2;",
            &[&user_id, &session.user.location_id],
        )
        .await
        .map_err(AppError::critical_error)?;

    let id: Uuid = user.get("id");
    let company_id: Uuid = user.get("company_id");
    let location_id: Uuid = user.get("location_id");

    let mut attr = HashMap::new();

    attr.insert(
        String::from("company_id"),
        CerbosAttrValue::Uuid(company_id),
    );
    attr.insert(
        String::from("location_id"),
        CerbosAttrValue::Uuid(location_id),
    );
    let resource = CerbosResource {
        id: id.to_string(),
        kind: model.to_string(),
        attr: Some(attr),
        scope: None,
    };

    let principal = session.user.to_principal();

    let check = CerbosCheck {
        principal,
        resources: vec![resource],
        model,
        action,
    };

    let permission = check.check_permission(&state).await?;

    if permission {
        let tx = conn.transaction().await.map_err(AppError::critical_error)?;

        let row = tx.query_one(
            "DELETE FROM locations_users WHERE locations_users.id = $1 RETURNING locations_users.user_id;",
            &[&id],
        )
        .await
        .map_err(AppError::critical_error)?;
        let user_id: Uuid = row.get("user_id");

        let count_row = tx
            .query_one(
                "SELECT COUNT(*) as count FROM locations_users WHERE locations_users.user_id = $1;",
                &[&user_id],
            )
            .await
            .map_err(AppError::critical_error)?;

        let count: i64 = count_row.get("count");

        // * If a user does not exist in any locations * //
        // * after deleting them from one              * //
        // * delete their account entirely             * //
        if count == 0 {
            tx.query("DELETE FROM users WHERE id = $1;", &[&user_id])
                .await
                .map_err(AppError::critical_error)?;
        }

        tx.commit().await.map_err(AppError::critical_error)?;

        return Ok(AppResponse::default_response(id));
    } else {
        return Err(AppError::forbidden_response("User has no permission to delete perform this action on this resource - DELETE | location users"));
    }
}

pub fn locations_users_routes() -> Router<AppState> {
    return Router::new().nest(
        "/locations-users",
        Router::new()
            .route("/", post(create_locations_users))
            .route("/list", get(list_locations_users))
            .route("/{id}", delete(delete_locations_users)),
    );
}
