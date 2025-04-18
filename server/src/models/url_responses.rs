use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub struct GenerateFileResponse {
    pub id: Uuid,
    pub url: String,
}
