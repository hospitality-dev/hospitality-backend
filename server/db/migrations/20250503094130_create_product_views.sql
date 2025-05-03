-- migrate:up
CREATE
OR REPLACE FUNCTION get_available_products (loc_id UUID) RETURNS TABLE (
  id UUID,
  product_id UUID,
  location_id UUID
  -- include other product fields as needed
) AS $$
BEGIN
    RETURN QUERY
    SELECT locations_available_products.id,  locations_available_products.product_id, locations_available_products.location_id
    FROM
    locations_available_products
    INNER JOIN products ON products.id = locations_available_products.product_id
    LEFT JOIN locations_available_brands
      ON products.brand_id = locations_available_brands.brand_id
    LEFT JOIN locations_available_manufacturers
      ON products.manufacturer_id = locations_available_manufacturers.manufacturer_id
    WHERE locations_available_products.location_id = loc_id
      AND (products.brand_id IS NULL OR locations_available_brands.location_id = loc_id)
      AND (products.manufacturer_id IS NULL OR locations_available_manufacturers.location_id = loc_id);
END;
$$ LANGUAGE plpgsql;

-- migrate:down
DROP FUNCTION get_available_products (UUID);