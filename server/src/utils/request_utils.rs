use std::str::FromStr;

use serde_json::Value;
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
