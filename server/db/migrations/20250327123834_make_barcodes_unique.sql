-- migrate:up
ALTER TABLE products
ADD CONSTRAINT products_barcode_unique UNIQUE (barcode);

-- migrate:down
ALTER TABLE products
DROP CONSTRAINT products_barcode_unique;