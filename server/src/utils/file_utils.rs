use aws_sdk_s3::primitives::ByteStream;
use axum::extract::multipart::Field;
use uuid::Uuid;

use crate::{enums::files::FileTypes, models::state::AppState};

pub async fn upload_file(
    state: &AppState,
    errors: &mut Vec<String>,
    field: Field<'_>,
    image_id: &Option<Uuid>,
    file_path: String,
) -> Result<(Uuid, String, FileTypes, String), bool> {
    let content_type = field.content_type();
    let name = field.name().unwrap_or("unnamed").to_string();
    if name == "unnamed" {
        tracing::error!("Unnamed file");
        return Err(false);
    }
    let content_type = content_type.unwrap().to_string();
    let data = field.bytes().await;
    if data.is_err() {
        errors.push(name);
        tracing::error!("ERROR GETTING FILE DATA - {}", data.err().unwrap());
        return Err(false);
    }

    let id = image_id.unwrap_or(Uuid::new_v4());
    let data = data.unwrap().to_vec();

    let body = ByteStream::from(data);

    let upload = state
        .s3_client
        .put_object()
        .bucket(&state.s3_name)
        .key(&file_path)
        .body(body)
        .acl(aws_sdk_s3::types::ObjectCannedAcl::Private)
        .content_type(&content_type)
        .send()
        .await;

    if upload.is_ok() {
        return Ok((id, name, FileTypes::from(content_type), file_path));
    } else {
        tracing::error!("ERROR UPLOADING FILE - {}", upload.err().unwrap());
        return Err(false);
    }
}
