-- migrate:up
ALTER TABLE IF EXISTS manufacturers
ADD COLUMN is_default BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE IF EXISTS manufacturers
ADD COLUMN company_id UUID REFERENCES companies (id) ON DELETE CASCADE;

-- migrate:down
ALTER TABLE IF EXISTS manufacturers
DROP COLUMN is_default;