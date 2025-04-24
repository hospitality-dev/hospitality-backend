-- migrate:up
ALTER TABLE IF EXISTS products
ADD COLUMN packing_date TIMESTAMP WITH TIME ZONE;

-- migrate:down
ALTER TABLE IF EXISTS products
DROP COLUMN packing_date;