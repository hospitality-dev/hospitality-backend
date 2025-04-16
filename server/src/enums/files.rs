use serde::{Deserialize, Serialize};

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
