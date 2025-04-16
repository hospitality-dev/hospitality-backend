use std::collections::HashSet;

use anyhow::Result;

use crate::models::response::AppErrorResponse;

pub trait AllowedFields {
    fn get_allowed_fields(&self) -> Result<HashSet<&str>, AppErrorResponse>;
}

pub trait SelectableFields: AllowedFields {
    fn get_fields_from_query_string(query_fields: Option<String>) -> HashSet<String>;
}
