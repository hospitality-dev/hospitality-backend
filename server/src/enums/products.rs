use serde::{Deserialize, Serialize};

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

#[derive(Deserialize, Debug, strum_macros::Display, Default, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]

pub enum UnitsOfMeasurement {
    Kom,
    Kut,
    Kg,
    G,
    Mg,
    L,
    Ml,
    Dl,
    Cl,
    Cm3,
    Dm3,
    FlOz,
    Oz,
    Lb,
    #[default]
    #[serde(other)]
    Unknown,
}

#[derive(Debug, Default, Deserialize, Serialize, strum_macros::Display)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "snake_case")]
pub enum ProductShape {
    Can,
    CardboardBox,
    MetalBox,
    PlasticBox,
    Crate,
    PlasticBottle,
    GlassBottle,
    VacuumPackaging,
    Barrel,
    PlasticCup,
    PlasticBag,
    Jar,
    Tube,
    Pouch,
    Sack,
    #[default]
    #[serde(other)]
    Unknown,
}
