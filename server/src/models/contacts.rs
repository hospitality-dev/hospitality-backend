use garde::Validate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::enums::contacts::ContactTypes;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Contact {
    pub id: Uuid,
    pub title: Option<String>,
    pub prefix: Option<String>,
    pub iso_3: Option<String>,
    pub value: String,
    pub parent_id: Uuid,
    pub contact_type: ContactTypes,
    pub latitude: Option<Decimal>,
    pub longitude: Option<Decimal>,
    pub place_id: Option<i32>,
    pub bounding_box: Option<Vec<f64>>,
    pub is_public: Option<bool>,
    pub is_primary: Option<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
#[garde(allow_unvalidated)]
#[serde(rename_all = "camelCase")]
pub struct MutatorContact {
    pub id: Option<Uuid>,
    pub title: Option<String>,
    pub prefix: Option<String>,
    pub iso_3: Option<String>,
    pub value: Option<String>,
    pub contact_type: ContactTypes,
    pub place_id: Option<i32>,
    pub latitude: Option<Decimal>,
    pub longitude: Option<Decimal>,
    pub is_public: Option<bool>,
    pub is_primary: Option<bool>,
    pub bounding_box: Option<Vec<f64>>,
}
