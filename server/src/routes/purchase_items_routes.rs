use axum::{
    extract::{Path, State},
    routing::get,
    Extension, Json, Router,
};
use serde_json::Value;
use uuid::Uuid;

use crate::{
    enums::errors::AppError,
    middlware::crud_middleware::AllowedFieldsType,
    models::{
        auth::AuthSession,
        locations_products::InsertProductsFromPurchaseItems,
        response::{AppResponse, RouteResponse},
        state::AppState,
    },
    traits::db_traits::SerializeList,
};

async fn list_purchase_items(
    State(state): State<AppState>,
    Extension(session): Extension<AuthSession>,
    Extension(fields): Extension<AllowedFieldsType>,
    Path(parent_id): Path<Uuid>,
) -> RouteResponse<Value> {
    let conn = state.get_db_conn().await?;

    let mut select_fields = format!(
        "SELECT {} FROM purchase_items WHERE parent_id = $1 AND location_id = $2;",
        fields
    );

    if fields.contains("purchase_items.title") {
        let replacement = "COALESCE(products.title, purchase_items.title) as title";
        select_fields = fields.replace("purchase_items.title", replacement);
    }

    let rows = conn
        .query(
            &format!(
                "SELECT {}, products.weight, products.weight_unit, products.volume, products.volume_unit
                FROM
                    purchase_items
                LEFT JOIN products_aliases
                    ON products_aliases.title = purchase_items.title
                LEFT JOIN products
                    ON products_aliases.product_id = products.id
                 WHERE
                    purchase_items.parent_id = $1
                        AND
                    purchase_items.location_id = $2;",
                select_fields
            ),
            &[&parent_id, &session.user.location_id.unwrap()],
        )
        .await
        .map_err(AppError::db_error)?;

    return Ok(AppResponse::default_response(rows.serialize_list(true)));
}

// async fn list_purchase_items_to_modify(
//     State(state): State<AppState>,
//     Extension(session): Extension<AuthSession>,
//     Json(payload): Json<InsertProductsFromPurchaseItems>,
// ) -> RouteResponse<Value> {
//     let conn = state.get_db_conn().await?;

//     let rows = conn
//         .query(
//             "SELECT purchase_items.id, products.id as product_id, quantity,
//             products.weight, products.weight_unit, products.volume, products.volume_unit,
//             COALESCE(products.title, purchase_items.title) as title
//                 FROM
//                     purchase_items
//                 LEFT JOIN products_aliases
//                     ON products_aliases.title = purchase_items.title
//                 LEFT JOIN products
//                     ON products_aliases.product_id = products.id
//                  WHERE
//                     purchase_items.parent_id = $1
//                         AND
//                     purchase_items.location_id = $2;",
//             &[&parent_id, &session.user.location_id.unwrap()],
//         )
//         .await
//         .map_err(AppError::db_error)?;

//     return Ok(AppResponse::default_response(rows.serialize_list(true)));
// }

pub fn purchase_items_routes() -> Router<AppState> {
    return Router::new().nest(
        "/purchase-items",
        Router::new().route("/list/{parent_id}", get(list_purchase_items)), // .route(
                                                                            //     "/list/{parent_id}/modify",
                                                                            //     get(list_purchase_items_to_modify),
                                                                            // ),
    );
}
