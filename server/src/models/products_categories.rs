use garde::Validate;
use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize, Validate)]
#[serde(rename_all = "camelCase")]
pub struct InsertProductCategory {
    #[garde(length(min = 1))]
    pub title: String,
    #[garde(skip)]
    pub parent_id: Option<Uuid>,
    #[garde(skip)]
    pub company_id: Uuid,
}
