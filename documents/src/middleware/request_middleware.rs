use axum::{
    extract::{Request, State},
    middleware::Next,
    response::Response,
};
use reqwest::StatusCode;

use crate::models::state::AppState;
/// Blocks requests that do not originate from the server

pub async fn block_request(
    State(state): State<AppState>,
    req: Request,
    next: Next,
) -> Result<Response, StatusCode> {
    match req.headers().get("x-documents-api-key") {
        Some(val) if val.to_str().unwrap_or_default() == state.documents_api_key => {
            Ok(next.run(req).await)
        }
        _ => Err(StatusCode::UNAUTHORIZED),
    }
}
