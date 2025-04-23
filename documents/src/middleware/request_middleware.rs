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
    let uri = req.uri();
    if let Some(host) = uri.host() {
        if host.starts_with(&state.server_url) {
            return Ok(next.run(req).await);
        }
    }
    return Err(StatusCode::UNAUTHORIZED);
}
