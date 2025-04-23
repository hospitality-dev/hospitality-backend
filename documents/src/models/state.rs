use aws_sdk_s3::Client;
use reqwest::Client as ReqwestClient;
#[derive(Clone)]
pub struct AppState {
    pub s3_client: Client,
    pub s3_name: String,
    pub server_url: String,
    pub rqw_client: ReqwestClient,
    pub documents_api_key: String,
}
