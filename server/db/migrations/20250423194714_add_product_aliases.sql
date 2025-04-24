-- migrate:up
CREATE TABLE IF NOT EXISTS
    products_aliases (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT NOT NULL,
        supplier_id UUID NOT NULL REFERENCES suppliers (id) ON DELETE CASCADE,
        product_id UUID NOT NULL REFERENCES products (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS products_aliases;