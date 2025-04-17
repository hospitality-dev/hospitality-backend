use aws_sdk_s3::Client;

#[derive(Clone)]
pub struct AppState {
    pub s3_client: Client,
    pub s3_name: String,
}
