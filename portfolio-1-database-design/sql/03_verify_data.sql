-- Read-only checks. Run each numbered SELECT separately to view/capture its grid.
-- These expected results apply immediately after the supplied seed script.

-- CHECK 1: five rows, all PASS. This is the first screenshot to capture.
WITH actual AS (
    SELECT 'customers' AS table_name, count(*) AS actual_rows FROM public.customers
    UNION ALL SELECT 'categories', count(*) FROM public.categories
    UNION ALL SELECT 'products', count(*) FROM public.products
    UNION ALL SELECT 'orders', count(*) FROM public.orders
    UNION ALL SELECT 'order_items', count(*) FROM public.order_items
), expected(table_name, expected_rows) AS (
    VALUES ('customers', 6), ('categories', 4), ('products', 10),
           ('orders', 8), ('order_items', 16)
)
SELECT a.table_name, a.actual_rows, e.expected_rows,
       CASE WHEN a.actual_rows = e.expected_rows THEN 'PASS' ELSE 'FAIL' END AS result
FROM actual a JOIN expected e USING (table_name)
ORDER BY a.table_name;

-- CHECK 2: eight orders. Amounts include ALL statuses, so this is NOT revenue.
SELECT o.order_reference, c.full_name, o.status,
       sum(oi.quantity * oi.unit_price)::numeric(14,2) AS order_value_ngn
FROM public.orders o
JOIN public.customers c ON c.customer_id = o.customer_id
JOIN public.order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_reference, c.full_name, o.status
ORDER BY o.order_reference;

-- CHECK 3: the textbook's charged price is 16000.00; current price is 18000.00.
SELECT o.order_reference, p.sku, p.product_name,
       p.price AS current_price_ngn, oi.unit_price AS charged_price_ngn
FROM public.order_items oi
JOIN public.products p ON p.product_id = oi.product_id
JOIN public.orders o ON o.order_id = oi.order_id
WHERE o.order_reference = 'CM-1005' AND p.sku = 'BK001';

-- CHECK 4: zero rows = no seeded placed/completed orders are missing items.
-- This is a detection query, not an enforcement constraint.
SELECT o.order_reference
FROM public.orders o
WHERE o.status IN ('placed', 'completed')
  AND NOT EXISTS (SELECT 1 FROM public.order_items oi WHERE oi.order_id = o.order_id);

-- CHECK 5: implemented keys and checks; compare with the ERD/data dictionary.
SELECT c.relname AS table_name, con.conname AS constraint_name,
       pg_get_constraintdef(con.oid) AS definition
FROM pg_constraint con
JOIN pg_class c ON c.oid = con.conrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relname IN ('customers', 'categories', 'products', 'orders', 'order_items')
ORDER BY c.relname, con.conname;
