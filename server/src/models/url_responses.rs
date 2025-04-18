use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub struct InventoryReportResponse {
    pub id: Uuid,
    pub url: String,
}
