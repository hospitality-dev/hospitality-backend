use axum::{
    extract::{Path, State},
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use axum_extra::extract::{
    cookie::{Cookie, SameSite},
    PrivateCookieJar,
};
use deadpool_redis::redis::AsyncCommands;
use dotenv::var;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::{AuthInitResponse, AuthSession, CallbackQuery, Credentials},
        response::{AppErrorResponse, AppResponse},
        state::AppState,
    },
    utils::auth_utils::{generate_code_challenge, generate_code_verifier},
};
use common::consts::AUTH_SESSION_TIME;
async fn login(State(state): State<AppState>) -> Result<impl IntoResponse, AppErrorResponse> {
    let code_verifier = generate_code_verifier();
    let code_challenge = generate_code_challenge(&code_verifier);
    let state_param = Uuid::new_v4().to_string();
    let server_url = var("SERVER_URL").expect("No ENV var `SERVER_URL` set");
    let base_fe_url = var("BASE_FE_URL").expect("No ENV var `BASE_FE_URL` set");

    let mut v_conn = state.get_valkey_conn().await?;

    let _: () = v_conn
        .set_ex(&state_param, &code_verifier, 60)
        .await
        .map_err(AppError::critical_error)?;

    let auth_url = format!(
        "{}?code_challenge={}&code_challenge_method=S256&redirect_uri={}&state={}",
        format!("{}/login", base_fe_url),
        code_challenge,
        format!("{}/auth/callback", server_url),
        state_param
    );

    Ok(Json(AuthInitResponse {
        auth_url,
        state: state_param,
    }))
}

async fn callback(
    jar: PrivateCookieJar,
    State(state): State<AppState>,
    query: axum::extract::Query<CallbackQuery>,
) -> Result<(PrivateCookieJar, AppResponse<AuthSession>), AppErrorResponse> {
    let mut v_conn = state.get_valkey_conn().await?;
    let code_verifier: Option<String> = v_conn
        .get(&query.state)
        .await
        .map_err(AppError::critical_error)?;

    if code_verifier.is_none() {
        return Err(AppError::critical_error(
            "Invalid or expired state parameter",
        ));
    };

    let _: () = v_conn
        .del(&query.state)
        .await
        .map_err(AppError::default_response)?;

    let creds = Credentials {
        username: query.username.clone(),
        password: query.password.clone(),
    };

    let user_data = state.create_session(creds).await?;

    if let Some((session_id, user)) = user_data {
        let conn = state.get_db_conn().await?;
        let locations = user.get_user_locations(&conn).await?;
        if locations.is_empty() {
            Err(AppError::unauthorized_response(
                "No user locations found - user doesn't appear to belong to any location.",
            ))
        } else {
            let mut cookie = Cookie::new("session_id", session_id.clone());
            cookie.set_same_site(SameSite::Strict);
            cookie.set_secure(true);
            cookie.set_http_only(true);
            cookie.set_max_age(Some(time::Duration::seconds(AUTH_SESSION_TIME.into())));
            cookie.set_path("/");
            if locations.is_empty() {
                return Err(AppError::unauthorized_response(
                    "No user locations found - user doesn't appear to belong to any location.",
                ));
            }
            let location = locations.get(0).unwrap().to_owned();

            //* Updates permissions as well
            let auth_session = state
                .update_session_location(session_id.as_str(), location.location_id)
                .await?
                .unwrap();

            return Ok((jar.add(cookie), AppResponse::default_response(auth_session)));
        }
    } else {
        Err(AppError::unauthorized_response(
            "No user found OR user is not confirmed.",
        ))
    }
}

async fn get_session_data(
    jar: PrivateCookieJar,
    State(state): State<AppState>,
) -> Result<AppResponse<AuthSession>, AppErrorResponse> {
    let session_id = jar.get("session_id");
    if session_id.is_none() {
        return Err(AppError::unauthorized_response("Cookie not found."));
    }
    let session_id = session_id.unwrap();
    let session_id = session_id.value();
    let auth_session = state.get_session_data(session_id).await?;
    if let Some(session) = auth_session {
        return Ok(AppResponse::default_response(session));
    }
    return Err(AppError::unauthorized_response("No user session found."));
}

async fn change_session_location(
    jar: PrivateCookieJar,
    State(state): State<AppState>,
    Path(location_id): Path<Uuid>,
) -> Result<AppResponse<AuthSession>, AppErrorResponse> {
    let session_id = jar.get("session_id");
    if session_id.is_none() {
        return Err(AppError::unauthorized_response("Cookie not found."));
    }
    let session_id = session_id.unwrap();
    let session_id = session_id.value();

    //* Updates permissions as well
    let auth_session = state
        .update_session_location(session_id, location_id)
        .await?;

    if let Some(session) = auth_session {
        return Ok(AppResponse::default_response(session));
    } else {
        return Err(AppError::unauthorized_response("No user session."));
    }
}

pub fn auth_routes() -> Router<AppState> {
    Router::new().nest(
        "/auth",
        Router::new()
            .route("/login", post(login))
            .route("/callback", get(callback))
            .route("/session", get(get_session_data))
            .route(
                "/session/location/{location_id}",
                get(change_session_location),
            ),
    )
}
