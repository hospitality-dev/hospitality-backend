-- migrate:up
CREATE TABLE IF NOT EXISTS
    product_aliases (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT NOT NULL,
        supplier_id UUID NOT NULL REFERENCES suppliers (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS product_aliases;