-- migrate:up
CREATE TABLE IF NOT EXISTS
    companies (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        deleted_at timestamp,
        title TEXT NOT NULL,
        owner_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS companies;