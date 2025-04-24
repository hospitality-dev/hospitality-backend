use serde::Deserialize;

#[derive(Deserialize, Debug, strum_macros::Display)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]
pub enum WeightUnits {
    Kg,
    G,
    Mg,
    Oz,
    Lb,
}

#[derive(Deserialize, Debug, strum_macros::Display)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]

pub enum VolumeUnits {
    L,
    Ml,
    FlOz,
    Gal,
}
