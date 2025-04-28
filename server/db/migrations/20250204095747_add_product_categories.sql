-- migrate:up
CREATE TABLE IF NOT EXISTS
    products_categories (
        id UUID PRIMARY KEY default gen_random_uuid (),
        created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
        updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
        deleted_at TIMESTAMPTZ,
        title TEXT NOT NULL,
        parent_id UUID REFERENCES products_categories (id) ON DELETE CASCADE,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS products_categories;