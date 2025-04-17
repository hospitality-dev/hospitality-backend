use axum::{Router, response::IntoResponse, routing::post};

use crate::models::state::AppState;

async fn generate_from_template() -> Result<impl IntoResponse, String> {
    Ok(())
}

pub fn generate_routes() -> Router<AppState> {
    return Router::new().nest(
        "/generate",
        Router::new().route("/from-template", post(generate_from_template)),
    );
}
