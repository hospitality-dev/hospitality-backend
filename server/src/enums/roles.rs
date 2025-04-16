use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Hash, Clone)]
#[serde(rename_all = "lowercase")]
pub enum Roles {
    Owner,
    Manager,
    Employee,
    #[serde(other)]
    None,
}

impl std::fmt::Display for Roles {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Roles::Owner => f.write_str("owner"),
            Roles::Manager => f.write_str("manager"),
            Roles::Employee => f.write_str("employee"),
            Roles::None => f.write_fmt(format_args!("none")),
        }
    }
}

impl From<String> for Roles {
    fn from(value: String) -> Self {
        match value.as_ref() {
            "owner" => Roles::Owner,
            "manager" => Roles::Manager,
            "employee" => Roles::Employee,
            _ => Roles::None,
        }
    }
}
