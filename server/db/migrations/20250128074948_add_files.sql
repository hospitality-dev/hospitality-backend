-- migrate:up
CREATE TABLE IF NOT EXISTS
  files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    owner_id UUID NOT NULL REFERENCES users (id),
    company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
    location_id UUID REFERENCES locations (id) ON DELETE CASCADE,
    type TEXT NOT NULL DEFAULT 'unknown',
    category TEXT NOT NULL DEFAULT 'unknown',
    CHECK (
      type IN (
        'png',
        'jpg',
        'jpeg',
        'webp',
        'gif',
        'svg',
        'pdf',
        'doc',
        'docx',
        'txt',
        'xls',
        'xlsx',
        'mp3',
        'wav',
        'ogg',
        'mp4',
        'mov',
        'avi',
        'webm',
        'zip',
        'rar',
        'json',
        'csv',
        'unknown'
      )
    ),
    CHECK (category IN ('reports', 'qr_codes', 'images'))
  );

-- migrate:down
DROP TABLE IF EXISTS files;