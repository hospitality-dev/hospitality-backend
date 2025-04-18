use serde::{Deserialize, Serialize};
use tokio_postgres::types::FromSql;

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Hash, Clone)]
#[serde(rename_all = "lowercase")]
pub enum FileTypes {
    Png,
    Jpg,
    Jpeg,
    Webp,
    Gif,
    Svg,
    Pdf,
    Doc,
    Docx,
    Txt,
    Xls,
    Xlsx,
    Mp3,
    Wav,
    Ogg,
    Mp4,
    Mov,
    Avi,
    Webm,
    Zip,
    Rar,
    Json,
    Csv,
    #[serde(other)]
    Unknown,
}

impl std::fmt::Display for FileTypes {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            &FileTypes::Png => f.write_str("png"),
            &FileTypes::Jpg => f.write_str("jpg"),
            &FileTypes::Jpeg => f.write_str("jpeg"),
            &FileTypes::Webp => f.write_str("webp"),
            &FileTypes::Gif => f.write_str("gif"),
            &FileTypes::Svg => f.write_str("svg"),
            &FileTypes::Pdf => f.write_str("pdf"),
            &FileTypes::Doc => f.write_str("doc"),
            &FileTypes::Docx => f.write_str("docx"),
            &FileTypes::Txt => f.write_str("txt"),
            &FileTypes::Xls => f.write_str("xls"),
            &FileTypes::Xlsx => f.write_str("xlsx"),
            &FileTypes::Mp3 => f.write_str("mp3"),
            &FileTypes::Wav => f.write_str("wav"),
            &FileTypes::Ogg => f.write_str("ogg"),
            &FileTypes::Mp4 => f.write_str("mp4"),
            &FileTypes::Mov => f.write_str("mov"),
            &FileTypes::Avi => f.write_str("avi"),
            &FileTypes::Webm => f.write_str("webm"),
            &FileTypes::Zip => f.write_str("zip"),
            &FileTypes::Rar => f.write_str("rar"),
            &FileTypes::Json => f.write_str("json"),
            &FileTypes::Csv => f.write_str("csv"),
            &FileTypes::Unknown => f.write_str("unknown"),
        }
    }
}

impl From<String> for FileTypes {
    fn from(s: String) -> Self {
        match s.to_lowercase().as_str() {
            "png" | "image/png" => FileTypes::Png,
            "jpg" | "image/jpg" => FileTypes::Jpg,
            "jpeg" | "image/jpeg" => FileTypes::Jpeg,
            "webp" | "image/webp" => FileTypes::Webp,
            "gif" | "image/gif" => FileTypes::Gif,
            "svg" | "image/svg+xml" => FileTypes::Svg,
            "pdf" | "application/pdf" => FileTypes::Pdf,
            "doc" | "application/msword" => FileTypes::Doc,
            "docx" | "application/vnd.openxmlformats-officedocument.wordprocessingml.document" => {
                FileTypes::Docx
            }
            "txt" | "text/plain" => FileTypes::Txt,
            "xls" | "application/vnd.ms-excel" => FileTypes::Xls,
            "xlsx" | "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" => {
                FileTypes::Xlsx
            }
            "mp3" | "audio/mpeg" => FileTypes::Mp3,
            "wav" | "audio/wav" => FileTypes::Wav,
            "ogg" | "audio/ogg" => FileTypes::Ogg,
            "mp4" | "video/mp4" => FileTypes::Mp4,
            "mov" | "video/quicktime" => FileTypes::Mov,
            "avi" | "video/x-msvideo" => FileTypes::Avi,
            "webm" | "video/webm" => FileTypes::Webm,
            "zip" | "application/zip" => FileTypes::Zip,
            "rar" | "application/vnd.rar" => FileTypes::Rar,
            "json" | "application/json" => FileTypes::Json,
            "csv" | "text/csv" => FileTypes::Csv,
            _ => FileTypes::Unknown,
        }
    }
}

impl FileTypes {
    pub fn content_type(&self) -> &'static str {
        match self {
            FileTypes::Png => "image/png",
            FileTypes::Jpg | FileTypes::Jpeg => "image/jpeg",
            FileTypes::Webp => "image/webp",
            FileTypes::Gif => "image/gif",
            FileTypes::Svg => "image/svg+xml",
            FileTypes::Pdf => "application/pdf",
            FileTypes::Doc => "application/msword",
            FileTypes::Docx => {
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            }
            FileTypes::Txt => "text/plain",
            FileTypes::Xls => "application/vnd.ms-excel",
            FileTypes::Xlsx => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            FileTypes::Mp3 => "audio/mpeg",
            FileTypes::Wav => "audio/wav",
            FileTypes::Ogg => "audio/ogg",
            FileTypes::Mp4 => "video/mp4",
            FileTypes::Mov => "video/quicktime",
            FileTypes::Avi => "video/x-msvideo",
            FileTypes::Webm => "video/webm",
            FileTypes::Zip => "application/zip",
            FileTypes::Rar => "application/vnd.rar",
            FileTypes::Json => "application/json",
            FileTypes::Csv => "text/csv",
            FileTypes::Unknown => "application/octet-stream",
        }
    }
}

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Hash, Clone)]
#[serde(rename_all = "snake_case")]
pub enum FileCategories {
    Reports,
    QrCodes,
    Images,
    #[serde(other)]
    Unknown,
}

impl std::fmt::Display for FileCategories {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            &FileCategories::Reports => f.write_str("reports"),
            &FileCategories::QrCodes => f.write_str("qr_codes"),
            &FileCategories::Images => f.write_str("images"),
            &FileCategories::Unknown => f.write_str("unknown"),
        }
    }
}

impl From<String> for FileCategories {
    fn from(s: String) -> Self {
        match s.to_lowercase().as_str() {
            "reports" => FileCategories::Reports,
            "qr_codes" => FileCategories::QrCodes,
            "images" => FileCategories::Images,
            _ => FileCategories::Unknown,
        }
    }
}

impl FromSql<'_> for FileCategories {
    fn accepts(ty: &tokio_postgres::types::Type) -> bool {
        match ty {
            &tokio_postgres::types::Type::TEXT => true,
            _ => false,
        }
    }

    fn from_sql(
        _: &tokio_postgres::types::Type,
        raw: &'_ [u8],
    ) -> Result<Self, Box<dyn std::error::Error + Sync + Send>> {
        match std::str::from_utf8(raw)? {
            "reports" => Ok(FileCategories::Reports),
            "qr_codes" => Ok(FileCategories::QrCodes),
            "images" => Ok(FileCategories::Images),
            other => Err(format!("unknown enum variant: {}", other).into()),
        }
    }
}

impl<'a> FromSql<'a> for FileTypes {
    fn from_sql(
        _ty: &tokio_postgres::types::Type,
        raw: &'a [u8],
    ) -> Result<Self, Box<dyn std::error::Error + Sync + Send>> {
        match std::str::from_utf8(raw)?.to_lowercase().as_str() {
            "png" => Ok(FileTypes::Png),
            "jpg" => Ok(FileTypes::Jpg),
            "jpeg" => Ok(FileTypes::Jpeg),
            "webp" => Ok(FileTypes::Webp),
            "gif" => Ok(FileTypes::Gif),
            "svg" => Ok(FileTypes::Svg),
            "pdf" => Ok(FileTypes::Pdf),
            "doc" => Ok(FileTypes::Doc),
            "docx" => Ok(FileTypes::Docx),
            "txt" => Ok(FileTypes::Txt),
            "xls" => Ok(FileTypes::Xls),
            "xlsx" => Ok(FileTypes::Xlsx),
            "mp3" => Ok(FileTypes::Mp3),
            "wav" => Ok(FileTypes::Wav),
            "ogg" => Ok(FileTypes::Ogg),
            "mp4" => Ok(FileTypes::Mp4),
            "mov" => Ok(FileTypes::Mov),
            "avi" => Ok(FileTypes::Avi),
            "webm" => Ok(FileTypes::Webm),
            "zip" => Ok(FileTypes::Zip),
            "rar" => Ok(FileTypes::Rar),
            "json" => Ok(FileTypes::Json),
            "csv" => Ok(FileTypes::Csv),
            _ => Err(format!("unknown enum variant: FROM SQL FILETYPES").into()),
        }
    }

    fn accepts(ty: &tokio_postgres::types::Type) -> bool {
        ty == &tokio_postgres::types::Type::TEXT
    }
}
