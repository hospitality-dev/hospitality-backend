-- migrate:up
ALTER TABLE users_contacts
ADD COLUMN iso_3 TEXT;

ALTER TABLE companies_contacts
ADD COLUMN iso_3 TEXT;

ALTER TABLE locations_contacts
ADD COLUMN iso_3 TEXT;

-- migrate:down
ALTER TABLE users_contacts
DROP COLUMN iso_3;

ALTER TABLE companies_contacts
DROP COLUMN iso_3;

ALTER TABLE locations_contacts
DROP COLUMN iso_3;