use chrono::NaiveDate;
use garde::Validate;
use is_empty::IsEmpty;
use serde::Deserialize;
use uuid::Uuid;

use super::contacts::{Contact, MutatorContact};

#[derive(Debug, Validate, Deserialize)]
#[garde(allow_unvalidated)]
#[serde(rename_all = "camelCase")]
pub struct InsertUser {
    pub first_name: String,
    pub last_name: String,
    pub username: String,
    #[garde(length(min = 8), matches(password2))]
    pub password1: String,
    #[garde(matches(password1))]
    pub password2: String,
    pub image_id: Option<Uuid>,
    #[serde(default)]
    pub date_of_birth: Option<NaiveDate>,
    #[serde(default)]
    pub date_of_employment: Option<NaiveDate>,
    #[serde(default)]
    pub date_of_termination: Option<NaiveDate>,
    pub role_id: Uuid,
    pub contacts: Option<Vec<Contact>>,
}

#[derive(Debug, Validate, Deserialize, IsEmpty)]
#[garde(allow_unvalidated)]
#[serde(rename_all = "camelCase")]
pub struct UpdateUser {
    pub first_name: Option<String>,
    pub last_name: Option<String>,
    pub username: Option<String>,
    #[garde(length(min = 8), matches(password2))]
    pub password1: Option<String>,
    #[garde(matches(password1))]
    pub password2: Option<String>,
    pub image_id: Option<Uuid>,
    pub contacts: Option<Vec<MutatorContact>>,
}
