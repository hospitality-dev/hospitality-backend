-- migrate:up
ALTER TABLE IF EXISTS users
ADD COLUMN company_id UUID REFERENCES companies (id) ON DELETE CASCADE;

-- migrate:down
ALTER TABLE IF EXISTS users
DROP COLUMN company_id;