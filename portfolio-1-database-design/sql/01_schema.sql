-- PORTFOLIO 1 | CampusMart | PostgreSQL
-- Run once in a NEW, EMPTY database named campusmart_portfolio.
-- In pgAdmin, select the correct database, open this file, then Execute script.
-- This script deliberately does not drop or overwrite existing tables.
BEGIN;

CREATE TABLE public.customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(254) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT ck_customers_name CHECK (btrim(full_name) <> ''),
    -- Basic format / canonical-storage rule, not complete email verification.
    CONSTRAINT ck_customers_email CHECK (
        email = lower(btrim(email)) AND position('@' IN email) > 1
    )
);

CREATE TABLE public.categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(80) NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name),
    CONSTRAINT ck_categories_name CHECK (btrim(category_name) <> '')
);

CREATE TABLE public.products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY,
    category_id BIGINT NOT NULL,
    sku VARCHAR(20) NOT NULL,
    product_name VARCHAR(120) NOT NULL,
    price NUMERIC(12,2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT uq_products_sku UNIQUE (sku),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES public.categories (category_id) ON DELETE RESTRICT,
    CONSTRAINT ck_products_sku CHECK (btrim(sku) <> ''),
    CONSTRAINT ck_products_name CHECK (btrim(product_name) <> ''),
    CONSTRAINT ck_products_price CHECK (price >= 0 AND price <> 'NaN'::numeric),
    CONSTRAINT ck_products_stock CHECK (stock_quantity >= 0)
);

CREATE TABLE public.orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY,
    customer_id BIGINT NOT NULL,
    order_reference VARCHAR(20) NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(15) NOT NULL DEFAULT 'draft',
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT uq_orders_reference UNIQUE (order_reference),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) ON DELETE RESTRICT,
    CONSTRAINT ck_orders_reference CHECK (btrim(order_reference) <> ''),
    CONSTRAINT ck_orders_status CHECK (
        status IN ('draft', 'placed', 'completed', 'cancelled')
    )
);

CREATE TABLE public.order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
        REFERENCES public.orders (order_id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
        REFERENCES public.products (product_id) ON DELETE RESTRICT,
    CONSTRAINT ck_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_order_items_price CHECK (
        unit_price >= 0 AND unit_price <> 'NaN'::numeric
    )
);

COMMENT ON COLUMN public.order_items.unit_price IS
    'Price charged per unit on this order, in NGN; independent of current product price.';
COMMENT ON COLUMN public.products.stock_quantity IS
    'Current stock on hand; seed data already represents a point-in-time snapshot.';
COMMENT ON TABLE public.orders IS
    'Drafts may have no items. Requiring an item before placement needs workflow enforcement.';

COMMIT;
