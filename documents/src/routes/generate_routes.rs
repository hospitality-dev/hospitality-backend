use std::collections::HashMap;

use aws_sdk_s3::presigning::PresigningConfig;
use axum::extract::State;
use axum::{Json, Router, response::IntoResponse, routing::post};
use chrono_tz::Tz;
use serde_json::{Value, json};
use tempfile::NamedTempFile;
use tokio::process::Command;
use uuid::Uuid;

use crate::models::payloads::ProductInventoryReport;
use crate::models::state::AppState;
use crate::utils::consts::PRESIGN_DURATION;
use crate::utils::date_time_utils::convert_to_tz;
async fn generate_from_template(
    State(state): State<AppState>,
    Json(payload): Json<ProductInventoryReport>,
) -> Result<impl IntoResponse, String> {
    let mapped = payload.items
        .iter()
        .map(|item| {
            json!({
                "title": item.title,
                "expirationDate": convert_to_tz(item.expiration_date, Tz::Europe__Belgrade).format("%d.%m.%y").to_string(),
                "hasAboutToExpire": item.has_about_to_expire,
                "count": item.count,
                "expirationDays": if item.expiration_days+1 <= 7 {
                    format!("| in {} day(s)", item.expiration_days+1)
                } else {format!("")}
            })
        })
        .collect();
    let json = Value::Array(mapped);

    let output_file = NamedTempFile::new().unwrap();
    let output_path = output_file.path().to_str().unwrap();
    let status = Command::new("typst")
        .arg("compile")
        .arg("./src/templates/inventory-report.typ")
        .arg("--input")
        .arg(format!("json={}", json.to_string()))
        .arg("--input")
        .arg(format!("location_title={}", "Filtz - Location A"))
        .arg("--font-path")
        .arg("./src/fonts")
        .arg("--format")
        .arg("pdf")
        .arg(output_path)
        .status()
        .await
        .unwrap();

    if status.success() {
        println!("Converted {} to {}", "test.md", "output.pdf");
    } else {
        eprintln!("Pandoc failed");
    }

    let pdf_bytes = std::fs::read(&output_path).unwrap();

    let id = Uuid::new_v4();
    let key = format!(
        "{}/reports/{}/{}",
        payload.company_id, payload.location_id, id
    );
    let mut metadata = HashMap::new();
    metadata.insert("title".to_string(), "inventory-report".to_string());
    metadata.insert("author".to_string(), "HMS".to_string());
    state
        .s3_client
        .put_object()
        .bucket(&state.s3_name)
        .key(&key)
        .body(pdf_bytes.into())
        .set_metadata(Some(metadata))
        .acl(aws_sdk_s3::types::ObjectCannedAcl::Private)
        .content_type("application/pdf")
        .send()
        .await
        .unwrap();

    let command = &state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(key)
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .unwrap();

    let url = command.uri();

    return Ok(serde_json::json!({"id": id, "url": url.to_string()})
        .to_string()
        .into_response());
}

pub fn generate_routes() -> Router<AppState> {
    return Router::new().nest(
        "/generate",
        Router::new().route("/from-template", post(generate_from_template)),
    );
}
