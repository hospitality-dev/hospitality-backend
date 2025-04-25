-- migrate:up
CREATE TABLE IF NOT EXISTS
    locations_available_products (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        product_id UUID NOT NULL REFERENCES products (id) ON DELETE CASCADE,
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        UNIQUE (product_id, location_id)
    );

CREATE TABLE IF NOT EXISTS
    locations_products (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        deleted_at timestamp,
        product_id UUID REFERENCES products (id) ON DELETE SET NULL,
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        amount NUMERIC(10, 5) NOT NULL DEFAULT 0
    );

-- migrate:down
DROP TABLE IF EXISTS locations_products;

DROP TABLE IF EXISTS locations_available_products;