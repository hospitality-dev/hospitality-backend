use maplit::hashset;
use once_cell::sync::Lazy;
use std::collections::{HashMap, HashSet};

pub static PRODUCTS_RELATIONS: Lazy<HashMap<&'static str, HashSet<&'static str>>> =
    Lazy::new(|| {
        let mut m = HashMap::new();

        m.insert("manufacturers", hashset!["id", "title"]);
        m.insert("brands", hashset!["id", "title"]);
        return m;
    });
