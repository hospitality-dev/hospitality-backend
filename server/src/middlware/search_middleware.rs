use std::usize::MAX;

use axum::{
    body::{self, Body},
    extract::{Request, State},
    http::Response,
    middleware::Next,
};
use axum_extra::extract::PrivateCookieJar;

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models},
    models::{
        cerbos::{CerbosCheck, CerbosResource},
        response::AppErrorResponse,
        state::AppState,
    },
};

pub async fn search_permission_check(
    jar: PrivateCookieJar,
    State(state): State<AppState>,
    request: Request,
    next: Next,
) -> Result<Response<Body>, AppErrorResponse> {
    let session_id = jar.get("session_id");
    if session_id.is_none() {
        return Err(AppError::unauthorized_response(
            "No session_id cookie found.",
        ));
    }
    let session_id = session_id.unwrap();
    let session_id = session_id.value();

    let session = state.get_session_data(session_id).await?;

    if session.is_none() {
        return Err(AppError::unauthorized_response(
            "No session with session_id found.",
        ));
    }
    let session = session.unwrap();
    let (parts, body) = request.into_parts();

    let model = parts.uri.path().to_string();
    let model = model.split('/').last();
    if model.is_none() {
        return Err(AppError::forbidden_response(
            "No model for searching found.",
        ));
    }
    let model = model.unwrap();

    let principal = session.user.to_principal();
    let resource = CerbosResource {
        id: String::from("NONE"),
        kind: format!("search:{}", model),
        scope: None,
        attr: None,
    };
    let check = CerbosCheck {
        model: Models::Unknown("address".to_string()),
        action: Actions::Search,
        principal,
        resources: vec![resource],
    };

    let has_permission = check.check_permission(&state).await?;
    if has_permission {
        let bytes = body::to_bytes(body, MAX)
            .await
            .map_err(AppError::critical_error)?;
        let response = next.run(Request::from_parts(parts, bytes.into())).await;
        return Ok(response);
    }

    return Err(AppError::forbidden_response(
        "User has no permission to perform this action | MODEL address | ACTION search",
    ));
}
