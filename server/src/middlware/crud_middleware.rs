use std::{collections::HashSet, str::FromStr, usize::MAX};

use axum::{
    body::{self, Body},
    extract::{Path, Query, Request, State},
    http::Response,
    middleware::Next,
    response::IntoResponse,
    Extension,
};

use axum_extra::extract::PrivateCookieJar;
use tracing::{error, info};
use uuid::Uuid;

use crate::{
    enums::{actions::Actions, errors::AppError, models::Models},
    models::{
        auth::AuthSession,
        cerbos::{CerbosCheck, CerbosPrincipal, CerbosResource},
        requests::QueryParams,
        response::{AppErrorResponse, AppResponse},
    },
    traits::model_traits::{AllowedFields, SelectableFields},
    utils::{
        db_utils::get_select_string,
        server_utils::{extract_action_from_url, extract_action_id},
        transform_utils::bytes_to_json_value,
    },
    AppState,
};

pub type AllowedFieldsType = String;

pub async fn global_model_middleware(
    req: Request,
    next: Next,
) -> Result<Response<Body>, AppErrorResponse> {
    let (mut parts, body) = req.into_parts();
    let uri = parts.uri.path();

    let model = uri.split('/').nth(1).map(|s| s.to_string());
    if let Some(model) = model {
        let extracted_model =
            Models::from_str(model.as_str()).map_err(AppError::default_response)?;

        let action = extract_action_from_url(&uri, &mut parts.method);
        parts.extensions.insert(extracted_model);
        parts.extensions.insert(action);

        let response = next.run(Request::from_parts(parts, body)).await;
        return Ok(response);
    }

    Err(AppError::default_response(format!(
        "Model not found in path: {}",
        uri
    )))
}

pub async fn session_check(
    State(state): State<AppState>,
    jar: PrivateCookieJar,
    mut request: Request,
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
    request.extensions_mut().insert(session);

    let response = next.run(request).await;
    return Ok(response);
}

pub async fn permission_check(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    query: Query<QueryParams>,
    request: Request,
    next: Next,
) -> Result<Response<Body>, AppErrorResponse> {
    let (mut parts, body) = request.into_parts();

    let model: Option<&Models> = parts.extensions.get::<Models>();

    let model: Models = model
        .unwrap_or(&Models::Unknown("UNKNOWN_MODEL".to_string()))
        .to_owned();

    let action: Actions = parts
        .extensions
        .get::<Actions>()
        .unwrap_or(&Actions::None)
        .to_owned();

    let fields = match action {
        Actions::View(_id) => query.0.fields,
        Actions::List => query.0.fields,
        _ => None,
    };

    //* Fields which are allowed to be extracted from the database in general */
    let model_allowed_fields = model.get_allowed_fields().unwrap();
    //* Fields which have been requested */
    let query_fields = Models::get_fields_from_query_string(fields);
    let query_fields: HashSet<&str> = query_fields.iter().map(|f| f.as_str()).collect();
    //* If no fields were requested or no fields are allowed return an empty response */
    if action != Actions::Generate && (model_allowed_fields.is_empty() || query_fields.is_empty()) {
        if matches!(action, Actions::View(_)) {
            return Ok(AppResponse::default_response(serde_json::json!({})).into_response());
        } else if action == Actions::List {
            return Ok(AppResponse::default_response(serde_json::json!([])).into_response());
        }
    }
    let resource_id: Uuid = extract_action_id(&action)
        .map(|id| id.to_owned())
        .unwrap_or(Uuid::nil());

    let principal = CerbosPrincipal {
        id: session.user.id.to_string(),
        scope: None,
        roles: vec![session
            .user
            .role
            .as_ref()
            .unwrap_or(&crate::enums::roles::Roles::None)
            .clone()],
        attr: None,
    };

    let bytes = body::to_bytes(body, MAX)
        .await
        .map_err(AppError::critical_error)?;
    let resources: Vec<CerbosResource> = match action {
        Actions::Create => {
            if model == Models::Files {
                vec![CerbosResource {
                    id: action.to_string(),
                    kind: format!("{}:{}", model.to_string(), "create"),
                    attr: None,
                    scope: None,
                }]
            } else {
                let payload = bytes_to_json_value(&bytes)?;

                payload
                    .as_object()
                    .unwrap_or(&serde_json::Map::new())
                    .keys()
                    .map(|k| CerbosResource {
                        id: action.to_string(),
                        kind: format!("{}:{}", model.to_string(), k),
                        attr: None,
                        scope: None,
                    })
                    .collect()
            }
        }

        Actions::Archive(id) | Actions::Delete(id) => {
            vec![CerbosResource {
                id: id.to_string(),
                kind: model.to_string(),
                attr: None,
                scope: None,
            }]
        }
        Actions::Update(_) => {
            let payload = bytes_to_json_value(&bytes)?;

            payload
                .as_object()
                .unwrap()
                .keys()
                .map(|k| CerbosResource {
                    id: action.to_string(),
                    kind: format!("{}:{}", model.to_string(), k),
                    attr: None,
                    scope: None,
                })
                .collect()
        }
        Actions::Download(_) => vec![CerbosResource {
            id: action.to_string(),
            kind: format!("{}:{}", model.to_string(), "download"),
            attr: None,
            scope: None,
        }],

        _ => model_allowed_fields
            .intersection(&query_fields)
            .map(|s| CerbosResource {
                id: format!("{}-{}", resource_id, s),
                kind: format!("{}:{}", model.to_string(), s),
                attr: None,
                scope: None,
            })
            .collect(),
    };

    let permission_check = CerbosCheck {
        model: model.to_owned(),
        action,
        principal,
        resources,
    };
    let is_model_allowed = permission_check
        .is_allowed_model(&state.rqw_client, &state.cerbos_url)
        .await?;

    if !is_model_allowed {
        return Err(AppError::forbidden_response(format!(
            "No permission to perform this action for this entity. | MODEL: {} | ACTION: {} | ROLE: {}",
            model.to_string(),
            permission_check.action.to_string(),
            session
                .user
                .role
                .unwrap_or(crate::enums::roles::Roles::None)
        )));
    }

    match &permission_check.action {
        Actions::View(_) | Actions::List => {
            let allowed_fields = permission_check
                .is_allowed_fields(&state.rqw_client, &state.cerbos_url)
                .await?;

            if allowed_fields.len() == 0 {
                return Err(AppError::forbidden_response(format!(
                    "No fields allowed for this model by this role. | MODEL: {} | ROLE: {}",
                    model.to_string(),
                    session
                        .user
                        .role
                        .unwrap_or(crate::enums::roles::Roles::None)
                )));
            }
            let allowed_fields: AllowedFieldsType = get_select_string(&model, allowed_fields);
            parts.extensions.insert(allowed_fields);
        }
        _ => {}
    };
    parts.extensions.insert(action);
    let response = next.run(Request::from_parts(parts, bytes.into())).await;

    Ok(response)
}

pub async fn api_logging_middleware(
    Path(params): Path<Vec<(String, String)>>,
    req: Request,
    next: Next,
) -> Result<Response<Body>, AppErrorResponse> {
    let location = std::panic::Location::caller();

    let model = req.extensions().get::<Models>();
    let model = model
        .unwrap_or(&Models::Unknown("NONE".to_string()))
        .to_owned();

    let action = req
        .extensions()
        .get::<Actions>()
        .unwrap_or(&Actions::None)
        .to_string();

    let uri = req.uri().to_string();

    let path_params: String = params
        .iter()
        .map(|p| format!("{} => {}", p.0, p.1))
        .collect::<Vec<String>>()
        .join(" | ");

    if req.uri().path().contains("/search/") {
        let model = req
            .uri()
            .path()
            .split("/search/")
            .last()
            .unwrap_or_default();
        info!(
            name = "| REQUEST LOG |",
            model = model,
            action = action,
            path_params = path_params,
            uri = uri,
            call_path = format!("{} -> {}", location.file(), location.line())
        );

        let response = next.run(req).await;

        return Ok(response);
    }

    match model {
        Models::Unknown(name) => {
            error!(
                name = format!("| REQUEST LOG |").as_str(),
                model = name,
                action = action,
                path_params = path_params,
                uri = uri,
                call_path = format!("{} -> {}", location.file(), location.line())
            );
        }
        _ => {
            let model = model.to_string();

            info!(
                name = "| REQUEST LOG |",
                model = model,
                action = action,
                path_params = path_params,
                uri = uri,
                call_path = format!("{} -> {}", location.file(), location.line())
            );
        }
    }

    let response = next.run(req).await;

    Ok(response)
}
