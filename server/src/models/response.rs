use anyhow::Result;
use axum::{
    body::Body,
    response::{IntoResponse, Response},
};
use reqwest::StatusCode;
use serde::Serialize;

use crate::enums::{errors::AppError, response_messages::ResponseMessages};

#[derive(Serialize, Debug)]
pub struct AppResponse<T> {
    pub data: Option<T>,
    pub ok: bool,
    pub message: String,
    #[serde(skip_serializing)]
    pub status_code: StatusCode,
}

impl<T> AppResponse<T> {
    pub fn default_response(data: T) -> Self {
        return Self {
            data: Some(data),
            ok: true,
            message: ResponseMessages::Success.to_string(),
            status_code: StatusCode::OK,
        };
    }
}

impl<T> IntoResponse for AppResponse<T>
where
    T: Serialize + Send + 'static,
{
    fn into_response(self) -> axum::response::Response {
        let json_body = serde_json::to_string(&self)
            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
            .unwrap();

        let res = Response::builder()
            .status(self.status_code)
            .header("Content-Type", "application/json")
            .body(Body::from(json_body))
            .map_err(AppError::default_response)
            .unwrap();
        return res;
    }
}

#[derive(Serialize, Debug)]
pub struct AppErrorResponse {
    pub ok: bool,
    pub message: String,
    #[serde(skip_serializing)]
    pub status_code: StatusCode,
}

impl IntoResponse for AppErrorResponse {
    fn into_response(self) -> axum::response::Response {
        let json_body = serde_json::to_string(&self)
            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
            .unwrap();

        let res = Response::builder()
            .status(self.status_code)
            .header("Content-Type", "application/json")
            .body(Body::from(json_body))
            .map_err(AppError::default_response)
            .unwrap();
        return res;
    }
}

pub type RouteResponse<T> = Result<AppResponse<T>, AppErrorResponse>;
