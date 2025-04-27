use std::{
    collections::{HashMap, HashSet},
    str::FromStr,
};

use serde_json::{Map, Value};
use tokio_postgres::types::ToSql;
use uuid::Uuid;

pub fn convert_filter_type(input: &String) -> Box<dyn ToSql + Sync + Send> {
    if let Ok(uuid) = Uuid::try_parse(input) {
        Box::new(uuid) as Box<dyn ToSql + Sync + Send>
    } else if let Ok(number) = input.parse::<i64>() {
        Box::new(number) as Box<dyn ToSql + Sync + Send>
    } else if let Ok(bool_check) = input.parse::<bool>() {
        Box::new(bool_check) as Box<dyn ToSql + Sync + Send>
    } else if let Ok(value) = Value::from_str(input.as_str()) {
        return match value {
            Value::Array(v) => {
                if v.is_empty() {
                    return Box::new(v) as Box<dyn ToSql + Sync + Send>;
                } else {
                    let first = v.first().unwrap().as_str().unwrap();

                    if let Ok(_) = Uuid::try_parse(&first) {
                        let formatted: Vec<Uuid> = v
                            .iter()
                            .map(|el| Uuid::from_str(el.as_str().unwrap()).unwrap())
                            .collect();
                        return Box::new(formatted) as Box<dyn ToSql + Sync + Send>;
                    } else if let Ok(_) = first.parse::<i64>() {
                        let formatted: Vec<i64> = v
                            .iter()
                            .map(|el| el.to_string().parse::<i64>().unwrap())
                            .collect();
                        return Box::new(formatted) as Box<dyn ToSql + Sync + Send>;
                    } else {
                        let formatted: Vec<String> = v.iter().map(|el| el.to_string()).collect();
                        return Box::new(formatted) as Box<dyn ToSql + Sync + Send>;
                    }
                }
            }
            Value::String(v) => convert_filter_type(&v),
            _ => Box::new(value) as Box<dyn ToSql + Sync + Send>,
        };
    } else {
        Box::new(input.to_owned()) as Box<dyn ToSql + Sync + Send>
    }
}

pub fn extract_relations(
    input: &Option<String>,
    allowed_relations: HashMap<&str, HashSet<&str>>,
) -> HashMap<String, HashSet<String>> {
    if input.is_none() {
        return HashMap::new();
    }
    let input_relations = input.as_ref().unwrap();

    let json = Value::from_str(&input_relations).unwrap_or_default();

    let blank_map = Map::new();
    let json = json.as_object().unwrap_or(&blank_map);

    let relations = json
        .iter()
        .filter_map(|item| {
            // * relation -> Map<MODEL, FIELDS[]>
            if let Some(relation) = allowed_relations.get(item.0.as_str()) {
                let fields: HashSet<String> = HashSet::from_iter(
                    item.1
                        .as_array()
                        .unwrap_or(&Vec::new())
                        .iter()
                        .map(|v| v.as_str().unwrap_or_default()),
                )
                .intersection(relation)
                .map(|item| item.to_string())
                .collect();
                Some((item.0.to_owned(), fields))
            } else {
                None
            }
        })
        .collect::<HashMap<String, HashSet<String>>>();

    return relations;
}
