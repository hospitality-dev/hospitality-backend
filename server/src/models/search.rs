use std::collections::HashMap;

use crate::utils::serde_utils::coordinate_from_string;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
pub enum CooridnatesVector {
    Simple(Vec<(Decimal, Decimal)>),
    Nested(Vec<Vec<(Decimal, Decimal)>>),
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all(serialize = "camelCase"))]

pub struct Address {
    pub house_number: Option<String>,
    pub road: Option<String>,
    pub neighbourhood: Option<String>,
    pub suburb: Option<String>,
    pub city: Option<String>,
    pub county: Option<String>,
    pub state: Option<String>,
    pub postcode: Option<String>,
    pub country: Option<String>,
    pub country_code: Option<String>,
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all(serialize = "camelCase"))]
pub struct AddressesSearch {
    pub osm_type: String,
    pub place_id: i64,
    #[serde(deserialize_with = "coordinate_from_string")]
    pub lat: Decimal,
    #[serde(deserialize_with = "coordinate_from_string")]
    #[serde(alias = "lon")]
    pub lng: Decimal,
    pub category: String,
    pub r#type: String,
    pub addresstype: String,
    pub display_name: String,
    pub address: Address,
    pub name: String,
    pub extratags: Option<HashMap<String, String>>,
    pub boundingbox: Vec<Decimal>,
    pub namedetails: Option<HashMap<String, String>>,
}
