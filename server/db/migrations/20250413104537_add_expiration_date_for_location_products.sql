-- migrate:up
ALTER TABLE locations_products
ADD COLUMN expiration_date TIMESTAMP WITH TIME ZONE;

-- migrate:down
ALTER TABLE locations_products
DROP COLUMN;