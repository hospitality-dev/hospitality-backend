use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocationAvailableProduct {
    // location_id is extracted from the session
    pub product_id: Uuid,
}
