-- migrate:up
ALTER TABLE IF EXISTS products
ADD COLUMN shape TEXT;

ALTER TABLE IF EXISTS products
ADD CONSTRAINT products_shape_check CHECK (
    shape IN (
        'can',
        'cardboard_box',
        'cardboard_bottle',
        'metal_box',
        'plastic_box',
        'crate',
        'plastic_bottle',
        'glass_bottle',
        'vacuum_packaging',
        'barrel',
        'plastic_cup',
        'plastic_bag',
        'jar',
        'tube',
        'pouch',
        'sack'
    )
);

-- migrate:down
ALTER TABLE IF EXISTS products
DROP CONSTRAINT products_shape_check;

ALTER TABLE IF EXISTS products
DROP COLUMN shape;