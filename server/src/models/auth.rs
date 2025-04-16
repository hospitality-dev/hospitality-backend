use std::collections::HashMap;

use deadpool_postgres::Object;
use serde::{Deserialize, Serialize};
use tokio_postgres::Row;
use uuid::Uuid;

use crate::enums::{errors::AppError, requests::CerbosAttrValue, roles::Roles};

use super::{cerbos::CerbosPrincipal, contacts::Contact, response::AppErrorResponse};

#[derive(Serialize)]
pub struct AuthInitResponse {
    pub auth_url: String,
    pub state: String, // We'll use this to lookup the code_verifier
}

#[derive(Deserialize)]
pub struct CallbackQuery {
    pub state: String,
    pub username: String,
    pub password: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct AuthUser {
    pub id: Uuid,
    pub username: String,
    pub contacts: Option<Vec<Contact>>,
    pub first_name: String,
    pub last_name: String,
    pub image_id: Option<Uuid>,
    // * Required for generating principal using the session.user
    // * See fn to_principal below
    pub location_id: Option<Uuid>,
    pub location_title: Option<String>,
    pub role_id: Option<Uuid>,
    pub role: Option<Roles>,
    pub company_id: Option<Uuid>,
    pub permissions: Option<AuthUserPermissions>,
}

impl AuthUser {
    pub fn from_row(row: &Row) -> Self {
        let id: Uuid = row.get("id");
        let username: String = row.get("username");
        // let contacts: Option<Value> = row.get("contacts");
        let first_name: String = row.get("first_name");
        let last_name: String = row.get("last_name");
        let image_id: Option<Uuid> = row.get("image_id");

        // * Required for generating principal using the session.user
        // * See fn to_principal below
        let location_id: Option<Uuid> = None;
        let location_title: Option<String> = None;
        let role_id: Option<Uuid> = None;
        let company_id: Option<Uuid> = None;
        let role = None;
        //*
        let permissions: Option<AuthUserPermissions> = None;

        Self {
            id,
            username,
            contacts: None,
            first_name,
            last_name,
            image_id,
            location_id,
            location_title,
            role_id,
            role,
            company_id,
            permissions,
        }
    }
    pub async fn get_user_locations(
        &self,
        conn: &Object,
    ) -> Result<Vec<AuthLocationOption>, AppErrorResponse> {
        let result = conn
            .query(
                "SELECT
                        locations.title, location_id, role_id,
                        locations.image_id,
                        locations.company_id, roles.title as role
                    FROM
                        locations_users
                    LEFT JOIN locations
                        ON locations.id = locations_users.location_id
                    LEFT JOIN roles
                        ON locations_users.role_id = roles.id
                    WHERE
                        locations_users.user_id = $1
                    ORDER BY
                        locations.title;",
                &[&self.id],
            )
            .await
            .map_err(AppError::default_response)?;

        let options: Vec<AuthLocationOption> = result
            .iter()
            .map(|row| {
                let location_id = row.get("location_id");
                let location_title = row.get("title");
                let role_id = row.get("role_id");
                let role = row.get("role");
                let company_id = row.get("company_id");
                let image_id: Option<Uuid> = row.get("image_id");
                AuthLocationOption {
                    location_id,
                    location_title,
                    role_id,
                    role,
                    company_id,
                    image_id,
                }
            })
            .collect();

        Ok(options)
    }

    pub fn to_principal(self) -> CerbosPrincipal {
        let mut attr: HashMap<String, CerbosAttrValue> = HashMap::new();

        attr.insert(String::from("id"), CerbosAttrValue::Uuid(self.id));

        attr.insert(
            String::from("company_id"),
            CerbosAttrValue::Uuid(self.company_id.unwrap_or(Uuid::nil())),
        );
        attr.insert(
            String::from("location_id"),
            CerbosAttrValue::Uuid(self.location_id.unwrap_or(Uuid::nil())),
        );

        CerbosPrincipal {
            id: self.id.to_string(),
            scope: None,
            roles: vec![self.role.unwrap_or(Roles::None)],
            attr: Some(attr),
        }
    }
}

#[derive(Deserialize)]
pub struct Credentials {
    pub username: String,
    pub password: String,
}

#[derive(Serialize, Clone, Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct AuthLocationOption {
    pub location_id: Uuid,
    pub location_title: String,
    pub role_id: Uuid,
    pub role: String,
    pub company_id: Uuid,
    pub image_id: Option<Uuid>,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct AuthSession {
    pub user: AuthUser,
}

pub type AuthUserPermissions = HashMap<String, HashMap<String, bool>>;
