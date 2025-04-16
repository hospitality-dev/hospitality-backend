use std::u8;

use serde::Deserialize;

#[derive(Debug, Deserialize, Clone)]
pub struct QueryParams {
    #[serde(default = "default_page")]
    pub page: i64,
    #[serde(default = "default_limit")]
    pub limit: i64,
    #[serde(default = "default_none")]
    pub fields: Option<String>,
    #[serde(default = "default_none")]
    pub filters: Option<String>,
}

fn default_page() -> i64 {
    0
}

fn default_limit() -> i64 {
    20
}

fn default_none() -> Option<String> {
    None
}

#[derive(Deserialize)]

pub struct SearchQueryParams {
    pub search_query: String,
}
