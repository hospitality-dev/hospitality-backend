-- migrate:up
CREATE TABLE IF NOT EXISTS
    brands (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        manufacturer_id UUID NOT NULL REFERENCES manufacturers (id) ON DELETE CASCADE,
        is_default BOOLEAN NOT NULL DEFAULT FALSE,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE
    );

ALTER TABLE IF EXISTS products
ADD COLUMN brand_id UUID REFERENCES brands (id) ON DELETE SET NULL;

-- migrate:down
ALTER TABLE IF EXISTS products
DROP COLUMN brand_id;

DROP TABLE IF EXISTS brands;