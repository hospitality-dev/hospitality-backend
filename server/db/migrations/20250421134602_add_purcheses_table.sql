-- migrate:up
CREATE TABLE IF NOT EXISTS
    purchases (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        purchased_at TIMESTAMP WITH TIME ZONE,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
        location_id UUID REFERENCES locations (id) ON DELETE CASCADE,
        owner_id UUID REFERENCES users (id) ON DELETE SET NULL,
        total NUMERIC(10, 5) NOT NULL DEFAULT 0,
        payment_type INT2 NOT NULL,
        address TEXT,
        business_title TEXT NOT NULL,
        business_location_title TEXT,
        tax_id TEXT,
        transaction_type INT2,
        invoice_type INT2,
        invoice_counter_extension TEXT,
        invoice_number TEXT,
        CHECK (payment_type BETWEEN 0 AND 6),
        CHECK (transaction_type BETWEEN 0 AND 1),
        CHECK (invoice_type BETWEEN 0 AND 4)
    );

CREATE TABLE IF NOT EXISTS
    purchase_items (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
        location_id UUID REFERENCES locations (id) ON DELETE CASCADE,
        parent_id UUID NOT NULL REFERENCES purchases (id) ON DELETE CASCADE,
        product_id UUID REFERENCES products (id) ON DELETE SET NULL,
        owner_id UUID REFERENCES users (id) ON DELETE SET NULL
    );

-- migrate:down
DROP TABLE IF EXISTS purchase_items;

DROP TABLE IF EXISTS purchases;