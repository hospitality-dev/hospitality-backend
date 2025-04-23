-- migrate:up
CREATE TABLE IF NOT EXISTS
    product_aliases (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        product_id UUID NOT NULL REFERENCES products (id) ON DELETE CASCADE,
        alias TEXT NOT NULL,
        store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
        supplier_id UUID NOT NULL REFERENCES suppliers (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS product_aliases;