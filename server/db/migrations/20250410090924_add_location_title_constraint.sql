-- migrate:up
ALTER TABLE IF EXISTS locations
ADD CONSTRAINT title_min_length CHECK (char_length(title) >= 1);

ALTER TABLE IF EXISTS companies
ADD CONSTRAINT title_min_length CHECK (char_length(title) >= 1);

ALTER TABLE IF EXISTS products
ADD CONSTRAINT title_min_length CHECK (char_length(title) >= 1);

-- migrate:down
ALTER TABLE IF EXISTS locations
DROP CONSTRAINT title_min_length;

ALTER TABLE IF EXISTS companies
DROP CONSTRAINT title_min_length;

ALTER TABLE IF EXISTS products
DROP CONSTRAINT title_min_length;