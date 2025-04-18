use aws_sdk_s3::{operation::put_object::PutObjectOutput, presigning::PresigningConfig};
use axum::{
    extract::{Path, State},
    http::HeaderValue,
    response::IntoResponse,
    routing::{get, post},
    Extension, Json, Router,
};
use chrono::{DateTime, Utc};
use chrono_tz::Tz;
use image::{GenericImage, ImageBuffer, Rgba};
use imageproc::drawing::draw_text_mut;
use qrcode::QrCode;
use reqwest::{
    header::{CACHE_CONTROL, CONTENT_TYPE},
    StatusCode,
};
use serde_json::{json, Value};
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession, locations_products::CreateProductQrCodesWithExpiration,
        response::AppErrorResponse, state::AppState, url_responses::InventoryReportResponse,
    },
    utils::{
        consts::{A4_SIZE, PRESIGN_DURATION},
        date_time_utils::convert_to_tz,
    },
};
async fn generate_product_qr_code_sheet(
    key: &String,
    state: &AppState,
    product_id: &Uuid,
) -> Result<PutObjectOutput, AppErrorResponse> {
    // Initial vars
    let a4_width_px = A4_SIZE.0;
    let a4_height_px = A4_SIZE.1;
    let title_height = 150; //in px
    let margin = 5;

    let remove_product_url = format!(
        "ACTION:http://localhost:4000/api/v1/locations-products/{}/amount/1",
        product_id
    );
    //* Create QR Code
    let code = QrCode::new(remove_product_url.as_bytes()).map_err(AppError::critical_error)?;
    let qr_image = code.render::<Rgba<u8>>().build();
    let qr_width = qr_image.width();
    let qr_height = qr_image.height();

    // Calculate how many QR codes can fit in each dimension
    let codes_per_row = (a4_width_px) / (qr_width + margin);
    let codes_per_column = (a4_height_px) / (qr_height + margin);

    // Create a new empty A4 image (white background)
    let mut a4_image =
        ImageBuffer::from_fn(a4_width_px, a4_height_px, |_, _| Rgba([255, 255, 255, 255]));

    let font_data = include_bytes!("../fonts/Lato-Bold.ttf");
    let font = ab_glyph::FontArc::try_from_slice(font_data as &[u8])
        .map_err(|e| AppError::critical_error(format!("Failed to load font {}", e)))?;
    let scale = ab_glyph::PxScale::from(72.0);
    let text_color = Rgba([0, 0, 0, 255]);
    let text_y = 10; // 10px from the top

    draw_text_mut(
        &mut a4_image,
        text_color,
        10,
        text_y,
        scale,
        &font,
        "Srdjan Ljiljak CHSO",
    );

    // Place QR codes in a grid pattern
    for row in 0..codes_per_column {
        for col in 0..codes_per_row {
            // Calculate position for this QR code
            let x = col * (qr_width + margin);
            let y = row * (qr_height + margin) + title_height; // Offset by title height

            // Use the more efficient copy_from method
            if x + qr_width <= a4_width_px && y + qr_height <= a4_height_px {
                a4_image.copy_from(&qr_image, x, y).map_err(|e| {
                    AppError::critical_error(format!("Failed to copy QR code: {}", e))
                })?;
            }
        }
    }

    let mut image_bytes: Vec<u8> = Vec::new();
    let mut cursor = std::io::Cursor::new(&mut image_bytes);
    a4_image
        .write_to(&mut cursor, image::ImageFormat::Png)
        .map_err(|e| AppError::critical_error(format!("Failed to encode image: {}", e)))?;

    return state
        .s3_client
        .put_object()
        .bucket(&state.s3_name)
        .key(key)
        .body(image_bytes.into())
        .acl(aws_sdk_s3::types::ObjectCannedAcl::Private)
        .content_type("image/png")
        .send()
        .await
        .map_err(AppError::critical_error);
}

async fn generate_product_with_expiration_qr_code_sheet(
    key: &String,
    state: &AppState,
    title: String,
    ids: Vec<Uuid>,
    expiration_date: DateTime<Utc>,
) -> Result<PutObjectOutput, AppErrorResponse> {
    // Initial vars
    let a4_width_px = A4_SIZE.0;
    let a4_height_px = A4_SIZE.1;
    let title_height = 150; //in px
    let margin = 5;

    let mut a4_image =
        ImageBuffer::from_fn(a4_width_px, a4_height_px, |_, _| Rgba([255, 255, 255, 255]));
    let font_data = include_bytes!("../fonts/Lato-Bold.ttf");
    let font = ab_glyph::FontArc::try_from_slice(font_data as &[u8])
        .map_err(|e| AppError::critical_error(format!("Failed to load font {}", e)))?;
    let scale = ab_glyph::PxScale::from(72.0);
    let text_color = Rgba([0, 0, 0, 255]);
    let text_y = 10; // 10px from the top

    draw_text_mut(
        &mut a4_image,
        text_color,
        10,
        text_y,
        scale,
        &font,
        &format!(
            "{} expiring on {}",
            title,
            convert_to_tz(expiration_date, Tz::Europe__Belgrade).format("%d.%m.%Y")
        ),
    );
    for (idx, id) in ids.iter().enumerate() {
        let remove_product_url = format!(
            "ACTION:http://localhost:4000/api/v1/locations-products/{}",
            id
        );
        //* Create QR Code
        let code = QrCode::new(remove_product_url.as_bytes()).map_err(AppError::critical_error)?;
        let qr_image = code.render::<Rgba<u8>>().build();
        let qr_width = qr_image.width();
        let qr_height = qr_image.height();

        let x = (idx % 6) as u32 * (qr_width + margin);
        let y = (idx / 6) as u32 * (qr_height + margin) + title_height;

        if x + qr_width <= a4_width_px && y + qr_height <= a4_height_px {
            a4_image
                .copy_from(&qr_image, x, y)
                .map_err(|e| AppError::critical_error(format!("Failed to copy QR code: {}", e)))?;
        }
    }

    let mut image_bytes: Vec<u8> = Vec::new();
    let mut cursor = std::io::Cursor::new(&mut image_bytes);
    a4_image
        .write_to(&mut cursor, image::ImageFormat::Png)
        .map_err(|e| AppError::critical_error(format!("Failed to encode image: {}", e)))?;

    return state
        .s3_client
        .put_object()
        .bucket(&state.s3_name)
        .key(key)
        .body(image_bytes.into())
        .tagging("ttl=7")
        .acl(aws_sdk_s3::types::ObjectCannedAcl::Private)
        .content_type("image/png")
        .send()
        .await
        .map_err(AppError::critical_error);
}

async fn location_logo_url_route(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> impl IntoResponse {
    let command: &aws_sdk_s3::presigning::PresignedRequest = &state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/locations/{}/{}",
            &session.user.company_id.unwrap(),
            &session.user.location_id.unwrap(),
            &id
        ))
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .unwrap();

    let url = command.uri();
    return (
        StatusCode::OK,
        [
            (CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap()),
            (CACHE_CONTROL, HeaderValue::from_str("max-age=600").unwrap()),
        ],
        url.to_string(),
    );
}
async fn user_avatar_url_route(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> impl IntoResponse {
    let command: &aws_sdk_s3::presigning::PresignedRequest = &state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/users/{}",
            &session.user.company_id.unwrap(),
            &id
        ))
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .unwrap();

    let url = command.uri();
    return (
        StatusCode::OK,
        [
            (CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap()),
            (
                CACHE_CONTROL,
                HeaderValue::from_str("max-age=3600").unwrap(),
            ),
        ],
        url.to_string(),
    );
}
async fn product_qr_code_grid(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> Result<impl IntoResponse, AppErrorResponse> {
    let key = format!("{}/products/{}", &session.user.company_id.unwrap(), &id);
    let req = state
        .s3_client
        .head_object()
        .bucket(&state.s3_name)
        .key(&key)
        .send()
        .await;
    if req.is_err() {
        let _ = generate_product_qr_code_sheet(&key, &state, &id).await?;
    }

    let obj = state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(&key)
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .map_err(AppError::critical_error)?;

    let url = obj.uri();

    return Ok((
        StatusCode::OK,
        [(CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap())],
        url.to_string(),
    ));
}
async fn expiration_products_qr_code_grid(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
    Json(payload): Json<CreateProductQrCodesWithExpiration>,
) -> Result<impl IntoResponse, AppErrorResponse> {
    let key = format!(
        "{}/products/expiration/{}/{}",
        session.user.company_id.unwrap(),
        payload.expiration_date,
        id
    );

    let req = state
        .s3_client
        .head_object()
        .bucket(&state.s3_name)
        .key(&key)
        .send()
        .await;
    if req.is_err() {
        let conn = &state.get_db_conn().await?;

        let product_row = conn
            .query_one("SELECT title FROM products WHERE id = $1;", &[&id])
            .await
            .map_err(AppError::critical_error)?;
        let product_title: String = product_row.get("title");

        let statement = format!(
            "
        SELECT
            locations_products.id
        FROM
            locations_products
        WHERE
            product_id = $1
                AND
            location_id = $2
                AND
            expiration_date = $3;"
        );

        let rows = conn
            .query(
                &statement,
                &[
                    &id,
                    &session.user.location_id.unwrap(),
                    &payload.expiration_date,
                ],
            )
            .await
            .map_err(AppError::critical_error)?;

        let ids: Vec<Uuid> = rows
            .iter()
            .map(|r| {
                let id: Uuid = r.get("id");
                return id;
            })
            .collect();

        let _ = generate_product_with_expiration_qr_code_sheet(
            &key,
            &state,
            product_title,
            ids,
            payload.expiration_date,
        )
        .await?;
    }

    let obj = state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(&key)
        .presigned(PresigningConfig::expires_in(PRESIGN_DURATION).unwrap())
        .await
        .map_err(AppError::critical_error)?;

    let url = obj.uri().to_owned();

    return Ok((
        StatusCode::OK,
        [(CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap())],
        url,
    ));
}
async fn product_inventory_report(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> Result<impl IntoResponse, AppErrorResponse> {
    let conn = &state.get_db_conn().await?;

    let rows = conn
        .query(
            "SELECT products.title,
            locations_products.expiration_date, COUNT(locations_products.id)
                FROM
                    locations_products
                INNER JOIN locations_available_products
                    ON locations_available_products.product_id = locations_products.product_id
                LEFT JOIN products
                    ON locations_products.product_id = products.id
                WHERE
                    locations_products.location_id = $1
                        AND
                    (
                        products.company_id = $2
                            OR
                        products.company_id IS NULL
                    )
                GROUP BY
                    locations_products.expiration_date, products.title
                ORDER BY locations_products.expiration_date, products.title;",
            &[
                &session.user.location_id.unwrap(),
                &session.user.company_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::critical_error)?;

    let now = Utc::now();

    let result: Vec<Value> = rows.iter().map(|row| {
        let title: String = row.get("title");
        let count: i64 = row.get("count");
        let expiration_date: DateTime<Utc> = row.get("expiration_date");
        let has_about_to_expire = expiration_date.signed_duration_since(now).num_days() <= 7;
        let expiration_days = expiration_date.signed_duration_since(now).num_days();

        return json!({"title": title, "expirationDate": expiration_date, "count": count, "hasAboutToExpire": has_about_to_expire, "expirationDays": expiration_days});
    }).collect();

    let payload = json!({"items": result, "companyId": session.user.company_id, "locationId": session.user.location_id});

    let report_req = state
        .rqw_client
        .post(format!(
            "{}/api/v1/generate/from-template",
            &state.document_server_url
        ))
        .json(&payload)
        .send()
        .await
        .map_err(AppError::critical_error)?;

    let response = report_req
        .json::<InventoryReportResponse>()
        .await
        .map_err(AppError::critical_error)?;

    let title = "Inventory Report";
    conn.query("INSERT INTO files (id, title, owner_id, company_id, location_id, type, category) VALUES ($1, $2, $3, $4, $5, 'pdf', 'reports');", &[&response.id, &title, &session.user.id, &session.user.company_id.unwrap(), &session.user.location_id.unwrap()]).await.map_err(AppError::critical_error)?;

    return Ok((
        StatusCode::OK,
        [(CONTENT_TYPE, HeaderValue::from_str("text/plain").unwrap())],
        response.url,
    ));
}

pub fn url_routes() -> Router<AppState> {
    return Router::new().nest(
        "/url",
        Router::new()
            .route("/{id}/location-logo", get(location_logo_url_route))
            .route("/{id}/user-avatar", get(user_avatar_url_route))
            .route("/{id}/product-qr-code", get(product_qr_code_grid))
            .route(
                "/{id}/expiration-products-qr-code",
                post(expiration_products_qr_code_grid),
            )
            .route("/inventory-report", get(product_inventory_report)),
    );
}
