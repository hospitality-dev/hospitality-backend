use std::collections::HashMap;

use crate::{
    enums::{errors::AppError, models::Models, roles::Roles},
    models::cerbos::CerbosResponse,
};
use argon2::{Argon2, PasswordHash, PasswordVerifier};
use aws_sdk_s3::Client as S3Client;
use axum::extract::FromRef;
use axum_extra::extract::cookie::Key;
use common::consts::{AUTH_SESSION_TIME, DUMMY_PASSWORD};
use deadpool_postgres::{Object, Pool};
use deadpool_redis::{redis::AsyncCommands, Connection, Pool as ValkeyPool};
use rand::{distr::Alphanumeric, Rng};
use reqwest::Client as ReqwestClient;
use serde_json::{json, Value};
use strum::VariantNames;
use uuid::Uuid;

use super::{
    auth::{AuthSession, AuthUser, AuthUserPermissions, Credentials},
    response::AppErrorResponse,
};

#[derive(Clone)]
pub struct AppState {
    pub server_url: String,
    pub db_pool: Pool,
    pub rqw_client: ReqwestClient,
    pub valkey: ValkeyPool,
    pub cerbos_url: String,
    pub cookie_key: Key,
    pub s3_client: S3Client,
    pub s3_name: String,
    pub document_server_url: String,
}

impl AppState {
    pub async fn get_valkey_conn(&self) -> Result<Connection, AppErrorResponse> {
        let conn = self.valkey.get().await.map_err(AppError::critical_error)?;

        Ok(conn)
    }

    pub async fn get_db_conn(&self) -> Result<Object, AppErrorResponse> {
        let connection = self.db_pool.get().await.map_err(AppError::critical_error)?;
        Ok(connection)
    }

    pub async fn create_session(
        &self,
        creds: Credentials,
    ) -> Result<Option<(String, AuthUser)>, AppErrorResponse> {
        let mut v_conn = self.get_valkey_conn().await?;

        let pg_conn = self.get_db_conn().await?;

        let result = pg_conn
            .query_opt(
                "SELECT
                    users.id, users.username, users.first_name,
                    users.last_name, users.image_id, users.pw_hsh,
                    users.is_verified
                FROM
                    users
                WHERE
                    username = $1;",
                &[&creds.username],
            )
            .await
            .map_err(AppError::unauthorized_response)?;

        if let Some(row) = result {
            let is_verified: bool = row.get("is_verified");

            if !is_verified {
                let parsed_hash = PasswordHash::new(&DUMMY_PASSWORD).map_err(|e| {
                    tracing::error!("ERROR CREATING PASSWORD HASH - {}", e.to_string());
                    AppError::default_response(e.to_string())
                })?;

                let _ = Argon2::default()
                    .verify_password(creds.password.as_bytes(), &parsed_hash)
                    .is_ok();

                return Ok(None);
            }
            let pw_hash: String = row.get("pw_hsh");
            let parsed_hash = PasswordHash::new(&pw_hash).map_err(|e| {
                tracing::error!("ERROR CREATING PASSWORD HASH - {}", e.to_string());
                AppError::default_response(e.to_string())
            })?;

            let pass_verified = Argon2::default()
                .verify_password(creds.password.as_bytes(), &parsed_hash)
                .is_ok();
            if pass_verified {
                let user = AuthUser::from_row(&row);
                let locations = user.get_user_locations(&pg_conn).await?;
                let session_id: String = rand::rng()
                    .sample_iter(&Alphanumeric)
                    .take(32) // 32-character random session ID
                    .map(char::from)
                    .collect();

                let _: () = v_conn
                    .set_ex(
                        &session_id,
                        json!({"user":user, "locations": locations}).to_string(),
                        AUTH_SESSION_TIME as u64,
                    )
                    .await
                    .map_err(AppError::unauthorized_response)?;

                return Ok(Some((session_id, user)));
            } else {
                return Ok(None);
            }
        } else {
            let parsed_hash = PasswordHash::new(&DUMMY_PASSWORD).map_err(|e| {
                tracing::error!("ERROR CREATING PASSWORD HASH - {}", e.to_string());
                AppError::default_response(e.to_string())
            })?;

            let _ = Argon2::default()
                .verify_password(creds.password.as_bytes(), &parsed_hash)
                .is_ok();

            Ok(None)
        }
    }

    pub async fn get_session_data(
        &self,
        id: &str,
    ) -> Result<Option<AuthSession>, AppErrorResponse> {
        let mut v_conn = self.get_valkey_conn().await?;

        let data: Option<String> = v_conn
            .get(id)
            .await
            .map_err(AppError::unauthorized_response)?;

        if let Some(session) = data {
            let auth_session = serde_json::from_str::<AuthSession>(&session)
                .map_err(AppError::unauthorized_response)?;

            return Ok(Some(auth_session));
        }

        return Ok(None);
    }

    pub async fn update_session_location(
        &self,
        id: &str,
        location_id: Uuid,
    ) -> Result<Option<AuthSession>, AppErrorResponse> {
        let mut v_conn = self.get_valkey_conn().await?;

        let data: Option<String> = v_conn
            .get(id)
            .await
            .map_err(AppError::unauthorized_response)?;

        if let Some(session) = data {
            let auth_session = serde_json::from_str::<AuthSession>(&session)
                .map_err(AppError::unauthorized_response)?;

            let conn = &self.get_db_conn().await?;
            let locations = auth_session.user.get_user_locations(&conn).await?;

            if locations.is_empty() {
                return Ok(Some(auth_session));
            }

            let location = locations.iter().find(|loc| loc.location_id == location_id);

            if location.is_none() {
                return Ok(Some(auth_session));
            }
            let location = location.unwrap().to_owned();
            let role = Roles::from(location.role);
            let permissions = self
                .get_user_model_permissions(&auth_session.user.id, &role)
                .await
                .unwrap_or(HashMap::new());
            let updated_session = AuthSession {
                user: AuthUser {
                    id: auth_session.user.id,
                    username: auth_session.user.username,
                    contacts: auth_session.user.contacts,
                    first_name: auth_session.user.first_name,
                    last_name: auth_session.user.last_name,
                    image_id: auth_session.user.image_id,
                    location_id: Some(location.location_id),
                    location_title: Some(location.location_title),
                    role_id: Some(location.role_id),
                    role: Some(role),
                    company_id: Some(location.company_id),
                    permissions: Some(permissions),
                },
            };

            let _: () = v_conn
                .set_ex(
                    id,
                    json!(updated_session).to_string(),
                    AUTH_SESSION_TIME as u64,
                )
                .await
                .map_err(AppError::critical_error)?;

            return Ok(Some(updated_session));
        }

        return Ok(None);
    }

    pub async fn get_user_model_permissions(
        &self,
        user_id: &Uuid,
        role: &Roles,
    ) -> Result<AuthUserPermissions, AppErrorResponse> {
        let req_body = serde_json::json!({
            "requestId": Uuid::new_v4(),
            "principal": {
                "id": user_id,
                "roles": vec![role],
            },
            "resources": Models::VARIANTS.iter().filter_map(|v| {
                if v == &"unknown" {
                    return None
                };
                return Some(serde_json::json!({"resource": {"kind": format!("{}:model", v), "id": Uuid::nil()}, "actions": vec!["create", "list", "view", "update", "archive", "delete"]}))
            }).collect::<Vec<Value>>(),
            "includeMeta": true
        });

        let p = self
            .rqw_client
            .post(format!("{}/api/check/resources", &self.cerbos_url))
            .json(&req_body)
            .send()
            .await
            .map_err(AppError::forbidden_response)?;

        let check: CerbosResponse = p
            .json::<CerbosResponse>()
            .await
            .map_err(AppError::critical_error)?;

        return Ok(check.map_to_hashmap());
    }

    pub async fn delete_session_data(&self, id: String) -> Result<bool, AppErrorResponse> {
        let mut v_conn = self.get_valkey_conn().await?;

        let _: () = v_conn
            .del(id)
            .await
            .map_err(AppError::unauthorized_response)?;

        return Ok(true);
    }
}

// this impl tells `PrivateCookieJar` how to access the key from our state
impl FromRef<AppState> for Key {
    fn from_ref(state: &AppState) -> Self {
        state.cookie_key.clone()
    }
}
