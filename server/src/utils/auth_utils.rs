use base64::{prelude::BASE64_URL_SAFE_NO_PAD, Engine};
use sha2::{Digest, Sha256};

pub fn generate_code_verifier() -> String {
    let random_bytes: Vec<u8> = (0..64).map(|_| rand::random::<u8>()).collect();
    BASE64_URL_SAFE_NO_PAD
        .encode(&random_bytes)
        .chars()
        .take(128)
        .collect()
}

pub fn generate_code_challenge(verifier: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(verifier.as_bytes());
    let result = hasher.finalize();

    BASE64_URL_SAFE_NO_PAD.encode(&result)
}
