use garde::Validate;
use rust_decimal::Decimal;
use serde::Deserialize;

use super::contacts::{Contact, MutatorContact};

#[derive(Debug, Validate, Deserialize)]
#[garde(allow_unvalidated)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocation {
    //* owner_id comes from session
    pub title: String,
    pub contacts: Option<Vec<Contact>>,
    pub longitude: Option<Decimal>,
    pub latitude: Option<Decimal>,
}

#[derive(Debug, Validate, Deserialize)]
#[garde(allow_unvalidated)]
#[serde(rename_all = "camelCase")]
pub struct UpdateLocation {
    #[garde(alphanumeric)]
    pub title: Option<String>,
    pub contacts: Option<Vec<MutatorContact>>,
}
