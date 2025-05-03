use serde::Deserialize;

use super::contacts::MutatorContact;

#[derive(Deserialize)]
pub struct InsertManufacturer {
    pub title: String,
    pub contacts: Option<Vec<MutatorContact>>,
}
