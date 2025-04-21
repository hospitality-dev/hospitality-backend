use chrono::{DateTime, Utc};
use garde::Validate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct InvoiceData {
    pub invoice_request: InvoiceRequest,
    pub invoice_result: InvoiceResult,
    pub journal: String,
    pub is_valid: bool,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]

pub struct InvoiceRequest {
    pub tax_id: String,
    pub business_name: String,
    pub location_name: String,
    pub address: String,
    pub city: String,
    pub invoice_type: i16,
    pub transaction_type: i16,
    pub payments: Vec<Payment>,
}

#[derive(Serialize, Deserialize, Debug, Default)]
#[serde(rename_all = "camelCase")]

pub struct Payment {
    pub payment_type: i16,
    pub amount: f64,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]

pub struct InvoiceResult {
    pub total_amount: Decimal,
    pub invoice_counter_extension: String,
    pub invoice_number: String,
    pub sdc_time: DateTime<Utc>,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]

pub struct PurchaseItem {
    pub id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<DateTime<Utc>>,
    pub title: String,
    pub company_id: Uuid,
    pub location_id: Uuid,
    pub parent_id: Uuid,
    pub product_id: Uuid,
    pub owner_id: Uuid,
}
#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]

pub struct Purchase {
    pub id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<DateTime<Utc>>,
    pub purchased_at: Option<DateTime<Utc>>,
    pub company_id: Uuid,
    pub location_id: Uuid,
    pub owner_id: Uuid,
    pub total: Decimal,
    pub payment_type: i16,
    pub address: Option<String>,
    pub business_title: String,
    pub business_location_title: String,
    pub tax_id: Option<String>,
    pub transaction_type: i16,
    pub invoice_type: i16,
    pub invoice_counter_extension: String,
    pub invoice_number: String,
    pub purchase_items: Vec<PurchaseItem>,
}

#[derive(Serialize, Deserialize, Debug, Validate)]
#[serde(rename_all = "camelCase")]
pub struct InsertPurchase {
    #[garde(url)]
    pub url: String,
}
