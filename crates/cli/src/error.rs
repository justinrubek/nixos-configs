#[derive(thiserror::Error, Debug)]
pub enum Error {
    // #[error(transparent)]
    // Anyhow(#[from] anyhow::Error),
    #[error("Hello {0}")]
    Other(String),
}

pub type Result<T> = std::result::Result<T, Error>;
