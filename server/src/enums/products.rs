use serde::Deserialize;

#[derive(Deserialize, Default, Debug, strum_macros::Display)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]
pub enum WeightUnits {
    #[default]
    Kg,
    G,
    Mg,
    Oz,
    Lb,
}

#[derive(Deserialize, Default, Debug, strum_macros::Display)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]

pub enum VolumeUnits {
    #[default]
    L,
    Ml,
    FlOz,
    Gal,
}
