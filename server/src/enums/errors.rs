use axum::http::StatusCode;
use thiserror::Error;
use tracing::{error, warn};

use crate::models::response::AppErrorResponse;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("There was an error with your request.")]
    ErrorWithRequest,
    #[error("Unauthorized.")]
    Unauthorized,
    #[error("You are not authorized to perform this action.")]
    Forbidden,
}

impl AppError {
    #[track_caller]
    pub fn default_response(err: impl ToString) -> AppErrorResponse {
        let location = std::panic::Location::caller();
        error!(
            message = err.to_string(),
            kind = "DEFAULT ERROR RESPONSE",
            call_path = format!("{} -> {}", location.file(), location.line())
        );

        return AppErrorResponse {
            status_code: StatusCode::INTERNAL_SERVER_ERROR,
            ok: false,
            message: AppError::ErrorWithRequest.to_string(),
        };
    }
    #[track_caller]
    pub fn unauthorized_response(err: impl ToString) -> AppErrorResponse {
        let location = std::panic::Location::caller();

        warn!(
            message = err.to_string(),
            kind = "UNAUTHORIZED RESPONSE",
            call_path = format!("{} -> {}", location.file(), location.line())
        );
        return AppErrorResponse {
            status_code: StatusCode::UNAUTHORIZED,
            ok: false,
            message: AppError::Unauthorized.to_string(),
        };
    }
    #[track_caller]
    pub fn forbidden_response(err: impl ToString) -> AppErrorResponse {
        let location = std::panic::Location::caller();

        warn!(
            message = err.to_string(),
            kind = "FORBIDDEN RESPONSE",
            call_path = format!("{} -> {}", location.file(), location.line())
        );
        return AppErrorResponse {
            status_code: StatusCode::FORBIDDEN,
            ok: false,
            message: AppError::Forbidden.to_string(),
        };
    }
    #[track_caller]
    pub fn critical_error(err: impl ToString) -> AppErrorResponse {
        let location = std::panic::Location::caller();

        error!(
            message = err.to_string(),
            kind = "CRITICAL ERROR",
            call_path = format!("{} -> {}", location.file(), location.line())
        );
        // TODO: implement sending email & discord alerts
        return AppErrorResponse {
            status_code: StatusCode::INTERNAL_SERVER_ERROR,
            ok: false,
            message: AppError::ErrorWithRequest.to_string(),
        };
    }
}
