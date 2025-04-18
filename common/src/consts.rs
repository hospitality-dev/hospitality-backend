use std::time::Duration;

pub const DUMMY_PASSWORD: &str = "DUmMY_P@sSW0d579_0";
pub const AUTH_SESSION_TIME: i32 = 29700; // 8 hours 15 mins
pub const PRESIGN_DURATION: Duration = Duration::from_secs(3600); // 60 mins
pub const MAX_FILE_SIZE: usize = 20_000_000;
pub const A4_SIZE: (u32, u32) = (2480, 3508);
pub const USERS_FIELDS: [&str; 12] = [
    "id",
    "created_at",
    "updated_at",
    "deleted_at",
    "first_name",
    "last_name",
    "date_of_birth",
    "date_of_employment",
    "date_of_termination",
    "image_id",
    "username",
    "is_verified",
];
pub const ROLES_FIELDS: [&str; 3] = ["id", "title", "company_id"];
pub const PRODUCTS_CATEGORIES_FIELDS: [&str; 8] = [
    "id",
    "created_at",
    "updated_at",
    "deleted_at",
    "title",
    "parent_id",
    "is_default",
    "company_id",
];
pub const LOCATIONS_FIELDS: [&str; 8] = [
    "id",
    "created_at",
    "updated_at",
    "deleted_at",
    "title",
    "owner_id",
    "image_id",
    "company_id",
];

pub const PRODUCTS_FIELDS: [&str; 10] = [
    "id",
    "title",
    "description",
    "weight",
    "volume",
    "barcode",
    "category_id",
    "subcategory_id",
    "image_id",
    "company_id",
];

pub const LOCATIONS_AVAILABLE_PRODUCTS_FIELDS: [&str; 3] = ["id", "product_id", "location_id"];
pub const LOCATIONS_PRODUCTS_FIELDS: [&str; 4] = [
    "id",
    "available_product_id",
    "location_id",
    "expiration_date",
];
pub const LOCATIONS_USERS_FIELDS: [&str; 4] = ["id", "user_id", "location_id", "role_id"];
pub const CONTACTS_FIELDS: [&str; 12] = [
    "id",
    "title",
    "parent_id",
    "prefix",
    "value",
    "contact_type",
    "latitude",
    "longitude",
    "bounding_box",
    "is_public",
    "place_id",
    "iso_3",
];

pub const FILES_FIELDS: [&str; 9] = [
    "id",
    "created_at",
    "deleted_at",
    "title",
    "owner_id",
    "company_id",
    "location_id",
    "type",
    "category",
];
pub const COUNTRIES_FIELDS: [&str; 17] = [
    "id",
    "title",
    "iso2",
    "iso3",
    "numeric_code",
    "phonecode",
    "capital",
    "currency",
    "currency_name",
    "currency_symbol",
    "tld",
    "timezones",
    "latitude",
    "longitude",
    "wikiDataId",
    "region_id",
    "subregion_id",
];
