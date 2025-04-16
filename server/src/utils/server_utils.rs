use reqwest::Method;
use uuid::Uuid;

use crate::{
    enums::{actions::Actions, errors::AppError},
    models::response::AppErrorResponse,
};

use std::{str::FromStr, usize::MAX};

use anyhow::Result;
use axum::{
    body::{to_bytes, Body, Bytes},
    extract::Request,
    http::StatusCode,
    response::{IntoResponse, Response},
};

async fn print_body(bytes: Bytes) -> String {
    let str = String::from_utf8_lossy(&bytes).into_owned();
    str
}

pub async fn map_extractor_errors(
    req: Request,
    next: axum::middleware::Next,
) -> Result<Response, AppErrorResponse> {
    let (parts, body) = req.into_parts();

    let bytes = to_bytes(body, MAX)
        .await
        .map_err(AppError::critical_error)?;

    let request = Request::from_parts(parts, Body::from(bytes.clone()));
    let response = next.run(request).await;

    match response.status() {
        StatusCode::OK => Ok(response),
        StatusCode::UNAUTHORIZED | StatusCode::FORBIDDEN => Ok(response.status().into_response()),
        _ => Ok(AppError::default_response(print_body(bytes).await).into_response()),
    }
}

pub fn extract_action_from_url(uri: &str, method: &Method) -> Actions {
    let action = if let Ok(id) = Uuid::from_str(uri.split("/").last().unwrap_or("")) {
        match method {
            &Method::GET => Actions::View(id),
            &Method::DELETE => Actions::Delete(id),
            &Method::PATCH => Actions::Update(id),
            _ => Actions::None,
        }
    } else if uri.contains("/list") && method == &Method::GET {
        Actions::List
    } else if method == &Method::GET {
        Actions::View(Uuid::nil())
    } else if method == Method::POST {
        Actions::Create
    } else {
        Actions::None
    };

    return action;
}

pub fn extract_action_id(action: &Actions) -> Option<&Uuid> {
    match action {
        Actions::View(uuid) => Some(uuid),
        Actions::Update(uuid) => Some(uuid),
        Actions::Delete(uuid) => Some(uuid),
        _ => None,
    }
}
