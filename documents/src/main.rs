use anyhow::Result;
use aws_sdk_s3::config::{BehaviorVersion, Credentials, Region};
use axum::{
    Router,
    extract::{MatchedPath, Request},
    http::{
        HeaderValue, Method,
        header::{
            ACCEPT_ENCODING, ACCESS_CONTROL_ALLOW_ORIGIN, AUTHORIZATION, CONTENT_SECURITY_POLICY,
            CONTENT_SECURITY_POLICY_REPORT_ONLY, CONTENT_TYPE,
        },
    },
    middleware::from_fn_with_state,
    routing::get,
    serve,
};
use dotenv::{dotenv, var};
use middleware::request_middleware::block_request;
use models::state::AppState;
use routes::generate_routes::generate_routes;
use tokio::net::TcpListener;
use tower_http::{
    cors::{AllowOrigin, CorsLayer},
    trace::TraceLayer,
};
use tracing::debug_span;
use tracing_loki::url::Url;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

mod middleware;
mod models;
mod routes;

#[tokio::main]

async fn main() -> Result<()> {
    dotenv().ok();

    let port = var("PORT").expect("Env var `PORT` not set.");
    let listener = TcpListener::bind(format!("0.0.0.0:{}", port)).await?;

    println!("LISTENING ON PORT {} 🚀", port);

    serve(listener, app().await.unwrap()).await?;

    Ok(())
}

async fn app() -> Result<Router> {
    // *============ ENV VAR SETUP
    dotenv().ok();
    let log_level = var("LOG_LEVEL").expect("Env var `LOG_LEVEL` not configured");
    let loki_url = var("LOKI_URL").expect("Env var `LOKI_URL` not set");
    let server_url = var("SERVER_URL").expect("Env var `SERVER_URL` not set.");
    let s3_endpoint = var("S3_ENDPOINT").expect("Env var `S3_ENDPOINT` not set");
    let s3_access_key = var("S3_ACCESS_KEY").expect("Env var `S3_ACCESS_KEY` not set");
    let s3_secret = var("S3_SECRET").expect("Env var `S3_SECRET` not set");
    let s3_name = var("S3_NAME").expect("Env var `S3_SECRET` not set");
    let documents_api_key = var("DOCUMENTS_API_KEY").expect("Env var `DOCUMENTS_API_KEY` not set");

    // *============ TRACING SETUP
    let filter = EnvFilter::new(log_level);
    // Tracing setup
    let (layer, task) = tracing_loki::builder()
        .label("environment", "development")?
        .label("service", "documents")?
        .extra_field("pid", format!("{}", std::process::id()))?
        .build_url(Url::parse(loki_url.as_str()).unwrap())?;
    tracing_subscriber::registry()
        .with(filter)
        .with(layer)
        .init();
    tokio::spawn(task);
    tracing::info!(
        task = "tracing_setup",
        result = "success",
        "tracing successfully set up",
    );
    // *============ CORS SETUP

    let origins = [HeaderValue::from_str(&server_url).unwrap()];
    let cors = CorsLayer::new()
        .allow_credentials(true)
        .allow_headers([
            AUTHORIZATION,
            ACCEPT_ENCODING,
            CONTENT_TYPE,
            "x-documents-api-key".parse().unwrap(),
        ])
        .expose_headers([
            ACCESS_CONTROL_ALLOW_ORIGIN,
            CONTENT_SECURITY_POLICY,
            CONTENT_SECURITY_POLICY_REPORT_ONLY,
        ])
        .allow_methods([Method::POST])
        .allow_origin(AllowOrigin::list(origins));

    // *============ S3 SETUP
    let creds = Credentials::new(s3_access_key, s3_secret, None, None, "");
    let config = aws_sdk_s3::config::Builder::new()
        .behavior_version(BehaviorVersion::latest())
        .force_path_style(true)
        .region(Region::new("fra1"))
        .endpoint_url(s3_endpoint)
        .credentials_provider(creds)
        .build();

    let s3_client = aws_sdk_s3::Client::from_conf(config);

    // *============ Reqwest SETUP

    let rqw_client = reqwest::Client::new();

    let state = AppState {
        s3_client,
        s3_name,
        server_url,
        rqw_client,
        documents_api_key,
    };

    let app = Router::new()
        .route("/healthcheck", get(|| async { "OK" }))
        .nest("/api/v1", Router::new().merge(generate_routes()))
        .layer(from_fn_with_state(state.clone(), block_request))
        .with_state(state)
        .layer(cors)
        .layer(
            TraceLayer::new_for_http().make_span_with(|request: &Request<_>| {
                let matched_path = request
                    .extensions()
                    .get::<MatchedPath>()
                    .map(MatchedPath::as_str);

                debug_span!(
                    "REQUEST SPAN",
                    method = ?request.method(),
                    matched_path,
                    stage = tracing::field::Empty,
                    kind = tracing::field::Empty,
                    message = tracing::field::Empty,
                    call_path = tracing::field::Empty
                )
            }),
        );
    Ok(app)
}
