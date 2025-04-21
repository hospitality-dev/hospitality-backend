use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use uuid::Uuid;

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
