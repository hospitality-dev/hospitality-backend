-- migrate:up
ALTER TABLE IF EXISTS manufacturers
ADD COLUMN company_id UUID REFERENCES companies (id) ON DELETE CASCADE;

-- migrate:down
ALTER TABLE IF EXISTS manufacturers
DROP COLUMN company_id;