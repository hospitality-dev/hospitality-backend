-- migrate:up
CREATE TABLE IF NOT EXISTS
    locations_users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        deleted_at timestamp,
        location_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        user_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
        role_id UUID NOT NULL REFERENCES roles (id) ON DELETE NO ACTION,
        UNIQUE (location_id, user_id)
    );

-- migrate:down
DROP TABLE IF EXISTS locations_users;