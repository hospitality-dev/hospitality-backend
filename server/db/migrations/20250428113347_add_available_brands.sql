-- migrate:up
CREATE TABLE IF NOT EXISTS
    locations_available_brands (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        brand_id UUID NOT NULL REFERENCES brands (id) ON DELETE CASCADE,
        UNIQUE (location_id, brand_id)
    );

-- migrate:down
DROP TABLE IF EXISTS locations_available_brands;