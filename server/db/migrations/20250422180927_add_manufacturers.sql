-- migrate:up
CREATE TABLE IF NOT EXISTS
    manufacturers (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        owner_id UUID REFERENCES users (id) ON DELETE CASCADE
    );

-- migrate:down
DROP TABLE IF EXISTS manufacturers;