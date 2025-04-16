-- migrate:up
ALTER TABLE IF EXISTS locations
ADD COLUMN image_id UUID REFERENCES files (id) ON DELETE SET NULL;

-- migrate:down
ALTER TABLE IF EXISTS locations
DROP COLUMN image_id;