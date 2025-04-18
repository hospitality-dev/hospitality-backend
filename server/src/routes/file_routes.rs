use axum::{
    body::Body,
    extract::{DefaultBodyLimit, Multipart, Path, State},
    http::Response,
    response::Redirect,
    routing::{get, post},
    Extension, Router,
};
use chrono::{DateTime, Utc};
use reqwest::header::{CONTENT_DISPOSITION, CONTENT_TYPE};
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
        response::{AppErrorResponse, AppResponse, RouteResponse},
        state::AppState,
        url_responses::InventoryReportResponse,
    },
    traits::db_traits::SerializeList,
    utils::file_utils::upload_file,
};
use common::consts::MAX_FILE_SIZE;
async fn upload_location_logo(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
    mut payload: Multipart,
) -> RouteResponse<Uuid> {
    if session.user.company_id.is_none() || session.user.location_id.is_none() {
        return Err(AppError::forbidden_response(
            "No company_id or location_id present in user session. | ROUTE create_files",
        ));
    }

    //* Establish a connection before attempting upload
    //* so that if upload succeeds but connection does not
    //* we don't end up with an orphan file
    let mut conn = state.get_db_conn().await?;
    let tx = conn.transaction().await.map_err(AppError::critical_error)?;
    let mut errors: Vec<String> = Vec::new();
    let file_id: Option<Uuid> = tx
        .query_one(
            "SELECT image_id FROM locations WHERE locations.id = $1;",
            &[&id],
        )
        .await
        .map_err(AppError::critical_error)?
        .get("image_id");

    while let Some(field) = payload.next_field().await.unwrap_or_default() {
        let file_path = String::from(format!(
            "{}/locations/{}/{}",
            &session.user.company_id.unwrap(), //* company_id presence checked above ^
            &session.user.location_id.unwrap(), //* location_id presence checked above ^
            &file_id.unwrap_or(Uuid::new_v4())
        ));
        let upload = upload_file(&state, &mut errors, field, &file_id, file_path).await;

        //* Only single file will be uploaded so this is fine
        if upload.is_ok() {
            //* If image was not set before
            if file_id.is_none() {
                let statement = tx
                    .prepare(
                        "INSERT INTO files (id, title, owner_id, type) VALUES ($1, $2, $3, $4) RETURNING id;",
                    )
                    .await
                    .map_err(AppError::critical_error)?;
                let upload_result = upload.unwrap();
                let res = tx
                    .query_one(
                        &statement,
                        &[
                            &upload_result.0,
                            &upload_result.1,
                            &session.user.id,
                            &upload_result.2.to_string(),
                        ],
                    )
                    .await;

                let location_logo_res = tx
                    .execute(
                        "UPDATE locations SET image_id = $1 WHERE id = $2;",
                        &[&upload_result.0, &id],
                    )
                    .await;

                if res.is_err() || location_logo_res.is_err() {
                    if res.is_err() {
                        tracing::error!("{}", res.err().unwrap());
                    } else if location_logo_res.is_err() {
                        tracing::error!("{}", location_logo_res.err().unwrap());
                    }

                    let del_res = &state
                        .s3_client
                        .delete_object()
                        .bucket(&state.s3_name)
                        .key(format!(
                            "{}/{}/{}",
                            &session.user.company_id.unwrap(),
                            &session.user.location_id.unwrap(),
                            &upload_result.0,
                        ))
                        .send()
                        .await;

                    if del_res.is_err() {
                        tracing::error!("{}", del_res.as_ref().err().unwrap());
                    }
                    errors.push(upload_result.1);
                } else {
                    let row = res.unwrap();
                    let id = row.get("id");
                    let _ = tx.commit().await.map_err(AppError::critical_error)?;
                    return Ok(AppResponse::default_response(id));
                }
            }
            //* If image is already set
            else {
                let file_id = file_id.unwrap();

                let upload_res = upload.unwrap();
                let location_logo_res = tx
                    .execute(
                        "UPDATE files SET title = COALESCE($1, title), type = COALESCE($2, type) WHERE id = $3;",
                        &[&upload_res.1, &upload_res.2.to_string(), &file_id],
                    )
                    .await;

                if location_logo_res.is_ok() {
                    let _ = tx.commit().await.map_err(AppError::critical_error)?;
                    return Ok(AppResponse::default_response(file_id));
                } else {
                    let _ = tx.rollback().await.map_err(AppError::critical_error)?;
                    return Err(AppError::critical_error(location_logo_res.err().unwrap()));
                }
            }
        } else {
            return Err(AppError::default_response(upload.err().unwrap()));
        }
    }
    return Err(AppError::default_response(format!(
        "Error uploading location logo - no files in while loop. {}",
        errors.join(" | ")
    )));
}

async fn upload_user_avatar(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Path(id): Path<Uuid>,
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
    let tx = conn.transaction().await.map_err(AppError::critical_error)?;
    let mut errors: Vec<String> = Vec::new();
    let file_id: Option<Uuid> = tx
        .query_one("SELECT image_id FROM users WHERE users.id = $1;", &[&id])
        .await
        .map_err(AppError::critical_error)?
        .get("image_id");

    let file_path = String::from(format!(
        "{}/users/{}",
        &session.user.company_id.unwrap(), //* company_id presence checked above ^
        &file_id.unwrap_or(Uuid::new_v4())
    ));

    let upload = upload_file(&state, &mut errors, field, &file_id, file_path).await;

    //* Only single file will be uploaded so this is fine
    if upload.is_ok() {
        //* If image was not set before
        if file_id.is_none() {
            let statement = tx
                    .prepare(
                        "INSERT INTO files (id, title, owner_id, type) VALUES ($1, $2, $3, $4) RETURNING id;",
                    )
                    .await
                    .map_err(AppError::critical_error)?;
            let upload_result = upload.unwrap();
            let res = tx
                .query_one(
                    &statement,
                    &[
                        &upload_result.0,
                        &upload_result.1,
                        &session.user.id,
                        &upload_result.2.to_string(),
                    ],
                )
                .await;

            let user_image_res = tx
                .execute(
                    "UPDATE users SET image_id = $1 WHERE id = $2;",
                    &[&upload_result.0, &id],
                )
                .await;

            if res.is_err() || user_image_res.is_err() {
                if res.is_err() {
                    return Err(AppError::default_response(res.err().unwrap()));
                } else if user_image_res.is_err() {
                    return Err(AppError::default_response(user_image_res.err().unwrap()));
                }

                let del_res = &state
                    .s3_client
                    .delete_object()
                    .bucket(&state.s3_name)
                    .key(upload_result.3)
                    .send()
                    .await;

                if del_res.is_err() {
                    let err = del_res.as_ref().err();
                    return Err(AppError::default_response(err.unwrap()));
                } else {
                    return Err(AppError::default_response("Error uploading user image."));
                }
            } else {
                let row = res.unwrap();
                let id = row.get("id");
                let _ = tx.commit().await.map_err(AppError::critical_error)?;
                return Ok(AppResponse::default_response(id));
            }
        }
        //* If image is already set
        else {
            let file_id = file_id.unwrap();

            let upload_res = upload.unwrap();
            let location_logo_res = tx
                    .execute(
                        "UPDATE files SET title = COALESCE($1, title), type = COALESCE($2, type) WHERE id = $3;",
                        &[&upload_res.1, &upload_res.2.to_string(), &file_id],
                    )
                    .await;

            if location_logo_res.is_ok() {
                let _ = tx.commit().await.map_err(AppError::critical_error)?;
                return Ok(AppResponse::default_response(file_id));
            } else {
                let _ = tx.rollback().await.map_err(AppError::critical_error)?;
                return Err(AppError::critical_error(location_logo_res.err().unwrap()));
            }
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
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let rows = conn
        .query(
            &format!(
                "SELECT {} FROM files WHERE category = $1 AND location_id = $2;",
                fields
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
    println!(
        "{}",
        format!("{}/{}/{}/{}", company_id, category, location_id, id)
    );
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
    println!("TEST2");

    let bytes = bytes
        .body
        .collect()
        .await
        .map_err(AppError::critical_error)?
        .into_bytes()
        .to_vec();

    println!("TEST3");

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
    println!("TEST4");

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
        let has_about_to_expire = expiration_date.signed_duration_since(now).num_days() <= 7;
        let expiration_days = expiration_date.signed_duration_since(now).num_days();

        return  json!({"title": title, "expirationDate": expiration_date, "count": count, "hasAboutToExpire": has_about_to_expire, "expirationDays": expiration_days});
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

pub fn file_routes() -> Router<AppState> {
    Router::new().nest(
        "/files",
        Router::new()
            .route("/location-logo/{id}", post(upload_location_logo))
            .route("/user-avatar/{id}", post(upload_user_avatar))
            .route("/list/{category}", get(list_files_category))
            .route("/download/{id}", get(download_file))
            .nest(
                "/generate",
                Router::new().route("/reports", get(product_inventory_report)),
            )
            .layer(DefaultBodyLimit::max(MAX_FILE_SIZE)),
    )
}
