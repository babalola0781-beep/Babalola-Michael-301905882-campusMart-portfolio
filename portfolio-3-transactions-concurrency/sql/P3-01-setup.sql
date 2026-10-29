BEGIN ISOLATION LEVEL REPEATABLE READ;
CREATE SCHEMA p3_lab;
COMMENT ON SCHEMA p3_lab IS 'CampusMart MIT8103 Portfolio 3 isolated transaction experiment v1';
CREATE TABLE p3_lab.categories (LIKE public.categories INCLUDING ALL);
INSERT INTO p3_lab.categories OVERRIDING SYSTEM VALUE SELECT * FROM public.categories;

CREATE TABLE p3_lab.customers (LIKE public.customers INCLUDING ALL);
INSERT INTO p3_lab.customers OVERRIDING SYSTEM VALUE SELECT * FROM public.customers;

CREATE TABLE p3_lab.products (LIKE public.products INCLUDING ALL);
INSERT INTO p3_lab.products OVERRIDING SYSTEM VALUE SELECT * FROM public.products;

CREATE TABLE p3_lab.orders (LIKE public.orders INCLUDING ALL);
INSERT INTO p3_lab.orders OVERRIDING SYSTEM VALUE SELECT * FROM public.orders;

CREATE TABLE p3_lab.order_items (LIKE public.order_items INCLUDING ALL);
INSERT INTO p3_lab.order_items OVERRIDING SYSTEM VALUE SELECT * FROM public.order_items;

ALTER TABLE p3_lab.products ADD FOREIGN KEY (category_id)
    REFERENCES p3_lab.categories(category_id) ON DELETE RESTRICT;
ALTER TABLE p3_lab.orders ADD FOREIGN KEY (customer_id)
    REFERENCES p3_lab.customers(customer_id) ON DELETE RESTRICT;
ALTER TABLE p3_lab.order_items ADD FOREIGN KEY (order_id)
    REFERENCES p3_lab.orders(order_id) ON DELETE RESTRICT;
ALTER TABLE p3_lab.order_items ADD FOREIGN KEY (product_id)
    REFERENCES p3_lab.products(product_id) ON DELETE RESTRICT;
SELECT setval(pg_get_serial_sequence('p3_lab.categories', 'category_id'), (SELECT max(category_id) FROM p3_lab.categories), true);
SELECT setval(pg_get_serial_sequence('p3_lab.customers', 'customer_id'), (SELECT max(customer_id) FROM p3_lab.customers), true);
SELECT setval(pg_get_serial_sequence('p3_lab.products', 'product_id'), (SELECT max(product_id) FROM p3_lab.products), true);
SELECT setval(pg_get_serial_sequence('p3_lab.orders', 'order_id'), (SELECT max(order_id) FROM p3_lab.orders), true);

DO $$
BEGIN
    IF (SELECT count(*) FROM p3_lab.products
        WHERE (sku = 'EL001' AND stock_quantity = 10)
           OR (sku = 'EL002' AND stock_quantity = 40)
           OR (sku = 'EL003' AND stock_quantity = 25)
           OR (sku = 'AC002' AND stock_quantity = 35)) <> 4 THEN
        RAISE EXCEPTION 'Portfolio 3 starting stock does not match the CampusMart experiment baseline.';
    END IF;
    IF EXISTS (SELECT 1 FROM p3_lab.orders WHERE order_reference LIKE 'CM-P3-%') THEN
        RAISE EXCEPTION 'Portfolio 3 experiment references already exist in the copied data.';
    END IF;
END;
$$;

CREATE FUNCTION p3_lab.original_fingerprints()
RETURNS TABLE (table_name text, row_count bigint, row_digest text)
LANGUAGE sql STABLE SET timezone = 'UTC'
AS $$
SELECT 'categories'::text, count(*), md5(coalesce(string_agg(to_jsonb(t)::text, E'\n' ORDER BY category_id), ''))
FROM public.categories AS t
UNION ALL
SELECT 'customers'::text, count(*), md5(coalesce(string_agg(to_jsonb(t)::text, E'\n' ORDER BY customer_id), ''))
FROM public.customers AS t
UNION ALL
SELECT 'products'::text, count(*), md5(coalesce(string_agg(to_jsonb(t)::text, E'\n' ORDER BY product_id), ''))
FROM public.products AS t
UNION ALL
SELECT 'orders'::text, count(*), md5(coalesce(string_agg(to_jsonb(t)::text, E'\n' ORDER BY order_id), ''))
FROM public.orders AS t
UNION ALL
SELECT 'order_items'::text, count(*), md5(coalesce(string_agg(to_jsonb(t)::text, E'\n' ORDER BY order_id, product_id), ''))
FROM public.order_items AS t;
$$;

CREATE TABLE p3_lab.original_baseline AS
SELECT * FROM p3_lab.original_fingerprints();
ALTER TABLE p3_lab.original_baseline ADD PRIMARY KEY (table_name);

CREATE FUNCTION p3_lab.place_order(
    p_reference text, p_email text, p_sku text, p_quantity integer
)
RETURNS TABLE (
    request_reference text, outcome text, stock_before integer,
    stock_after integer, requested_quantity integer
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id bigint;
    v_product_id bigint;
    v_order_id bigint;
    v_stock integer;
    v_price numeric(12,2);
BEGIN
    IF p_quantity IS NULL OR p_quantity <= 0
       OR p_reference IS NULL OR btrim(p_reference) = ''
       OR length(p_reference) > 20 THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'Invalid quantity or order reference.';
    END IF;
    SELECT c.customer_id INTO v_customer_id
    FROM p3_lab.customers AS c WHERE c.email = p_email;
    IF NOT FOUND THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'Customer does not exist.';
    END IF;

    SELECT p.product_id, p.stock_quantity, p.price
    INTO v_product_id, v_stock, v_price
    FROM p3_lab.products AS p WHERE p.sku = p_sku
    FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'Product does not exist.';
    END IF;
    IF v_stock < p_quantity THEN
        RETURN QUERY SELECT p_reference, 'rejected_insufficient_stock'::text,
                            v_stock, v_stock, p_quantity;
        RETURN;
    END IF;

    INSERT INTO p3_lab.orders (customer_id, order_reference, status)
    VALUES (v_customer_id, p_reference, 'placed')
    RETURNING order_id INTO v_order_id;
    INSERT INTO p3_lab.order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_order_id, v_product_id, p_quantity, v_price);
    UPDATE p3_lab.products SET stock_quantity = v_stock - p_quantity
    WHERE product_id = v_product_id;
    RETURN QUERY SELECT p_reference, 'accepted'::text,
                        v_stock, v_stock - p_quantity, p_quantity;
END;
$$;
COMMIT;

SELECT 'categories' AS table_name, count(*) AS copied_rows FROM p3_lab.categories
UNION ALL SELECT 'customers', count(*) FROM p3_lab.customers
UNION ALL SELECT 'products', count(*) FROM p3_lab.products
UNION ALL SELECT 'orders', count(*) FROM p3_lab.orders
UNION ALL SELECT 'order_items', count(*) FROM p3_lab.order_items
ORDER BY table_name;
