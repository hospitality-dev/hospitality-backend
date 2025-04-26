use tracing::error;

#[derive(Debug)]
pub enum AppError {
    GeneratingError,
}

impl AppError {
    #[track_caller]
    pub fn generate_response(err: impl ToString) -> impl ToString {
        let location = std::panic::Location::caller();
        error!(
            message = err.to_string(),
            kind = "FILE GENERATION ERROR",
            call_path = format!("{} -> {}", location.file(), location.line())
        );

        return err;
    }
}
