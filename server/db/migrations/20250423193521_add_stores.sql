-- migrate:up
CREATE TABLE IF NOT EXISTS
    suppliers (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        owner_id UUID REFERENCES users (id) ON DELETE CASCADE,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS
    stores (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        deleted_at TIMESTAMP WITH TIME ZONE,
        title TEXT NOT NULL,
        parent_id UUID NOT NULL REFERENCES suppliers (id) ON DELETE CASCADE,
        owner_id UUID REFERENCES users (id) ON DELETE CASCADE,
        company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
        UNIQUE (parent_id, title)
    );

-- INSERT INTO
--     suppliers (id, title)
-- VALUES
--     (
--         '70e652b0-3658-4753-b657-c2d35269f77f',
--         'DELHAIZE SERBIA DOO'
--     ),
--     (
--         '728d6f74-b83d-4ee2-a15d-70c31c64ad36',
--         'LIDL SRBIJA KD'
--     );
-- migrate:down
DROP TABLE IF EXISTS stores;

DROP TABLE IF EXISTS suppliers;