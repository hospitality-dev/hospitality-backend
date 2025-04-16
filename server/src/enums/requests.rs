use std::str::FromStr;

use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Deserialize, Clone, Debug)]
#[serde(rename_all(deserialize = "lowercase"))]
pub enum FilterOperators {
    Eq,
    Neq,
    Gt,
    Lt,
    Gte,
    Lte,
    Is,
    IsNot,
    Like,
    In,
    NotIn,
    IsNull,
    IsNotNull,
}
impl std::fmt::Display for FilterOperators {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Eq => write!(f, "="),
            Self::Neq => write!(f, "!="),
            Self::Gt => write!(f, ">"),
            Self::Lt => write!(f, "<"),
            Self::Gte => write!(f, ">="),
            Self::Lte => write!(f, "<="),
            Self::Is => write!(f, "IS"),
            Self::IsNot => write!(f, "IS NOT"),
            Self::Like => write!(f, "ILIKE"),
            Self::In => write!(f, "="),
            Self::NotIn => write!(f, "!="),
            Self::IsNull => write!(f, "IS NULL "),
            Self::IsNotNull => write!(f, "IS NOT NULL"),
        }
    }
}

impl FromStr for FilterOperators {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "eq" => Ok(Self::Eq),
            "neq" => Ok(Self::Neq),
            "gt" => Ok(Self::Gt),
            "lt" => Ok(Self::Lt),
            "gte" => Ok(Self::Gte),
            "lte" => Ok(Self::Lte),
            "is" => Ok(Self::Is),
            "is_not" => Ok(Self::IsNot),
            "ilike" => Ok(Self::Like),
            "in" => Ok(Self::In),
            "not_in" => Ok(Self::NotIn),
            _ => Err(format!("Invalid filter operator: {}", s)),
        }
    }
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all(deserialize = "kebab-case"))]

pub enum CerbosOperators {
    Eq,
    Ne,
    Gt,
    Lt,
    Gte,
    Lte,
    Not,
    In,
    NotIn,
    And,
    Or,
    GetField,
    SetField,
    Struct,
}

impl std::fmt::Display for CerbosOperators {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Eq => write!(f, "="),
            Self::Ne => write!(f, "!="),
            Self::Gt => write!(f, ">"),
            Self::Lt => write!(f, "<"),
            Self::Gte => write!(f, ">="),
            Self::Lte => write!(f, "<="),
            Self::NotIn => write!(f, "not in"),
            Self::In => write!(f, "in"),
            Self::And => write!(f, "and"),
            Self::Or => write!(f, "or"),
            Self::Not => write!(f, "!"),
            Self::GetField => write!(f, "get-field"),
            Self::SetField => write!(f, "set-field"),
            Self::Struct => write!(f, "struct"),
        }
    }
}

impl FromStr for CerbosOperators {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "eq" => Ok(Self::Eq),
            "ne" => Ok(Self::Ne),
            "gt" => Ok(Self::Gt),
            "lt" => Ok(Self::Lt),
            "gte" => Ok(Self::Gte),
            "lte" => Ok(Self::Lte),
            "and" => Ok(Self::And),
            "or" => Ok(Self::Or),
            "not in" => Ok(Self::NotIn),
            "in" => Ok(Self::In),
            "not" => Ok(Self::Not),
            "get-field" => Ok(Self::GetField),
            "set-field" => Ok(Self::SetField),
            "struct" => Ok(Self::Struct),
            _ => Err(format!("Invalid filter operator: {}", s)),
        }
    }
}

#[derive(Serialize, Debug, Deserialize)]
#[serde(untagged)] // Allows JSON to be either a string or a UUID
pub enum CerbosAttrValue {
    String(String),
    Uuid(Uuid),
}
