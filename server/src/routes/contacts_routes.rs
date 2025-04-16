use axum::{
    extract::{Path, State},
    routing::get,
    Extension, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models},
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        cerbos::{CerbosCheck, CerbosResource},
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn list_contacts_location(
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    State(state): State<AppState>,
    Path(location_id): Path<Uuid>,
) -> RouteResponse<Value> {
    let principal = session.user.to_principal();
    let resource = CerbosResource {
        id: location_id.to_string(),
        kind: Models::Locations.to_string(),
        attr: None,
        scope: None,
    };
    let check = CerbosCheck {
        principal,
        resources: vec![resource],
        action: Actions::View(location_id),
        model: Models::Locations,
    };

    let has_permission = check.check_permission(&state).await?;
    if has_permission {
        let mapped_fields = fields.replace("contacts.", "locations_contacts.");
        let conn = &state.get_db_conn().await?;
        let result = conn
            .query(
                &format!(
                    "SELECT {} FROM locations_contacts WHERE parent_id = $1;",
                    mapped_fields
                ),
                &[&location_id],
            )
            .await
            .map_err(AppError::critical_error)?;

        return Ok(AppResponse::default_response(result.serialize_list(true)));
    } else {
        return Err(AppError::forbidden_response("User is not permitted to perform this action. MODEL locations | ACTION view | contacts_list"));
    }
}

async fn list_contacts_user(
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    State(state): State<AppState>,
    Path(user_id): Path<Uuid>,
) -> RouteResponse<Value> {
    let principal = session.user.to_principal();
    let resource = CerbosResource {
        id: user_id.to_string(),
        kind: Models::Users.to_string(),
        attr: None,
        scope: None,
    };
    let check = CerbosCheck {
        principal,
        resources: vec![resource],
        action: Actions::View(user_id),
        model: Models::Users,
    };

    let has_permission = check.check_permission(&state).await?;
    if has_permission {
        let mapped_fields = fields.replace("contacts.", "users_contacts.");
        let conn = &state.get_db_conn().await?;
        let result = conn
            .query(
                &format!(
                    "SELECT {} FROM users_contacts WHERE parent_id = $1;",
                    mapped_fields
                ),
                &[&user_id],
            )
            .await
            .map_err(AppError::critical_error)?;

        return Ok(AppResponse::default_response(result.serialize_list(true)));
    } else {
        return Err(AppError::forbidden_response("User is not permitted to perform this action. MODEL users | ACTION view | contacts_list"));
    }
}

pub fn contacts_routes() -> Router<AppState> {
    Router::new().nest(
        "/contacts",
        Router::new()
            .route("/list/location/{location_id}", get(list_contacts_location))
            .route("/list/user/{user_id}", get(list_contacts_user)),
    )
}
