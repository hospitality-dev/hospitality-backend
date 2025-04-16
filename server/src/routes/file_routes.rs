use axum::{
    extract::{DefaultBodyLimit, Multipart, Path, State},
    routing::post,
    Extension, Router,
};
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    models::{
        auth::AuthSession,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    utils::{consts::MAX_FILE_SIZE, file_utils::upload_file},
};

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

pub fn file_routes() -> Router<AppState> {
    Router::new().nest(
        "/files",
        Router::new()
            .route("/location-logo/{id}", post(upload_location_logo))
            .route("/user-avatar/{id}", post(upload_user_avatar))
            .layer(DefaultBodyLimit::max(MAX_FILE_SIZE)),
    )
}
