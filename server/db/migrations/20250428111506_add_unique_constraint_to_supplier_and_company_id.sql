-- migrate:up
ALTER TABLE IF EXISTS suppliers
ADD CONSTRAINT unique_title_company_id_constraint UNIQUE (title);

-- migrate:down
ALTER TABLE IF EXISTS suppliers
DROP CONSTRAINT unique_title_company_id_constraint;