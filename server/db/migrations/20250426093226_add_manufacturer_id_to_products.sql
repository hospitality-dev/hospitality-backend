-- migrate:up
ALTER TABLE IF EXISTS products
ADD COLUMN manufacturer_id UUID REFERENCES manufacturers (id) ON DELETE SET NULL;

-- migrate:down
ALTER TABLE IF EXISTS products
DROP COLUMN manufacturer_id;