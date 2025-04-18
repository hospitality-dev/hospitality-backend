use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ProductInventoryCount {
    pub count: u64,
    pub has_about_to_expire: bool,
    pub expiration_date: DateTime<Utc>,
    pub title: String,
    pub expiration_days: u64,
}

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ProductInventoryReport {
    pub items: Vec<ProductInventoryCount>,
    pub company_id: Uuid,
    pub location_id: Uuid,
}

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct LocationProductQRCode {
    pub id: Uuid,
    pub title: String,
    pub expiration_date: Option<DateTime<Utc>>,
}

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ProductQRCodes {
    pub items: Vec<LocationProductQRCode>,
    pub title: String,
    pub company_id: Uuid,
    pub location_id: Uuid,
}
