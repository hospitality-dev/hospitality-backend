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
    iso3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    iso_3 text,
    CONSTRAINT companies_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT companies_contacts_iso3_check CHECK (((char_length(iso3) = 3) AND (iso3 ~ '^[A-Z]{3}$'::text)))
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    title text NOT NULL,
    iso3 text,
    numeric_code text,
    iso2 text,
    phonecode text,
    capital text,
    currency text,
    currency_name text,
    currency_symbol text,
    tld text,
    nationality text,
    timezones jsonb,
    latitude numeric(10,8),
    longitude numeric(11,8),
    "wikiDataId" text,
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
    CONSTRAINT files_category_check CHECK ((category = ANY (ARRAY['reports'::text, 'qr_codes'::text, 'images'::text]))),
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
    iso3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    iso_3 text,
    CONSTRAINT locations_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT locations_contacts_iso3_check CHECK (((char_length(iso3) = 3) AND (iso3 ~ '^[A-Z]{3}$'::text)))
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
    expiration_date timestamp with time zone
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
    CONSTRAINT products_check CHECK (((volume IS NULL) OR (volume_unit IS NOT NULL))),
    CONSTRAINT products_check1 CHECK (((weight IS NULL) OR (weight_unit IS NOT NULL))),
    CONSTRAINT products_volume_unit_check CHECK (((volume_unit IS NULL) OR (volume_unit = ANY (ARRAY['l'::text, 'ml'::text, 'fl_oz'::text, 'gal'::text])))),
    CONSTRAINT products_weight_unit_check CHECK (((weight_unit IS NULL) OR (weight_unit = ANY (ARRAY['kg'::text, 'g'::text, 'mg'::text, 'lb'::text, 'oz'::text])))),
    CONSTRAINT title_min_length CHECK ((char_length(title) >= 1))
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
    owner_id uuid
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
    total numeric(10,5) DEFAULT 0 NOT NULL,
    payment_type smallint NOT NULL,
    address text,
    business_title text NOT NULL,
    business_location_title text,
    tax_id text,
    transaction_type smallint,
    invoice_type smallint,
    invoice_counter_extension text,
    invoice_number text,
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
-- Name: subregions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subregions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    region_id uuid NOT NULL,
    "wikiDataId" text
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
    iso3 text,
    is_public boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    iso_3 text,
    CONSTRAINT users_contacts_contact_type_check CHECK ((contact_type = ANY (ARRAY['work_email'::text, 'personal_email'::text, 'support_email'::text, 'billing_email'::text, 'work_phone'::text, 'personal_phone'::text, 'mobile_phone'::text, 'fax'::text, 'home_phone'::text, 'whatsapp'::text, 'slack'::text, 'work_address'::text, 'home_address'::text, 'billing_address'::text, 'shipping_address'::text, 'website'::text, 'linkedin'::text, 'twitter'::text, 'facebook'::text, 'instagram'::text, 'sales_email'::text, 'marketing_email'::text, 'hr_email'::text, 'contact_email'::text, 'sales_phone'::text, 'support_phone'::text, 'customer_service_phone'::text, 'general_inquiry_phone'::text, 'office_address'::text, 'headquarters_address'::text, 'warehouse_address'::text, 'company_website'::text, 'support_website'::text]))),
    CONSTRAINT users_contacts_iso3_check CHECK (((char_length(iso3) = 3) AND (iso3 ~ '^[A-Z]{3}$'::text)))
);


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
-- Name: subregions subregions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_pkey PRIMARY KEY (id);


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
-- Name: roles roles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: subregions subregions_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE CASCADE;


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
    ('20250412173117'),
    ('20250413080323'),
    ('20250413104537'),
    ('20250421134602');
