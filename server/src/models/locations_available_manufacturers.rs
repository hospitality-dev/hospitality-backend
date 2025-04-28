use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocationAvailableManufacturers {
    // location_id is extracted from the session
    pub manufacturer_id: Uuid,
}
