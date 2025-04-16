use serde::Deserialize;
use uuid::Uuid;

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertLocationsUsers {
    pub user_id: Uuid,
    pub role_id: Uuid,
}
