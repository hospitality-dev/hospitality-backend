use aws_sdk_s3::Client;
use tera::Tera;

#[derive(Clone)]
pub struct AppState {
    pub tera: Tera,
    pub s3_client: Client,
    pub s3_name: String,
}
