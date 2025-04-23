use axum::body::Bytes;
use convert_case::{Case, Casing};
use percent_encoding::percent_decode;
use regex::Regex;
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

pub fn format_receipt(encoded: &str) -> String {
    let decoded = encoded
        .replace("\\u", "%u")
        .replace("\\r\\n", "\n")
        .replace("\\n", "\n")
        .replace("\\t", "\t");

    let unicode_decoded = percent_decode(decoded.as_bytes())
        .decode_utf8_lossy()
        .to_string();

    unicode_decoded
}

/// Extracts item details from a receipt string.
///
/// # Arguments
///
/// * `receipt` - A string slice containing the full text of the receipt.
///
/// # Returns
///
/// A vector of tuples where each tuple contains:
/// - `String`: the item name
/// - `f32`: the price per unit
/// - `f32`: the quantity
/// - `f32`: the total price
pub fn extract_items(receipt: &str) -> Vec<(String, f32, f32, f32)> {
    // let re_suffix = Regex::new(r"/(KOM|KG|L|G|ML)\b").unwrap();
    let re_currency = Regex::new(r"\s*\((Е|Ђ)\)").unwrap();
    let mut items = Vec::new();
    let mut lines = receipt.lines();

    // Skip until we find the "Артикли" line
    while let Some(line) = lines.next() {
        if line.trim() == "Артикли" {
            break;
        }
    }

    // Skip the "=====" header line after "Артикли"
    while let Some(line) = lines.next() {
        if line.trim().starts_with("Назив") {
            break;
        }
    }

    // Now process pairs of lines: name, then price/qty/total
    while let Some(name_line) = lines.next() {
        if name_line.trim().starts_with("----") || name_line.trim().is_empty() {
            break;
        }

        if let Some(data_line) = lines.next() {
            let parts: Vec<&str> = data_line
                .split_whitespace()
                .filter(|s| !s.is_empty())
                .collect();

            if parts.len() >= 3 {
                let name_line = re_currency.replace_all(&name_line, "");
                // let name_line = re_suffix.replace_all(&name_line, "");
                let price = parts[0]
                    .replace(".", "")
                    .replace(',', ".")
                    .parse::<f32>()
                    .unwrap_or(0.0);

                let qty = parts[1].replace(',', ".").parse::<f32>().unwrap_or(0.0);
                let total = parts[2].replace(',', ".").parse::<f32>().unwrap_or(0.0);
                items.push((name_line.trim().to_string(), price, qty, total));
            }
        }
    }

    items
}

/// Extracts item unit from its title.
///
/// # Arguments
///
/// * `item` - A string slice containing the full text of the receipt.
///
/// # Returns
///
/// A string that represents the unit:
/// - `String`: the unit
pub fn extract_unit_from_name(name: &str) -> Option<String> {
    let re = Regex::new(r"(kg|l|g|ml|oz|lb|KG|L|G|ML|OZ|LB)\b").unwrap();

    if let Some(caps) = re.captures(name) {
        let unit = caps.get(1)?.as_str().to_string();
        return Some(unit);
    }

    None
}
