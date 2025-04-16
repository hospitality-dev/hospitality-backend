use crate::utils::serde_utils::{deserialize_time_format, deserialize_time_format_range};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::collections::HashMap;
use uuid::Uuid;

use crate::enums::{actions::Actions, models::Models};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DateRange((DateTime<Utc>, DateTime<Utc>, DateTime<Utc>));

#[derive(Debug, Clone, Serialize, Deserialize)]

pub struct TimeRange(#[serde(deserialize_with = "deserialize_time_format_range")] (String, String));

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TimeString(#[serde(deserialize_with = "deserialize_time_format")] String);

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "operator", rename_all = "snake_case")]
pub enum ConditionOperators {
    Eq(HashMap<String, Value>),
    In(HashMap<String, Vec<Value>>),
    NotIn(HashMap<String, Vec<Value>>),
    Gt(HashMap<String, f64>),
    Gte(HashMap<String, f64>),
    Lt(HashMap<String, f64>),
    Lte(HashMap<String, f64>),
    TimeEquals(HashMap<String, TimeString>),
    TimeRangeBetween(HashMap<String, TimeRange>),
    TimeRangeNotBetween(HashMap<String, TimeRange>),
    TimeRange(HashMap<String, TimeRange>),
    DateTimeRange(HashMap<String, DateRange>),
    DateEquals(HashMap<String, DateTime<Utc>>),
}

#[derive(Debug, Clone, Serialize, Deserialize)]

pub struct Conditions {
    pub and: Option<Vec<ConditionOperators>>,
    pub or: Option<Vec<ConditionOperators>>,
}

#[derive(Serialize, Deserialize)]
pub struct Policies {
    #[serde(default)]
    pub effect: bool,
    pub conditions: Option<Conditions>,
    pub actions: Vec<Actions>,
    pub model: Models,
}

#[derive(Serialize, Deserialize)]
pub struct RoleDefinition {
    pub id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub policies: Vec<Policies>, // pub permissions: Permissions,
}
