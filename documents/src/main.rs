use anyhow::Result;
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
    routing::get,
    serve,
};
use dotenv::{dotenv, var};
use tokio::net::TcpListener;
use tower_http::{
    cors::{AllowOrigin, CorsLayer},
    trace::TraceLayer,
};
use tracing::debug_span;
use tracing_loki::url::Url;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

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
    dotenv().ok();
    let log_level = var("LOG_LEVEL").expect("Env var `LOG_LEVEL` not configured");
    let loki_url = var("LOKI_URL").expect("Env var `LOKI_URL` not set");

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
    let server_url = var("SERVER_URL").expect("Env var `SERVER_URL` not set.");

    let origins = [HeaderValue::from_str(&server_url).unwrap()];
    let cors = CorsLayer::new()
        .allow_credentials(true)
        .allow_headers([AUTHORIZATION, ACCEPT_ENCODING, CONTENT_TYPE])
        .expose_headers([
            ACCESS_CONTROL_ALLOW_ORIGIN,
            CONTENT_SECURITY_POLICY,
            CONTENT_SECURITY_POLICY_REPORT_ONLY,
        ])
        .allow_methods([Method::POST])
        .allow_origin(AllowOrigin::list(origins));

    let app = Router::new()
        .route("/healthcheck", get(|| async { "OK" }))
        .nest("/api/v1", Router::new())
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
        )
        .layer(cors);
    Ok(app)
}
