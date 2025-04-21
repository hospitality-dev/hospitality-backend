use postgres_types::FromSql;
use serde::Deserialize;
use tokio_postgres::types::ToSql;

#[derive(Deserialize, Debug, FromSql, ToSql)]
#[serde(rename_all = "lowercase")]
#[postgres(name = "text")]
pub enum WeightUnits {
    #[postgres(name = "kg")]
    Kg,
    #[postgres(name = "g")]
    G,
    #[postgres(name = "mg")]
    Mg,
    #[postgres(name = "oz")]
    Oz,
    #[postgres(name = "lb")]
    Lb,
}

#[derive(Deserialize, FromSql, ToSql, Debug)]
#[serde(rename_all = "lowercase")]
#[postgres(name = "text")]
pub enum VolumeUnits {
    #[postgres(name = "l")]
    L,
    #[postgres(name = "ml")]
    Ml,
    #[postgres(name = "fl oz")]
    FlOz,
    #[postgres(name = "gal")]
    Gal,
}
