use std::{collections::HashSet, str::FromStr};

use anyhow::Result;
use convert_case::Casing;
use deadpool_postgres::{Object, Pool};
use serde_json::Value;
use tracing::info;

use crate::{
    enums::{errors::AppError, models::Models, requests::FilterOperators},
    models::response::AppErrorResponse,
    traits::model_traits::AllowedFields,
};

pub async fn db_conn(db_pool: &Pool) -> Result<Object> {
    info!(action = "ESTABLISH DB CONNECTION");
    let connection = db_pool.get().await?;
    info!(action = "DB CONNECTION ESTABLISHED");
    Ok(connection)
}

#[derive(Debug)]
pub struct WhereBuilder<'a> {
    pub params: Vec<String>,
    counter: usize,
    pub model: &'a Models,
}

impl<'a> WhereBuilder<'a> {
    pub fn new(model: &'a Models, initial_count: Option<usize>) -> Self {
        WhereBuilder {
            params: Vec::new(),
            counter: initial_count.unwrap_or(0) + 1,
            model,
        }
    }

    pub fn build_where_clause(
        &mut self,
        value: &Option<Value>,
    ) -> Result<(String, Vec<String>), AppErrorResponse> {
        if let Some(value) = value {
            let allowed_fields = self.model.get_allowed_fields().unwrap_or_default();

            let sql = self.parse_condition(&Some(value.to_owned()), &allowed_fields)?;

            Ok((sql, self.params.clone()))
        } else {
            Ok((String::from("TRUE"), vec![]))
        }
    }

    fn parse_condition(
        &mut self,
        value: &Option<Value>,
        allowed_fields: &HashSet<&str>,
    ) -> Result<String, AppErrorResponse> {
        if let Some(value) = value {
            match value {
                Value::Object(map) => {
                    let mut conditions = Vec::new();

                    // Handle AND conditions
                    if let Some(and) = map.get("and") {
                        if let Value::Array(and_conditions) = and {
                            let parts: Result<Vec<String>, _> = and_conditions
                                .iter()
                                .map(|condition| {
                                    self.parse_condition(
                                        &Some(condition.to_owned()),
                                        allowed_fields,
                                    )
                                })
                                .filter(|x| x.as_ref().is_ok_and(|c| *c != "".to_string()))
                                .collect();

                            let parts = parts.unwrap_or_default();

                            if !parts.is_empty() {
                                conditions.push(format!("({})", parts.join(" AND ")));
                            }
                        }
                    }

                    // Handle OR conditions
                    if let Some(or) = map.get("or") {
                        if let Value::Array(or_conditions) = or {
                            let parts: Result<Vec<String>, _> = or_conditions
                                .iter()
                                .map(|condition| {
                                    self.parse_condition(
                                        &Some(condition.to_owned()),
                                        allowed_fields,
                                    )
                                })
                                .filter(|x| x.as_ref().is_ok_and(|c| *c != "".to_string()))
                                .collect();

                            let parts = parts.unwrap_or_default();
                            if !parts.is_empty() {
                                conditions.push(format!("({})", parts.join(" OR ")));
                            }
                        }
                    }

                    // Handle single field condition
                    if let (
                        Some(Value::String(field)),
                        Some(Value::String(operator)),
                        Some(value),
                    ) = (map.get("field"), map.get("operator"), map.get("value"))
                    {
                        let field = field.to_case(convert_case::Case::Snake);
                        if allowed_fields.contains(&field.as_str()) {
                            let sql_operator = FilterOperators::from_str(&operator)
                                .map_err(AppError::default_response)?;

                            self.params.push(value.to_string());
                            let param_num = self.counter;
                            let param_num_string = match sql_operator {
                                FilterOperators::In | FilterOperators::NotIn => {
                                    format!("ANY(${})", param_num)
                                }
                                _ => format!("${}", param_num),
                            };
                            self.counter += 1;
                            return Ok(format!(
                                "{} {} {}",
                                format!("{}.{}", self.model.to_string(), field),
                                sql_operator,
                                param_num_string
                            ));
                        }

                        return Ok(String::from(""));
                    }

                    // If we have both AND and OR conditions, combine them with AND
                    if !conditions.is_empty() {
                        return Ok(format!("({})", conditions.join(" AND ")));
                    }
                    return Ok(String::from(""));
                }
                _ => {}
            }
            Err(AppError::default_response("Invalid query structure"))
        } else {
            return Ok(String::from(""));
        }
    }
}

pub fn get_select_string(model: &Models, fields: Vec<String>) -> String {
    return fields
        .iter()
        .map(|s| format!("{}.{}", model.to_string(), s))
        .collect::<Vec<String>>()
        .join(", ");
}
