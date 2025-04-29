use serde::Deserialize;

use super::contacts::MutatorContact;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct InsertSupplier {
    pub title: String,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateSupplier {
    pub title: Option<String>,
    pub contacts: Option<Vec<MutatorContact>>,
}
