use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertSupplier {
    pub title: String,
    pub owner_id: Uuid,
    pub company_id: Uuid,
}
