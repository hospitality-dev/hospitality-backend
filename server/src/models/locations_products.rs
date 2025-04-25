use chrono::{DateTime, Utc};
use garde::Validate;
use rust_decimal::Decimal;
use serde::Deserialize;
use uuid::Uuid;

use crate::enums::products::UnitsOfMeasurement;

#[derive(Deserialize, Validate)]
#[serde(rename_all = "camelCase")]
#[garde(allow_unvalidated)]
pub struct InsertLocationProduct {
    pub id: Uuid,
    #[garde(range(min = 1))]
    pub amount: i64,
    pub expiration_date: Option<DateTime<Utc>>,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocationProductUnit {
    pub id: Uuid,
    pub quantity: Decimal,
    pub unit: UnitsOfMeasurement,
    pub expiration_date: Option<DateTime<Utc>>,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateProductQrCodesWithExpiration {
    pub expiration_date: DateTime<Utc>,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ProductFromPurchaseItem {
    pub product_id: Uuid,
    pub expiration_date: Option<DateTime<Utc>>,
    pub quantity: Decimal,
    pub unit_of_measurement: UnitsOfMeasurement,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertProductsFromPurchaseItems {
    pub products: Vec<ProductFromPurchaseItem>,
}
