use garde::Validate;
use rust_decimal::Decimal;
use serde::Deserialize;
use uuid::Uuid;

use crate::enums::products::{VolumeUnits, WeightUnits};

#[derive(Deserialize, Validate)]
#[serde(rename_all = "camelCase")]
#[garde(allow_unvalidated)]
pub struct InsertProduct {
    #[garde(length(min = 1))]
    pub title: String,
    pub description: Option<String>,
    pub weight: Option<Decimal>,
    pub volume: Option<Decimal>,
    pub barcode: Option<String>,
    pub category_id: Uuid,
    pub subcategory_id: Option<Uuid>,
    pub image_id: Option<Uuid>,
    pub manufacturer_id: Option<Uuid>,
    pub weight_unit: Option<WeightUnits>,
    pub volume_unit: Option<VolumeUnits>,
}
