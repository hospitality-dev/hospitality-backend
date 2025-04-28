-- migrate:up
CREATE TABLE IF NOT EXISTS
    locations_available_manufacturers (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        manufacturer_id UUID NOT NULL REFERENCES manufacturers (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS locations_available_manufacturers;