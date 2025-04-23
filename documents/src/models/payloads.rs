use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
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

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]

pub struct PurchaseItem {
    pub title: String,
    pub price_per_unit: f32,
    pub quantity: String,
    pub total: f32,
}
#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Purchase {
    pub id: Uuid,
    pub total: Decimal,
    pub purchased_at: String,
    pub business_title: String,
    pub business_location_title: String,
    pub address: Option<String>,
    pub city: Option<String>,
    pub items: Vec<PurchaseItem>,
    pub company_id: Uuid,
    pub location_id: Uuid,
}
