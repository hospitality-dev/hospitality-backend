-- migrate:up
CREATE TABLE IF NOT EXISTS
    users (
        id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid (),
        created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        deleted_at timestamp with time zone,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE CHECK (char_length(username) >= 6),
        pw_hsh TEXT NOT NULL,
        date_of_birth DATE,
        date_of_employment DATE,
        date_of_termination DATE,
        is_verified BOOLEAN NOT NULL DEFAULT FALSE
    );

-- migrate:down
DROP TABLE IF EXISTS users;