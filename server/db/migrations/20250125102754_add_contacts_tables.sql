-- migrate:up
CREATE TABLE IF NOT EXISTS
    users_contacts (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT,
        contact_type TEXT NOT NULL,
        prefix TEXT,
        value TEXT NOT NULL,
        parent_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        place_id INT,
        bounding_box FLOAT8[],
        is_public BOOLEAN DEFAULT FALSE,
        CHECK (
            contact_type IN (
                'work_email',
                'personal_email',
                'support_email',
                'billing_email',
                'work_phone',
                'personal_phone',
                'mobile_phone',
                'fax',
                'home_phone',
                'whatsapp',
                'slack',
                'work_address',
                'home_address',
                'billing_address',
                'shipping_address',
                'website',
                'linkedin',
                'twitter',
                'facebook',
                'instagram',
                'sales_email',
                'marketing_email',
                'hr_email',
                'contact_email',
                'sales_phone',
                'support_phone',
                'customer_service_phone',
                'general_inquiry_phone',
                'office_address',
                'headquarters_address',
                'warehouse_address',
                'company_website',
                'support_website'
            )
        )
    );

CREATE TABLE IF NOT EXISTS
    companies_contacts (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT,
        contact_type TEXT NOT NULL,
        prefix TEXT,
        value TEXT NOT NULL,
        parent_id UUID NOT NULL REFERENCES companies (id) ON DELETE CASCADE,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        place_id INT,
        bounding_box FLOAT8[],
        is_public BOOLEAN DEFAULT FALSE,
        CHECK (
            contact_type IN (
                'work_email',
                'personal_email',
                'support_email',
                'billing_email',
                'work_phone',
                'personal_phone',
                'mobile_phone',
                'fax',
                'home_phone',
                'whatsapp',
                'slack',
                'work_address',
                'home_address',
                'billing_address',
                'shipping_address',
                'website',
                'linkedin',
                'twitter',
                'facebook',
                'instagram',
                'sales_email',
                'marketing_email',
                'hr_email',
                'contact_email',
                'sales_phone',
                'support_phone',
                'customer_service_phone',
                'general_inquiry_phone',
                'office_address',
                'headquarters_address',
                'warehouse_address',
                'company_website',
                'support_website'
            )
        )
    );

CREATE TABLE IF NOT EXISTS
    locations_contacts (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT,
        contact_type TEXT NOT NULL,
        prefix TEXT,
        value TEXT NOT NULL,
        parent_id UUID NOT NULL REFERENCES locations (id) ON DELETE CASCADE,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        place_id INT,
        bounding_box FLOAT8[],
        is_public BOOLEAN DEFAULT FALSE,
        CHECK (
            contact_type IN (
                'work_email',
                'personal_email',
                'support_email',
                'billing_email',
                'work_phone',
                'personal_phone',
                'mobile_phone',
                'fax',
                'home_phone',
                'whatsapp',
                'slack',
                'work_address',
                'home_address',
                'billing_address',
                'shipping_address',
                'website',
                'linkedin',
                'twitter',
                'facebook',
                'instagram',
                'sales_email',
                'marketing_email',
                'hr_email',
                'contact_email',
                'sales_phone',
                'support_phone',
                'customer_service_phone',
                'general_inquiry_phone',
                'office_address',
                'headquarters_address',
                'warehouse_address',
                'company_website',
                'support_website'
            )
        )
    );

-- migrate:down
DROP TABLE IF EXISTS users_contacts;

DROP TABLE IF EXISTS companies_contacts;

DROP TABLE IF EXISTS locations_contacts;