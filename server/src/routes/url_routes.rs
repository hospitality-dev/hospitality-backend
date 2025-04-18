use aws_sdk_s3::presigning::PresigningConfig;
use axum::{
    extract::{Path, State},
    http::HeaderValue,
    response::IntoResponse,
    routing::get,
    Extension, Router,
};
use convert_case::{Case, Casing};
use reqwest::{
    header::{CACHE_CONTROL, CONTENT_TYPE},
    StatusCode,
};
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{auth::AuthSession, response::AppErrorResponse, state::AppState},
};
use common::consts::PRESIGN_DURATION;

async fn location_logo_url_route(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> impl IntoResponse {
    let command: &aws_sdk_s3::presigning::PresignedRequest = &state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/locations/{}/{}",
            &session.user.company_id.unwrap(),
            &session.user.location_id.unwrap(),
            &id
        ))
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .unwrap();

    let url = command.uri();
    return (
        StatusCode::OK,
        [
            (CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap()),
            (CACHE_CONTROL, HeaderValue::from_str("max-age=600").unwrap()),
        ],
        url.to_string(),
    );
}
async fn user_avatar_url_route(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> impl IntoResponse {
    let command: &aws_sdk_s3::presigning::PresignedRequest = &state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/users/{}",
            &session.user.company_id.unwrap(),
            &id
        ))
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .unwrap();

    let url = command.uri();
    return (
        StatusCode::OK,
        [
            (CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap()),
            (
                CACHE_CONTROL,
                HeaderValue::from_str("max-age=3600").unwrap(),
            ),
        ],
        url.to_string(),
    );
}

async fn get_file_url(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Path((file_category, id)): Path<(String, Uuid)>,
) -> Result<impl IntoResponse, AppErrorResponse> {
    let key = format!(
        "{}/{}/{}/{}",
        session.user.company_id.unwrap(),
        session.user.location_id.unwrap(),
        file_category.to_case(Case::Kebab),
        id
    );
    let output = state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(&key)
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .map_err(AppError::critical_error)?;

    let url = output.uri().to_owned();

    return Ok((
        StatusCode::OK,
        [(CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap())],
        url,
    ));
}

pub fn url_routes() -> Router<AppState> {
    return Router::new().nest(
        "/url",
        Router::new()
            .route("/{id}/location-logo", get(location_logo_url_route))
            .route("/{id}/user-avatar", get(user_avatar_url_route))
            .route("/{file_category}/{id}", get(get_file_url)),
    );
}
