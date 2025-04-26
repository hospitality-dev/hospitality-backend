use std::{collections::HashSet, str::FromStr};

use garde::rules::AsStr;
use serde::{Deserialize, Serialize};
use strum::VariantNames;

use crate::{
    models::response::AppErrorResponse,
    traits::model_traits::{AllowedFields, SelectableFields},
};
use common::consts::{
    BRANDS_FIELDS, CONTACTS_FIELDS, COUNTRIES_FIELDS, FILES_FIELDS,
    LOCATIONS_AVAILABLE_PRODUCTS_FIELDS, LOCATIONS_FIELDS, LOCATIONS_PRODUCTS_FIELDS,
    LOCATIONS_USERS_FIELDS, MANUFACTURERS_FIELDS, PRODUCTS_CATEGORIES_FIELDS, PRODUCTS_FIELDS,
    PURCHASES_FIELDS, PURCHASE_ITEMS_FIELDS, ROLES_FIELDS, STORES_FIELDS, SUPPLIERS_FIELDS,
    USERS_FIELDS,
};

#[derive(Clone, Debug, Serialize, Deserialize, VariantNames, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]
pub enum Models {
    Users,
    Roles,
    Locations,
    ProductsCategories,
    Products,
    LocationsAvailableProducts,
    LocationsProducts,
    LocationsUsers,
    Contacts,
    Files,
    Countries,
    Purchases,
    PurchaseItems,
    Suppliers,
    Stores,
    Manufacturers,
    Brands,
    Unknown(String),
}

impl Default for Models {
    fn default() -> Self {
        Models::Unknown("NONE".to_string())
    }
}

impl ToString for Models {
    fn to_string(&self) -> String {
        match self {
            Models::Users => "users".to_string(),
            Models::Roles => "roles".to_string(),
            Models::Locations => "locations".to_string(),
            Models::ProductsCategories => "products_categories".to_string(),
            Models::Products => "products".to_string(),
            Models::LocationsAvailableProducts => "locations_available_products".to_string(),
            Models::LocationsProducts => "locations_products".to_string(),
            Models::LocationsUsers => "locations_users".to_string(),
            Models::Contacts => "contacts".to_string(),
            Models::Files => "files".to_string(),
            Models::Countries => "countries".to_string(),
            Models::Purchases => "purchases".to_string(),
            Models::PurchaseItems => "purchase_items".to_string(),
            Models::Suppliers => "suppliers".to_string(),
            Models::Stores => "stores".to_string(),
            Models::Manufacturers => "manufacturers".to_string(),
            Models::Brands => "brands".to_string(),
            Models::Unknown(name) => format!("UNKNOWN MODEL - {}", name),
        }
    }
}

impl AsStr for Models {
    fn as_str(&self) -> &str {
        match self {
            Models::Users => "users",
            Models::Roles => "roles",
            Models::Locations => "locations",
            Models::ProductsCategories => "products_categories",
            Models::Products => "products",
            Models::LocationsAvailableProducts => "locations_available_products",
            Models::LocationsProducts => "locations_products",
            Models::LocationsUsers => "locations_users",
            Models::Contacts => "contacts",
            Models::Files => "files",
            Models::Countries => "countries",
            Models::Purchases => "purchases",
            Models::PurchaseItems => "purchase_items",
            Models::Suppliers => "suppliers",
            Models::Stores => "stores",
            Models::Manufacturers => "manufacturers",
            Models::Brands => "brands",
            Models::Unknown(_) => "unknown",
        }
    }
}

impl FromStr for Models {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "users" => Ok(Models::Users),
            "roles" => Ok(Models::Roles),
            "locations" => Ok(Models::Locations),
            "products" => Ok(Models::Products),
            "products-categories" => Ok(Models::ProductsCategories),
            "locations-available-products" => Ok(Models::LocationsAvailableProducts),
            "locations-products" => Ok(Models::LocationsProducts),
            "locations-users" => Ok(Models::LocationsUsers),
            "contacts" => Ok(Models::Contacts),
            "files" => Ok(Models::Files),
            "countries" => Ok(Models::Countries),
            "purchases" => Ok(Models::Purchases),
            "purchase-items" => Ok(Models::PurchaseItems),
            "suppliers" => Ok(Models::Suppliers),
            "stores" => Ok(Models::Stores),
            "manufacturers" => Ok(Models::Manufacturers),
            "brands" => Ok(Models::Brands),
            _ => Ok(Models::Unknown(s.to_string())),
        }
    }
}

impl AllowedFields for Models {
    fn get_allowed_fields(&self) -> Result<HashSet<&str>, AppErrorResponse> {
        Ok(match self {
            &Models::Users => HashSet::from_iter(USERS_FIELDS),
            &Models::Roles => HashSet::from_iter(ROLES_FIELDS),
            &Models::Locations => HashSet::from_iter(LOCATIONS_FIELDS),
            &Models::ProductsCategories => HashSet::from_iter(PRODUCTS_CATEGORIES_FIELDS),
            &Models::Products => HashSet::from_iter(PRODUCTS_FIELDS),
            &Models::LocationsAvailableProducts => {
                HashSet::from_iter(LOCATIONS_AVAILABLE_PRODUCTS_FIELDS)
            }

            &Models::LocationsProducts => HashSet::from_iter(LOCATIONS_PRODUCTS_FIELDS),
            &Models::LocationsUsers => HashSet::from_iter(LOCATIONS_USERS_FIELDS),
            &Models::Contacts => HashSet::from_iter(CONTACTS_FIELDS),
            &Models::Files => HashSet::from_iter(FILES_FIELDS),
            &Models::Countries => HashSet::from_iter(COUNTRIES_FIELDS),
            &Models::Purchases => HashSet::from_iter(PURCHASES_FIELDS),
            &Models::PurchaseItems => HashSet::from_iter(PURCHASE_ITEMS_FIELDS),
            &Models::Suppliers => HashSet::from_iter(SUPPLIERS_FIELDS),
            &Models::Stores => HashSet::from_iter(STORES_FIELDS),
            &Models::Manufacturers => HashSet::from_iter(MANUFACTURERS_FIELDS),
            &Models::Brands => HashSet::from_iter(BRANDS_FIELDS),
            &Models::Unknown(_) => HashSet::new(),
        })
    }
}

impl SelectableFields for Models {
    fn get_fields_from_query_string(query_fields: Option<String>) -> HashSet<String> {
        if query_fields.is_none() {
            return HashSet::new();
        }

        query_fields
            .unwrap()
            .split(",")
            .map(str::trim)
            .map(|e| e.to_string())
            .collect::<HashSet<String>>()
    }
}
