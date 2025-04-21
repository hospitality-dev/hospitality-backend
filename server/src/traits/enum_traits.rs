use crate::models::response::AppErrorResponse;

pub trait PurchaseEnumsOrder<T> {
    fn from_index(index: i16) -> Result<T, AppErrorResponse>;
    fn to_index(self) -> i16;
}
