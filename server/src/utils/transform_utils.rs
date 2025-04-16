use axum::body::Bytes;
use convert_case::{Case, Casing};
use serde_json::{Map, Value};

use crate::{enums::errors::AppError, models::response::AppErrorResponse};

pub fn camel_case_keys(value: Value) -> Value {
    match value {
        Value::Object(map) => {
            let transformed_map: Map<String, Value> = map
                .into_iter()
                .map(|(key, val)| (key.to_case(Case::Camel), camel_case_keys(val)))
                .collect();
            Value::Object(transformed_map)
        }
        Value::Array(arr) => Value::Array(arr.into_iter().map(camel_case_keys).collect()),
        other => other,
    }
}

pub fn snake_case_keys(value: Value) -> Value {
    match value {
        Value::Object(map) => {
            let transformed_map: Map<String, Value> = map
                .into_iter()
                .map(|(key, val)| (key.to_case(Case::Snake), snake_case_keys(val)))
                .collect();
            Value::Object(transformed_map)
        }
        Value::Array(arr) => Value::Array(arr.into_iter().map(snake_case_keys).collect()),
        other => other,
    }
}

pub fn bytes_to_json_value(bytes: &Bytes) -> Result<Value, AppErrorResponse> {
    let payload = serde_json::from_slice::<Value>(&bytes).map_err(AppError::critical_error)?;

    let payload = snake_case_keys(payload);

    Ok(payload)
}
