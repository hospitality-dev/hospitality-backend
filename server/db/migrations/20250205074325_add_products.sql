-- migrate:up
CREATE TABLE IF NOT EXISTS
    products (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
        description TEXT,
        weight NUMERIC(10, 5),
        weight_unit TEXT,
        volume NUMERIC(10, 5),
        volume_unit TEXT,
        barcode CHAR(13),
        category_id UUID NOT NULL REFERENCES products_categories (id),
        subcategory_id UUID REFERENCES products_categories (id),
        image_id UUID REFERENCES files (id) ON DELETE CASCADE,
        CHECK (
            volume IS NULL
            OR volume_unit IS NOT NULL
        ),
        CHECK (
            weight IS NULL
            OR weight_unit IS NOT NULL
        ),
        CHECK (
            volume_unit IS NULL
            OR volume_unit IN ('l', 'ml', 'ft3', 'gal')
        ),
        CHECK (
            weight_unit IS NULL
            OR weight_unit IN ('kg', 'g', 'mg', 'lb', 'oz')
        )
    );

-- migrate:down
DROP TABLE IF EXISTS products;