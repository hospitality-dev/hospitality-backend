use core::fmt;

use regex::Regex;
use rust_decimal::Decimal;
use serde::{
    de::{self, Visitor},
    Deserialize, Deserializer,
};

pub fn coordinate_from_string<'de, D>(deserializer: D) -> Result<Decimal, D::Error>
where
    D: Deserializer<'de>,
{
    struct StringAsNumberVisitor;

    impl<'de> Visitor<'de> for StringAsNumberVisitor {
        type Value = Decimal;

        fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
            formatter.write_str("a string representing a number")
        }

        fn visit_str<E>(self, value: &str) -> Result<Self::Value, E>
        where
            E: de::Error,
        {
            value.parse::<Decimal>().map_err(de::Error::custom)
        }
    }

    deserializer.deserialize_str(StringAsNumberVisitor)
}

pub fn deserialize_time_format<'de, D>(deserializer: D) -> Result<String, D::Error>
where
    D: Deserializer<'de>,
{
    let time: String = Deserialize::deserialize(deserializer)?;

    let re = Regex::new(r"^\d{2}:\d{2}$").unwrap();
    if re.is_match(&time) {
        Ok(time)
    } else {
        Err(serde::de::Error::custom(
            "Invalid time format, must be HH:MM",
        ))
    }
}

pub fn deserialize_time_format_range<'de, D>(deserializer: D) -> Result<(String, String), D::Error>
where
    D: Deserializer<'de>,
{
    let time: (String, String) = Deserialize::deserialize(deserializer)?;

    let re = Regex::new(r"^\d{2}:\d{2}$").unwrap();
    if re.is_match(&time.0) && re.is_match(&time.1) {
        Ok(time)
    } else {
        Err(serde::de::Error::custom(
            "Invalid time format, must be HH:MM",
        ))
    }
}
