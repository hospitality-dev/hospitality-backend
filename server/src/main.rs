use anyhow::Result;
use aws_sdk_s3::config::{BehaviorVersion, Credentials, Region};
use axum::{
    extract::{MatchedPath, Request},
    http::HeaderValue,
    middleware::{from_fn, from_fn_with_state},
    routing::get,
    serve, Router,
};
use axum_extra::extract::cookie::Key;
use deadpool_postgres::{Config, ManagerConfig};
use deadpool_redis::{Config as ValkeyConfig, Runtime};
use dotenv::{dotenv, var};
use middlware::crud_middleware::{
    api_logging_middleware, global_model_middleware, permission_check, session_check,
};
use models::state::AppState;
use reqwest::{
    header::{
        ACCEPT_ENCODING, ACCESS_CONTROL_ALLOW_ORIGIN, AUTHORIZATION, CACHE_CONTROL,
        CONTENT_SECURITY_POLICY, CONTENT_SECURITY_POLICY_REPORT_ONLY, CONTENT_TYPE, SET_COOKIE,
    },
    Client as ReqwestClient, Method, Url,
};
use routes::{
    auth_routes::auth_routes, contacts_routes::contacts_routes, file_routes::file_routes,
    locations_available_products_routes::locations_available_products_routes,
    locations_products_routes::location_products_routes, locations_routes::locations_routes,
    locations_users_routes::locations_users_routes, product_routes::product_routes,
    products_categories_routes::products_categories_routes, resource_routes::resource_routes,
    roles_routes::roles_routes, search_routes::search_routes, url_routes::url_routes,
    users_routes::users_routes,
};
use tokio::net::TcpListener;
use tokio_postgres::NoTls;
use tower_http::{
    cors::{AllowOrigin, CorsLayer},
    trace::TraceLayer,
};

use tracing::debug_span;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};
use utils::storage_utils::configure_lifecycle_rules;

mod enums;
mod middlware;
mod models;
mod routes;
mod traits;
mod utils;

#[tokio::main]
async fn main() -> Result<()> {
    dotenv().ok();

    let port = var("PORT").expect("Env var `PORT` not set.");
    let listener = TcpListener::bind(format!("0.0.0.0:{}", port)).await?;

    println!("LISTENING ON PORT {} 🚀", port);

    serve(listener, app().await.unwrap()).await?;

    Ok(())
}
pub async fn app() -> Result<Router> {
    let log_level = var("LOG_LEVEL").expect("Env var `LOG_LEVEL` not configured");
    let loki_url = var("LOKI_URL").expect("Env var `LOKI_URL` not set");

    let filter = EnvFilter::new(log_level);
    // Tracing setup
    let (layer, task) = tracing_loki::builder()
        .label("environment", "development")?
        .label("service", "server")?
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

    // ENV var setup

    let server_url = var("SERVER_URL").expect("Env var `SERVER_URL` not set");
    let db_url = var("DATABASE_URL").expect("Env var `DATABASE_URL` not set");
    let base_fe_url = var("BASE_FE_URL").expect("Env var `BASE_FE_URL` not set");
    let document_server_url =
        var("DOCUMENT_SERVER_URL").expect("Env var `DOCUMENT_SERVER_URL` not set");
    let valkey_url = var("VALKEY_URL").expect("Env var `VALKEY_URL` not set");
    let cookie_encryption_key =
        var("COOKIE_ENCRYPTION_KEY").expect("Env var `COOKIE_ENCRYPTION_KEY` not set");
    let s3_endpoint = var("S3_ENDPOINT").expect("Env var `S3_ENDPOINT` not set");
    let s3_access_key = var("S3_ACCESS_KEY").expect("Env var `S3_ACCESS_KEY` not set");
    let s3_secret = var("S3_SECRET").expect("Env var `S3_SECRET` not set");
    let s3_name = var("S3_NAME").expect("Env var `S3_SECRET` not set");
    // Database setup
    let mut cfg = Config::new();
    cfg.url = Some(db_url.to_string());
    cfg.manager = Some(ManagerConfig {
        recycling_method: deadpool_postgres::RecyclingMethod::Fast,
    });
    let db_pool = cfg
        .create_pool(Some(deadpool_postgres::Runtime::Tokio1), NoTls)
        .unwrap();

    // Valkey config
    let valkey_config = ValkeyConfig::from_url(valkey_url);
    let valkey = valkey_config.create_pool(Some(Runtime::Tokio1)).unwrap();

    // Auth config
    let cookie_key = Key::from(cookie_encryption_key.as_bytes());

    // Cerbos setup
    let cerbos_url = var("CERBOS_URL").expect("No ENV var `CERBOS_URL` set");

    // S3 setup
    let creds = Credentials::new(s3_access_key, s3_secret, None, None, "");
    let config = aws_sdk_s3::config::Builder::new()
        .behavior_version(BehaviorVersion::latest())
        .force_path_style(true)
        .region(Region::new("fra1"))
        .endpoint_url(s3_endpoint)
        .credentials_provider(creds)
        .build();

    let s3_client = aws_sdk_s3::Client::from_conf(config);

    configure_lifecycle_rules(&s3_client, &s3_name)
        .await
        .expect("FAILED TO CONFIGURE BUCKET LIFECYCLE RULES");

    // Server setup
    let rqw_client = ReqwestClient::new();
    let state = AppState {
        server_url,
        db_pool,
        rqw_client,
        valkey,
        cerbos_url,
        cookie_key,
        s3_client,
        s3_name,
        document_server_url,
    };

    let origins = [HeaderValue::from_str(&base_fe_url).unwrap()];
    let cors = CorsLayer::new()
        .allow_credentials(true)
        .allow_headers([
            AUTHORIZATION,
            ACCEPT_ENCODING,
            CONTENT_TYPE,
            SET_COOKIE,
            CACHE_CONTROL,
        ])
        .expose_headers([
            ACCESS_CONTROL_ALLOW_ORIGIN,
            SET_COOKIE,
            CONTENT_SECURITY_POLICY,
            CONTENT_SECURITY_POLICY_REPORT_ONLY,
            CACHE_CONTROL,
        ])
        .allow_methods([
            Method::GET,
            Method::POST,
            Method::OPTIONS,
            Method::DELETE,
            Method::PATCH,
        ])
        .allow_origin(AllowOrigin::list(origins));

    let app = Router::new()
        .route("/healthcheck", get(|| async { "OK" }))
        .merge(auth_routes())
        .nest(
            "/api/v1",
            Router::new()
                .merge(users_routes())
                .merge(locations_routes())
                .merge(product_routes())
                .merge(products_categories_routes())
                .merge(location_products_routes())
                .merge(locations_available_products_routes())
                .merge(roles_routes())
                .merge(locations_users_routes())
                .merge(contacts_routes())
                .merge(file_routes())
                .layer(from_fn_with_state(state.clone(), permission_check))
                // TODO: ADD PERMISSIONS MIDDLEWARE TO URL ROUTES
                .merge(url_routes())
                // TODO: ADD PERMISSIONS MIDDLEWARE TO RESOURCE ROUTES
                .merge(resource_routes())
                //* Has own permissions and logging middleware
                .merge(search_routes(&state))
                .layer(from_fn_with_state(state.clone(), session_check))
                .layer(from_fn_with_state(state.clone(), api_logging_middleware))
                .layer(from_fn(global_model_middleware)),
        )
        .with_state(state)
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
