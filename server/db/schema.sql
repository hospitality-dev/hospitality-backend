SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: insert_location_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.insert_location_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    owner_role_id UUID;
BEGIN
    SELECT id INTO owner_role_id
    FROM roles
    WHERE title = 'owner' AND is_default = TRUE
    LIMIT 1;

    INSERT INTO locations_users (user_id, location_id, role_id) VALUES (NEW.owner_id, NEW.id, owner_role_id);

    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    parent_id uuid NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    company_id uuid
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    title text NOT NULL,
    owner_id uuid NOT NULL,
    CONSTRAINT title_min_length CHECK ((char_length(title) >= 1))
);


--
-- Name: companies_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT companies_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT companies_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    title text NOT NULL,
    iso_3 text,
    numeric_code text,
    iso_2 text,
    phonecode text,
    capital text,
    currency text,
    currency_title text,
    currency_symbol text,
    tld text,
    nationality text,
    timezones jsonb,
    latitude numeric(10,8),
    longitude numeric(11,8),
    wiki_data_id text,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    region_id uuid NOT NULL,
    subregion_id uuid NOT NULL
);


--
-- Name: files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    owner_id uuid NOT NULL,
    company_id uuid,
    location_id uuid,
    type text DEFAULT 'unknown'::text NOT NULL,
    category text DEFAULT 'unknown'::text NOT NULL,
    CONSTRAINT files_category_check CHECK ((category = ANY (ARRAY['reports'::text, 'receipts'::text, 'qr_codes'::text, 'images'::text]))),
    CONSTRAINT files_type_check CHECK ((type = ANY (ARRAY['png'::text, 'jpg'::text, 'jpeg'::text, 'webp'::text, 'gif'::text, 'svg'::text, 'pdf'::text, 'doc'::text, 'docx'::text, 'txt'::text, 'xls'::text, 'xlsx'::text, 'mp3'::text, 'wav'::text, 'ogg'::text, 'mp4'::text, 'mov'::text, 'avi'::text, 'webm'::text, 'zip'::text, 'rar'::text, 'json'::text, 'csv'::text, 'unknown'::text])))
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    owner_id uuid NOT NULL,
    company_id uuid NOT NULL,
    image_id uuid,
    CONSTRAINT title_min_length CHECK ((char_length(title) >= 1))
);


--
-- Name: locations_available_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations_available_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    location_id uuid NOT NULL
);


--
-- Name: locations_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT locations_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT locations_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: locations_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    product_id uuid,
    location_id uuid NOT NULL,
    amount numeric(10,5) DEFAULT 0 NOT NULL,
    expiration_date timestamp with time zone,
    purchase_item_id uuid,
    packing_date timestamp with time zone
);


--
-- Name: locations_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    location_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    company_id uuid
);


--
-- Name: manufacturers_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT manufacturers_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT manufacturers_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    company_id uuid,
    description text,
    weight numeric(10,5),
    weight_unit text,
    volume numeric(10,5),
    volume_unit text,
    barcode character(13),
    category_id uuid NOT NULL,
    subcategory_id uuid,
    image_id uuid,
    manufacturer_id uuid,
    brand_id uuid,
    shape text,
    width real,
    width_unit text,
    height real,
    height_unit text,
    CONSTRAINT height_and_unit_presence CHECK ((((height IS NOT NULL) AND (height_unit IS NOT NULL)) OR ((height IS NULL) AND (height_unit IS NULL)) OR ((height IS NULL) AND (height_unit IS NOT NULL)))),
    CONSTRAINT height_unit_constraint CHECK ((height_unit = ANY (ARRAY['mm'::text, 'cm'::text, 'dm'::text, 'm'::text, 'inch'::text, 'ft'::text]))),
    CONSTRAINT products_check CHECK (((volume IS NULL) OR (volume_unit IS NOT NULL))),
    CONSTRAINT products_check1 CHECK (((weight IS NULL) OR (weight_unit IS NOT NULL))),
    CONSTRAINT products_shape_check CHECK ((shape = ANY (ARRAY['can'::text, 'cardboard_box'::text, 'cardboard_bottle'::text, 'metal_box'::text, 'plastic_box'::text, 'crate'::text, 'plastic_bottle'::text, 'glass_bottle'::text, 'vacuum_packaging'::text, 'barrel'::text, 'plastic_cup'::text, 'plastic_bag'::text, 'jar'::text, 'tube'::text, 'pouch'::text, 'sack'::text]))),
    CONSTRAINT products_volume_unit_check CHECK (((volume_unit IS NULL) OR (volume_unit = ANY (ARRAY['l'::text, 'ml'::text, 'fl_oz'::text, 'gal'::text])))),
    CONSTRAINT products_weight_unit_check CHECK (((weight_unit IS NULL) OR (weight_unit = ANY (ARRAY['kg'::text, 'g'::text, 'mg'::text, 'lb'::text, 'oz'::text])))),
    CONSTRAINT title_min_length CHECK ((char_length(title) >= 1)),
    CONSTRAINT width_and_unit_presence CHECK ((((width IS NOT NULL) AND (width_unit IS NOT NULL)) OR ((width IS NULL) AND (width_unit IS NULL)) OR ((width IS NULL) AND (width_unit IS NOT NULL)))),
    CONSTRAINT width_unit_constraint CHECK ((width_unit = ANY (ARRAY['mm'::text, 'cm'::text, 'dm'::text, 'm'::text, 'inch'::text, 'ft'::text])))
);


--
-- Name: products_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_aliases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    supplier_id uuid NOT NULL,
    product_id uuid NOT NULL
);


--
-- Name: products_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    parent_id uuid,
    company_id uuid,
    is_default boolean NOT NULL
);


--
-- Name: purchase_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    company_id uuid,
    location_id uuid,
    parent_id uuid NOT NULL,
    product_id uuid,
    owner_id uuid,
    price_per_unit real DEFAULT 0 NOT NULL,
    quantity real DEFAULT 0 NOT NULL,
    unit_of_measurement text,
    CONSTRAINT purchase_items_unit_of_measurement_check CHECK ((unit_of_measurement = ANY (ARRAY['kom'::text, 'kut'::text, 'kg'::text, 'g'::text, 'mg'::text, 'l'::text, 'ml'::text, 'dl'::text, 'cl'::text, 'cm3'::text, 'dm3'::text, 'fl oz'::text, 'oz'::text, 'lb'::text, 'KOM'::text, 'KUT'::text, 'KG'::text, 'G'::text, 'MG'::text, 'L'::text, 'ML'::text, 'DL'::text, 'CL'::text, 'CM3'::text, 'DM3'::text, 'FL OZ'::text, 'OZ'::text, 'LB'::text, 'Unknown'::text])))
);


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    purchased_at timestamp with time zone,
    company_id uuid,
    location_id uuid,
    owner_id uuid,
    url text NOT NULL,
    total numeric(10,5) DEFAULT 0 NOT NULL,
    payment_type smallint NOT NULL,
    store_id uuid,
    tax_id text,
    transaction_type smallint,
    invoice_type smallint,
    invoice_counter_extension text,
    invoice_number text,
    currency_title text NOT NULL,
    CONSTRAINT purchases_invoice_type_check CHECK (((invoice_type >= 0) AND (invoice_type <= 4))),
    CONSTRAINT purchases_payment_type_check CHECK (((payment_type >= 0) AND (payment_type <= 6))),
    CONSTRAINT purchases_transaction_type_check CHECK (((transaction_type >= 0) AND (transaction_type <= 1)))
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    "wikiDataId" text
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    title text NOT NULL,
    company_id uuid,
    is_default boolean DEFAULT false NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stores (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    parent_id uuid NOT NULL,
    owner_id uuid,
    company_id uuid,
    is_default boolean DEFAULT false NOT NULL
);


--
-- Name: stores_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stores_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT stores_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT stores_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: subregions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subregions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    region_id uuid NOT NULL,
    "wikiDataId" text
);


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    is_default boolean DEFAULT false,
    owner_id uuid,
    company_id uuid
);


--
-- Name: suppliers_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT suppliers_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT suppliers_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    first_name text NOT NULL,
    last_name text NOT NULL,
    username text NOT NULL,
    pw_hsh text NOT NULL,
    date_of_birth date,
    date_of_employment date,
    date_of_termination date,
    is_verified boolean DEFAULT false NOT NULL,
    company_id uuid,
    image_id uuid,
    CONSTRAINT users_username_check CHECK ((char_length(username) >= 6))
);


--
-- Name: users_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text,
    contact_type text NOT NULL,
    prefix text,
    value text NOT NULL,
    parent_id uuid NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    place_id integer,
    bounding_box double precision[],
    iso_3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    CONSTRAINT users_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT users_contacts_iso_3_check CHECK (((char_length(iso_3) = 3) AND (iso_3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: companies_contacts companies_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies_contacts
    ADD CONSTRAINT companies_contacts_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: locations_available_products locations_available_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_available_products
    ADD CONSTRAINT locations_available_products_pkey PRIMARY KEY (id);


--
-- Name: locations_available_products locations_available_products_product_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_available_products
    ADD CONSTRAINT locations_available_products_product_id_location_id_key UNIQUE (product_id, location_id);


--
-- Name: locations_contacts locations_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_contacts
    ADD CONSTRAINT locations_contacts_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: locations_products locations_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_products
    ADD CONSTRAINT locations_products_pkey PRIMARY KEY (id);


--
-- Name: locations_users locations_users_location_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_users
    ADD CONSTRAINT locations_users_location_id_user_id_key UNIQUE (location_id, user_id);


--
-- Name: locations_users locations_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_users
    ADD CONSTRAINT locations_users_pkey PRIMARY KEY (id);


--
-- Name: manufacturers_contacts manufacturers_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers_contacts
    ADD CONSTRAINT manufacturers_contacts_pkey PRIMARY KEY (id);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: products_aliases products_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_aliases
    ADD CONSTRAINT products_aliases_pkey PRIMARY KEY (id);


--
-- Name: products products_barcode_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_barcode_unique UNIQUE (barcode);


--
-- Name: products_categories products_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_categories
    ADD CONSTRAINT products_categories_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase_items purchase_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stores_contacts stores_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores_contacts
    ADD CONSTRAINT stores_contacts_pkey PRIMARY KEY (id);


--
-- Name: stores stores_parent_id_title_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_parent_id_title_key UNIQUE (parent_id, title);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: subregions subregions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_pkey PRIMARY KEY (id);


--
-- Name: suppliers_contacts suppliers_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers_contacts
    ADD CONSTRAINT suppliers_contacts_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: users_contacts users_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_contacts
    ADD CONSTRAINT users_contacts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: locations trigger_insert_location_user; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_insert_location_user AFTER INSERT ON public.locations FOR EACH ROW EXECUTE FUNCTION public.insert_location_user();


--
-- Name: brands brands_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: brands brands_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.manufacturers(id) ON DELETE CASCADE;


--
-- Name: companies_contacts companies_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies_contacts
    ADD CONSTRAINT companies_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: companies companies_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: countries countries_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: countries countries_subregion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_subregion_id_fkey FOREIGN KEY (subregion_id) REFERENCES public.subregions(id);


--
-- Name: files files_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: files files_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: files files_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: locations_available_products locations_available_products_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_available_products
    ADD CONSTRAINT locations_available_products_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: locations_available_products locations_available_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_available_products
    ADD CONSTRAINT locations_available_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: locations locations_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: locations_contacts locations_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_contacts
    ADD CONSTRAINT locations_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: locations locations_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- Name: locations locations_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: locations_products locations_products_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_products
    ADD CONSTRAINT locations_products_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: locations_products locations_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_products
    ADD CONSTRAINT locations_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: locations_products locations_products_purchase_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_products
    ADD CONSTRAINT locations_products_purchase_item_id_fkey FOREIGN KEY (purchase_item_id) REFERENCES public.purchase_items(id) ON DELETE SET NULL;


--
-- Name: locations_users locations_users_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_users
    ADD CONSTRAINT locations_users_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: locations_users locations_users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_users
    ADD CONSTRAINT locations_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: locations_users locations_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations_users
    ADD CONSTRAINT locations_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: manufacturers manufacturers_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: manufacturers_contacts manufacturers_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers_contacts
    ADD CONSTRAINT manufacturers_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: products_aliases products_aliases_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_aliases
    ADD CONSTRAINT products_aliases_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products_aliases products_aliases_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_aliases
    ADD CONSTRAINT products_aliases_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE SET NULL;


--
-- Name: products_categories products_categories_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_categories
    ADD CONSTRAINT products_categories_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: products_categories products_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_categories
    ADD CONSTRAINT products_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.products_categories(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.products_categories(id);


--
-- Name: products products_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: products products_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: products products_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE SET NULL;


--
-- Name: products products_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_subcategory_id_fkey FOREIGN KEY (subcategory_id) REFERENCES public.products_categories(id);


--
-- Name: purchase_items purchase_items_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: purchase_items purchase_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: purchase_items purchase_items_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: purchase_items purchase_items_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.purchases(id) ON DELETE CASCADE;


--
-- Name: purchase_items purchase_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: purchases purchases_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: purchases purchases_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: purchases purchases_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: purchases purchases_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: roles roles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: stores stores_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: stores_contacts stores_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores_contacts
    ADD CONSTRAINT stores_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: stores stores_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: stores stores_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: subregions subregions_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE CASCADE;


--
-- Name: suppliers suppliers_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: suppliers_contacts suppliers_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers_contacts
    ADD CONSTRAINT suppliers_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: suppliers suppliers_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: users_contacts users_contacts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_contacts
    ADD CONSTRAINT users_contacts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20250123194951'),
    ('20250123194952'),
    ('20250123194953'),
    ('20250124103649'),
    ('20250125102754'),
    ('20250128074948'),
    ('20250128075220'),
    ('20250131195050'),
    ('20250133102012'),
    ('20250204095747'),
    ('20250205074325'),
    ('20250205075939'),
    ('20250302084427'),
    ('20250327123834'),
    ('20250410090924'),
    ('20250410112302'),
    ('20250413080323'),
    ('20250413104537'),
    ('20250422180927'),
    ('20250423193521'),
    ('20250423194714'),
    ('20250424055047'),
    ('20250424134602'),
    ('20250425105010'),
    ('20250426084153'),
    ('20250426084231'),
    ('20250426093226'),
    ('20250426094232'),
    ('20250426115053'),
    ('20250426115232'),
    ('20250426115240');
