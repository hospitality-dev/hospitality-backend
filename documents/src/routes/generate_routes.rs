use axum::extract::State;
use axum::{Json, Router, response::IntoResponse, routing::post};
use chrono_tz::Tz;
use serde_json::{Value, json};
use tempfile::NamedTempFile;
use tokio::process::Command;

use crate::models::payloads::ProductInventoryReport;
use crate::models::state::AppState;
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
    state
        .s3_client
        .put_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/reports/{}/report.pdf",
            payload.company_id, payload.location_id
        ))
        .body(pdf_bytes.into())
        .acl(aws_sdk_s3::types::ObjectCannedAcl::Private)
        .content_type("application/pdf")
        .send()
        .await
        .unwrap();
    Ok(())
}

pub fn generate_routes() -> Router<AppState> {
    return Router::new().nest(
        "/generate",
        Router::new().route("/from-template", post(generate_from_template)),
    );
}
