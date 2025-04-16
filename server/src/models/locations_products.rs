use chrono::{DateTime, Utc};
use garde::Validate;
use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize, Validate)]
#[serde(rename_all = "camelCase")]
#[garde(allow_unvalidated)]
pub struct InsertLocationProduct {
    pub id: Uuid,
    #[garde(range(min = 1))]
    pub amount: i64,
    pub expiration_date: Option<DateTime<Utc>>,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateProductQrCodesWithExpiration {
    pub expiration_date: DateTime<Utc>,
}
