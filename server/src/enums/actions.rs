use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Hash, Clone, Copy)]
#[serde(rename_all = "lowercase")]
pub enum Actions {
    View(Uuid),
    List,
    Download(Uuid),
    Generate,
    Search,
    Create,
    Update(Uuid),
    Archive(Uuid),
    Delete(Uuid),
    #[serde(other)]
    None,
}

impl ToString for Actions {
    fn to_string(&self) -> String {
        match self {
            Actions::View(_id) => "view".to_string(),
            Actions::List => "list".to_string(),
            Actions::Download(_) => "download".to_string(),
            Actions::Generate => "generate".to_string(),
            Actions::Search => "search".to_string(),
            Actions::Create => "create".to_string(),
            Actions::Update(_id) => "update".to_string(),
            Actions::Archive(_id) => "archive".to_string(),
            Actions::Delete(_id) => "delete".to_string(),
            Actions::None => "none".to_string(),
        }
    }
}

#[derive(Debug, Serialize, Deserialize, Hash, PartialEq, Eq, Clone, Copy)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ActionEffect {
    EffectAllow,
    EffectDeny,
}

impl ToString for ActionEffect {
    fn to_string(&self) -> String {
        match self {
            &ActionEffect::EffectAllow => "EFFECT_ALLOW".to_string(),
            &ActionEffect::EffectDeny => "EFFECT_DENY".to_string(),
        }
    }
}
