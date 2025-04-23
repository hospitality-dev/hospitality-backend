use chrono::{DateTime, Utc};
use chrono_tz::Tz;

pub fn convert_to_tz(utc: DateTime<Utc>, tz: Tz) -> DateTime<Tz> {
    utc.with_timezone(&tz)
}

pub fn format_date_to_string(date: DateTime<Tz>, format: &str) -> String {
    date.format(format).to_string()
}
