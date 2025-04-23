use axum::{
    body::Body,
    extract::{DefaultBodyLimit, Multipart, Path, Query, State},
    http::Response,
    middleware::map_request_with_state,
    response::Redirect,
    routing::{get, post},
    Extension, Router,
};
use chrono::{DateTime, Duration, Utc};
use chrono_tz::Tz;
use regex::Regex;
use reqwest::header::{CONTENT_DISPOSITION, CONTENT_TYPE};
use rust_decimal::Decimal;
use serde_json::{json, Value};
use uuid::Uuid;

use crate::{
    enums::{
        errors::AppError,
        files::{FileCategories, FileTypes},
    },
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        requests::QueryParams,
        response::{AppErrorResponse, AppResponse, RouteResponse},
        state::AppState,
        url_responses::GenerateFileResponse,
    },
    traits::db_traits::SerializeList,
    utils::{file_utils::upload_file, transform_utils::extract_unit_from_name},
};
use common::{
    consts::{MAX_FILE_SIZE, UNITS_REGEX},
    utils::date_time_utils::{convert_to_tz, format_date_to_string},
};
async fn upload_location_logo(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(location_id): Path<Uuid>,
    mut payload: Multipart,
) -> RouteResponse<Uuid> {
    if session.user.company_id.is_none() || session.user.location_id.is_none() {
        return Err(AppError::forbidden_response(
            "No company_id or location_id present in user session. | ROUTE create_files",
        ));
    }

    let field = payload.next_field().await;

    if field.is_err() {
        return Err(AppError::default_response(format!(
            "Error uploading user avatar - no files in while loop. {}",
            field.err().unwrap()
        )));
    }
    let field = field.unwrap();

    if field.is_none() {
        return Err(AppError::default_response(
            "Error uploading location logo - no file found.",
        ));
    }
    let field = field.unwrap();

    //* Establish a connection before attempting upload
    //* so that if upload succeeds but connection does not
    //* we don't end up with an orphan file
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::db_error)?;
    let mut errors: Vec<String> = Vec::new();
    let file_id: Option<Uuid> = tx
        .query_one(
            "SELECT image_id FROM locations WHERE locations.id = $1;",
            &[&location_id],
        )
        .await
        .map_err(AppError::db_error)?
        .get("image_id");

    let file_id = file_id.unwrap_or(Uuid::new_v4());

    let file_path = String::from(format!(
        "{}/{}/logos/{}",
        &session.user.company_id.unwrap(), //* company_id presence checked above ^
        &session.user.location_id.unwrap(), //* location_id presence checked above ^
        &file_id
    ));
    let upload = upload_file(&state, &mut errors, field, &file_path).await;

    //* Only single file will be uploaded so this is fine
    let statement = tx
                    .prepare(
                        "INSERT INTO files (id, title, owner_id, type, category) VALUES ($1, $2, $3, $4, 'images') ON CONFLICT(id)
                        DO UPDATE
                        SET title = COALESCE($2, files.title)
                        RETURNING id;",
                    )
                    .await
                    .map_err(AppError::db_error)?;
    let upload_result = upload.unwrap();
    let res = tx
        .query_one(
            &statement,
            &[
                &file_id,
                &upload_result.0,
                &session.user.id,
                &upload_result.1.to_string(),
            ],
        )
        .await;

    if res.is_err() {
        tracing::error!("{}", res.err().unwrap());

        let del_res = &state
            .s3_client
            .delete_object()
            .bucket(&state.s3_name)
            .key(file_path)
            .send()
            .await;

        if del_res.is_err() {
            tracing::error!("{}", del_res.as_ref().err().unwrap());
        }
        return Err(AppError::default_response("Error uploading location logo."));
    } else {
        let row = res.unwrap();
        let id = row.get("id");

        tx.execute(
            "UPDATE locations SET image_id = $1 WHERE id = $2;",
            &[&id, &location_id],
        )
        .await
        .map_err(AppError::db_error)?;
        let _ = tx.commit().await.map_err(AppError::db_error)?;
        return Ok(AppResponse::default_response(id));
    }
}

async fn upload_user_avatar(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(user_id): Path<Uuid>,
    mut payload: Multipart,
) -> RouteResponse<Uuid> {
    if session.user.company_id.is_none() || session.user.location_id.is_none() {
        return Err(AppError::forbidden_response(
            "No company_id or location_id present in user session. | ROUTE create_files",
        ));
    }

    let field = payload.next_field().await;

    if field.is_err() {
        return Err(AppError::default_response(format!(
            "Error uploading user avatar - no files in while loop. {}",
            field.err().unwrap()
        )));
    }
    let field = field.unwrap();

    if field.is_none() {
        return Err(AppError::default_response(
            "Error uploading location logo - no file found.",
        ));
    }
    let field = field.unwrap();

    //* Establish a connection before attempting upload
    //* so that if upload succeeds but connection does not
    //* we don't end up with an orphan file
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::db_error)?;
    let mut errors: Vec<String> = Vec::new();
    let file_id: Option<Uuid> = tx
        .query_one(
            "SELECT image_id FROM users WHERE users.id = $1;",
            &[&user_id],
        )
        .await
        .map_err(AppError::db_error)?
        .get("image_id");
    let file_id = file_id.unwrap_or(Uuid::new_v4());

    let file_path = String::from(format!(
        "{}/users/{}",
        &session.user.company_id.unwrap(), //* company_id presence checked above ^
        &file_id
    ));

    let upload = upload_file(&state, &mut errors, field, &file_path).await;

    //* Only single file will be uploaded so this is fine
    if upload.is_ok() {
        let statement = tx
                    .prepare(
                        "INSERT INTO files (id, title, owner_id, type, category) VALUES ($1, $2, $3, $4, 'images') ON CONFLICT(id)
                        DO UPDATE
                        SET title = COALESCE($2, files.title)
                        RETURNING id;",
                    )
                    .await
                    .map_err(AppError::db_error)?;
        let upload_result = upload.unwrap();
        let res = tx
            .query_one(
                &statement,
                &[
                    &file_id,
                    &upload_result.0,
                    &session.user.id,
                    &upload_result.1.to_string(),
                ],
            )
            .await;

        if res.is_err() {
            tracing::error!("{}", res.err().unwrap());

            let del_res = &state
                .s3_client
                .delete_object()
                .bucket(&state.s3_name)
                .key(file_path)
                .send()
                .await;

            if del_res.is_err() {
                tracing::error!("{}", del_res.as_ref().err().unwrap());
            }
            return Err(AppError::default_response("Error uploading user avatar."));
        } else {
            let row = res.unwrap();
            let id = row.get("id");

            tx.execute(
                "UPDATE users SET image_id = $1 WHERE id = $2;",
                &[&id, &user_id],
            )
            .await
            .map_err(AppError::db_error)?;
            let _ = tx.commit().await.map_err(AppError::db_error)?;
            return Ok(AppResponse::default_response(id));
        }
    } else {
        return Err(AppError::default_response(upload.err().unwrap()));
    }
}

async fn list_files_category(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Path(category): Path<FileCategories>,
    query: Query<QueryParams>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;
    let sort = query.to_query_sort();

    let rows = conn
        .query(
            &format!(
                "SELECT {}
                FROM
                    files
                WHERE
                    category = $1
                        AND
                    location_id = $2
                {}
                ;",
                fields, &sort
            ),
            &[&category.to_string(), &session.user.location_id.unwrap()],
        )
        .await
        .map_err(AppError::critical_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}
async fn download_file(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
) -> Result<Response<Body>, AppErrorResponse> {
    let conn = state.get_db_conn().await?;
    let company_id = session.user.company_id.unwrap();
    let location_id = session.user.location_id.unwrap();

    let row = conn.query_one("SELECT id, title, type, category FROM files WHERE id = $1 AND company_id = $2 AND location_id = $3;", &[&id, &company_id, &location_id]).await.map_err(AppError::critical_error)?;

    let id: Uuid = row.get("id");
    let title: String = row.get("title");
    let file_type: FileTypes = row.get("type");
    let category: FileCategories = row.get("category");

    let bytes = state
        .s3_client
        .get_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/{}/{}/{}",
            company_id, category, location_id, id
        ))
        .send()
        .await
        .map_err(AppError::critical_error)?;

    let bytes = bytes
        .body
        .collect()
        .await
        .map_err(AppError::critical_error)?
        .into_bytes()
        .to_vec();

    let response = Response::builder()
        .header(CONTENT_TYPE, file_type.content_type())
        .header(
            CONTENT_DISPOSITION,
            format!(
                "attachment; filename=\"{}\"",
                format!("{}.{}", title, file_type)
            ),
        )
        .body(bytes.into())
        .map_err(AppError::critical_error)?;

    return Ok(response);
}

async fn product_inventory_report(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
) -> Result<Redirect, AppErrorResponse> {
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
        let duration = expiration_date.signed_duration_since(now);
        let expiration_days = duration.num_days();
        let has_about_to_expire = (if duration > Duration::days(expiration_days) {expiration_days + 1 } else {expiration_days}) <= 7;

        return  json!({"title": title, "expirationDate": expiration_date, "count": count, "hasAboutToExpire": has_about_to_expire, "expirationDays": expiration_days});
    }).collect();

    let payload = json!({"items": result, "companyId": session.user.company_id, "locationId": session.user.location_id});

    let report_req = state
        .rqw_client
        .post(format!(
            "{}/api/v1/generate/inventory-report",
            &state.document_server_url
        ))
        .header("x-documents-api-key", &state.documents_api_key)
        .json(&payload)
        .send()
        .await
        .map_err(AppError::critical_error)?;

    let response = report_req
        .json::<GenerateFileResponse>()
        .await
        .map_err(AppError::critical_error)?;

    let title = "Inventory Report";
    conn.query(
        "INSERT INTO files (id, title, owner_id, company_id, location_id, type, category)
        VALUES ($1, $2, $3, $4, $5, 'pdf', 'reports');",
        &[
            &response.id,
            &title,
            &session.user.id,
            &session.user.company_id.unwrap(),
            &session.user.location_id.unwrap(),
        ],
    )
    .await
    .map_err(AppError::critical_error)?;

    return Ok(Redirect::to(&format!(
        "{}/api/v1/url/reports/{}",
        &state.server_url, &response.id
    )));
}

async fn product_qr_codes(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
) -> Result<Redirect, AppErrorResponse> {
    let conn = &state.get_db_conn().await?;

    let title_row = conn
        .query_one("SELECT products.title FROM products WHERE id = $1;", &[&id])
        .await
        .map_err(AppError::critical_error)?;

    let title: String = title_row.get("title");

    let rows = conn
        .query(
            "SELECT locations_products.id, locations_products.expiration_date FROM locations_products
            WHERE locations_products.product_id = $1 AND location_id = $2;"
            ,&[
                &id,
                &session.user.location_id.unwrap(),
            ],
        )
        .await
        .map_err(AppError::critical_error)?;

    let payload = json!({"title": title, "items": rows.serialize_list(true), "companyId": session.user.company_id, "locationId": session.user.location_id});

    let report_req = state
        .rqw_client
        .post(format!(
            "{}/api/v1/generate/products/qr-codes",
            &state.document_server_url
        ))
        .header("x-documents-api-key", &state.documents_api_key)
        .json(&payload)
        .send()
        .await
        .map_err(AppError::critical_error)?;

    let response = report_req
        .json::<GenerateFileResponse>()
        .await
        .map_err(AppError::critical_error)?;

    return Ok(Redirect::to(&format!(
        "{}/api/v1/url/qr-codes/{}",
        &state.server_url, &response.id
    )));
}

async fn purchases_bill(
    Extension(session): Extension<AuthSession>,
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
) -> Result<Redirect, AppErrorResponse> {
    let exists = state
        .s3_client
        .head_object()
        .bucket(&state.s3_name)
        .key(format!(
            "{}/{}/receipts/{}",
            session.user.company_id.unwrap(),
            session.user.location_id.unwrap(),
            id
        ))
        .send()
        .await;
    println!("{}", exists.is_ok());
    if exists.is_ok() {
        return Ok(Redirect::to(&format!(
            "{}/api/v1/url/receipts/{}",
            &state.server_url, &id
        )));
    }

    let conn = &state.get_db_conn().await?;
    let m = Regex::new(UNITS_REGEX).unwrap();

    let purchase_row = conn
        .query_one(
            "SELECT purchased_at, business_title, business_location_title, city, address, total FROM purchases WHERE id = $1;",
            &[&id],
        )
        .await
        .map_err(AppError::db_error)?;

    let total: Decimal = purchase_row.get("total");
    let purchased_at: DateTime<Utc> = purchase_row.get("purchased_at");
    let business_title: String = purchase_row.get("business_title");
    let address: String = purchase_row.get("address");
    let city: String = purchase_row.get("city");
    let business_location_title: String = purchase_row.get("business_location_title");

    let items: Vec<Value> = conn
        .query(
            "SELECT title, price_per_unit, quantity FROM purchase_items WHERE parent_id = $1;",
            &[&id],
        )
        .await
        .map_err(AppError::db_error)?
        .iter()
        .map(|row| {
            let title: String = row.get("title");
            let price_per_unit: f32 = row.get("price_per_unit");
            let quantity: f32 = row.get("quantity");

            let unit = extract_unit_from_name(&title).unwrap_or_default();
            let mut quantity_string = format!("{}{}", quantity.to_string(), unit);

            if !quantity_string.contains("KG") {
                let p = m.captures(&title);
                if let Some(matched) = p {
                    let amount = matched.get(1);
                    let unit = matched.get(2);

                    if amount.is_some() && unit.is_some() {
                        let amount = amount.unwrap().as_str().parse::<f32>().unwrap_or_default();
                        let unit = unit.unwrap().as_str();

                        if amount > 0.0 {
                            let final_amount = amount * quantity;
                            quantity_string.push_str(&format!(" ({}{})", final_amount, unit));
                        }
                    }
                }
            }

            return json!({"title": title.trim(), "pricePerUnit": price_per_unit,
            "quantity": quantity_string.to_lowercase(), "total": quantity * price_per_unit, });
        })
        .collect();

    let payload = json!({
    "id": id,
    "businessTitle": business_title,
    "city": city, "address": address,
    "total": total, "purchasedAt": format_date_to_string(convert_to_tz(purchased_at, Tz::Europe__Belgrade), "%d/%m/%Y %H:%M"),
    "businessLocationTitle": business_location_title,
    "items": items,
    "companyId": session.user.company_id.unwrap(),
    "locationId": session.user.location_id.unwrap(),
    });

    let report_req = state
        .rqw_client
        .post(format!(
            "{}/api/v1/generate/purchases/bill",
            &state.document_server_url
        ))
        .header("x-documents-api-key", &state.documents_api_key)
        .json(&payload)
        .send()
        .await
        .map_err(AppError::critical_error)?;

    let response = report_req
        .json::<GenerateFileResponse>()
        .await
        .map_err(AppError::critical_error)?;

    return Ok(Redirect::to(&format!(
        "{}/api/v1/url/receipts/{}",
        &state.server_url, &response.id
    )));
}

pub fn file_routes() -> Router<AppState> {
    Router::new()
        .nest(
            "/files",
            Router::new()
                .route("/location-logo/{id}", post(upload_location_logo))
                .route("/user-avatar/{id}", post(upload_user_avatar))
                .route("/list/{category}", get(list_files_category))
                .route("/download/{id}", get(download_file))
                .nest(
                    "/generate",
                    Router::new()
                        .route("/products/reports", get(product_inventory_report))
                        .route("/products/qr-codes/{id}", get(product_qr_codes))
                        .route("/purchases/bill/reports/{id}", get(purchases_bill)),
                ),
        )
        .layer(DefaultBodyLimit::max(MAX_FILE_SIZE))
}
