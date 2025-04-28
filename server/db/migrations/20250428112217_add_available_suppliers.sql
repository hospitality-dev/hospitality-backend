-- migrate:up
CREATE TABLE IF NOT EXISTS
    locations_available_suppliers (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        suppplier_id UUID NOT NULL REFERENCES suppliers (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS locations_available_suppliers;