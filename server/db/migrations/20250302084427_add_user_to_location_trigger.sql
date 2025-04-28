-- migrate:up
CREATE
OR REPLACE FUNCTION insert_location_user () RETURNS TRIGGER AS $$
DECLARE
    owner_role_id UUID;
BEGIN
    SELECT id INTO owner_role_id
    FROM roles
    WHERE title = 'owner' AND company_id IS NULL
    LIMIT 1;

    INSERT INTO locations_users (user_id, location_id, role_id) VALUES (NEW.owner_id, NEW.id, owner_role_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_location_user
AFTER INSERT ON locations FOR EACH ROW
EXECUTE FUNCTION insert_location_user ();

-- migrate:down
DROP TRIGGER IF EXISTS trigger_insert_location_user ON locations;

DROP FUNCTION IF EXISTS insert_location_user ();