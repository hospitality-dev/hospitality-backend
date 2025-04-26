-- migrate:up
ALTER TABLE IF EXISTS products
ADD COLUMN width FLOAT4;

ALTER TABLE IF EXISTS products
ADD COLUMN width_unit TEXT;

ALTER TABLE IF EXISTS products
ADD CONSTRAINT width_unit_constraint CHECK (
    width_unit IN ('mm', 'cm', 'dm', 'm', 'inch', 'ft')
);

ALTER TABLE IF EXISTS products
ADD CONSTRAINT width_and_unit_presence CHECK (
    (
        width IS NOT NULL
        AND width_unit IS NOT NULL
    )
    OR (
        width IS NULL
        AND width_unit IS NULL
    )
    OR (
        width IS NULL
        AND width_unit IS NOT NULL
    )
);

ALTER TABLE IF EXISTS products
ADD COLUMN height FLOAT4;

ALTER TABLE IF EXISTS products
ADD COLUMN height_unit TEXT;

ALTER TABLE IF EXISTS products
ADD CONSTRAINT height_unit_constraint CHECK (
    height_unit IN ('mm', 'cm', 'dm', 'm', 'inch', 'ft')
);

ALTER TABLE IF EXISTS products
ADD CONSTRAINT height_and_unit_presence CHECK (
    (
        height IS NOT NULL
        AND height_unit IS NOT NULL
    )
    OR (
        height IS NULL
        AND height_unit IS NULL
    )
    OR (
        height IS NULL
        AND height_unit IS NOT NULL
    )
);

-- migrate:down
ALTER TABLE IF EXISTS products
DROP CONSTRAINT width_unit_constraint;

ALTER TABLE IF EXISTS products
DROP CONSTRAINT height_unit_constraint;

ALTER TABLE IF EXISTS products
DROP COLUMN width_unit;

ALTER TABLE IF EXISTS products
DROP COLUMN height_unit;

ALTER TABLE IF EXISTS products
DROP COLUMN width;

ALTER TABLE IF EXISTS products
DROP COLUMN height;