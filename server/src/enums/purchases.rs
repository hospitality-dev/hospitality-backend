use serde::{Deserialize, Serialize};

use crate::{models::response::AppErrorResponse, traits::enum_traits::PurchaseEnumsOrder};

use super::errors::AppError;

#[derive(Serialize, Deserialize)]
pub enum PurchasePaymentType {
    OtherNonCashPayment,
    Cash,
    Card,
    Check,
    Transfer,
    Vaucher,
    InstantPayment,
}
#[derive(Serialize, Deserialize)]
pub enum PurchaseTransactionType {
    Purchase,
    Refund,
}
#[derive(Serialize, Deserialize)]
pub enum PurchaseInvoiceType {
    Transaction,
    ProformaInvoice,
    Copy,
    Training,
    AdvancePayment,
}

impl PurchaseEnumsOrder<Self> for PurchasePaymentType {
    fn from_index(index: i16) -> Result<Self, AppErrorResponse> {
        match index {
            0 => Ok(Self::OtherNonCashPayment),
            1 => Ok(Self::Cash),
            2 => Ok(Self::Card),
            3 => Ok(Self::Check),
            4 => Ok(Self::Transfer),
            5 => Ok(Self::Vaucher),
            6 => Ok(Self::InstantPayment),
            _ => Err(AppError::default_response(
                "Unknown index for purchase payment type.",
            )),
        }
    }

    fn to_index(self) -> i16 {
        match self {
            Self::OtherNonCashPayment => 0,
            Self::Cash => 1,
            Self::Card => 2,
            Self::Check => 3,
            Self::Transfer => 4,
            Self::Vaucher => 5,
            Self::InstantPayment => 6,
        }
    }
}

impl PurchaseEnumsOrder<Self> for PurchaseTransactionType {
    fn from_index(index: i16) -> Result<Self, AppErrorResponse> {
        match index {
            0 => Ok(Self::Purchase),
            1 => Ok(Self::Refund),
            _ => Err(AppError::default_response(
                "Unknown index for transaction type.",
            )),
        }
    }

    fn to_index(self) -> i16 {
        match self {
            Self::Purchase => 0,
            Self::Refund => 1,
        }
    }
}

impl PurchaseEnumsOrder<Self> for PurchaseInvoiceType {
    fn from_index(index: i16) -> Result<Self, AppErrorResponse> {
        match index {
            0 => Ok(Self::Transaction),
            1 => Ok(Self::ProformaInvoice),
            2 => Ok(Self::Copy),
            3 => Ok(Self::Training),
            4 => Ok(Self::AdvancePayment),
            _ => Err(AppError::default_response(
                "Unknown index for transaction type.",
            )),
        }
    }

    fn to_index(self) -> i16 {
        match self {
            Self::Transaction => 0,
            Self::ProformaInvoice => 1,
            Self::Copy => 2,
            Self::Training => 3,
            Self::AdvancePayment => 4,
        }
    }
}
