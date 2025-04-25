-- migrate:up
ALTER TABLE IF EXISTS locations_products
ADD COLUMN purchase_item_id UUID REFERENCES purchase_items (id) ON DELETE SET NULL;

-- migrate:down
ALTER TABLE IF EXISTS locations_products
DROP COLUMN purchase_item_id;