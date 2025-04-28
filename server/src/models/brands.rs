use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertBrand {
    pub title: String,
    pub parent_id: Uuid,
}
