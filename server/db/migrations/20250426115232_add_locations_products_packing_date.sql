-- migrate:up
ALTER TABLE IF EXISTS locations_products
ADD COLUMN packing_date TIMESTAMP WITH TIME ZONE;

-- migrate:down
ALTER TABLE IF EXISTS locations_products
DROP COLUMN packing_date;