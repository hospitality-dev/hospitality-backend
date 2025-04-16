use serde::Serialize;

#[derive(Serialize, Clone, Copy)]
pub enum ResponseMessages {
    Success,
}

impl std::fmt::Display for ResponseMessages {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match *self {
            ResponseMessages::Success => write!(f, "Success."),
        }
    }
}
