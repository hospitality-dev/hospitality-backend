use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocationAvailableBrands {
    // location_id is extracted from the session
    pub brand_id: Uuid,
}
