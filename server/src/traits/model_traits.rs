use std::collections::{HashMap, HashSet};

pub trait AllowedFields {
    fn get_allowed_fields(&self) -> HashSet<&str>;
}
pub trait AllowedRelations {
    fn get_allowed_relations_and_fields(&self) -> HashMap<&str, HashSet<&str>>;
}

pub trait SelectableFields: AllowedFields {
    fn get_fields_from_query_string(query_fields: Option<String>) -> HashSet<String>;
}
