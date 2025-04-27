use std::u8;

use serde::Deserialize;
use strum::Display;

#[derive(Debug, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct QueryParams {
    #[serde(default = "default_page")]
    pub page: i64,
    #[serde(default = "default_limit")]
    pub limit: i64,
    #[serde(default = "default_none")]
    pub fields: Option<String>,
    #[serde(default = "default_none")]
    pub filters: Option<String>,
    #[serde(default = "default_none")]
    pub sort_field: Option<String>,
    #[serde(default = "default_sort_type")]
    pub sort_type: Option<SortType>,
    #[serde(default = "default_none")]
    pub relations: Option<String>,
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
fn default_sort_type() -> Option<SortType> {
    Some(SortType::Asc)
}

#[derive(Debug, Deserialize, Clone, Display, Default)]
#[serde(rename_all = "lowercase")]
pub enum SortType {
    #[default]
    Asc,
    Desc,
}

impl From<String> for SortType {
    fn from(value: String) -> Self {
        match value.as_str() {
            "asc" => Self::Asc,
            "desc" => Self::Desc,
            _ => Self::Asc,
        }
    }
}

#[derive(Deserialize)]
pub struct SearchQueryParams {
    pub search_query: String,
}

impl QueryParams {
    pub fn to_query_sort(&self) -> String {
        if self.sort_field.is_some() {
            return format!(
                "ORDER BY {} {}",
                self.sort_field.as_ref().unwrap(),
                self.sort_type.as_ref().unwrap_or(&SortType::Asc)
            )
            .to_owned();
        }
        return String::from("");
    }
}
