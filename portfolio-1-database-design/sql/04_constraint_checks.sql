-- Run the WHOLE file after 01 and 02. Expected output: 12 PASS rows.
-- Each invalid operation runs in an exception block (a subtransaction).
-- Expected errors are caught; any unexpectedly successful operation is undone.
-- ROLLBACK at the end leaves permanent table data unchanged.
-- Identity sequence numbers can have gaps after rejected inserts; this is normal.
BEGIN;

CREATE TEMP TABLE p1_constraint_results (
    test_no INTEGER, test_name TEXT, result TEXT,
    expected_sqlstate TEXT, actual_sqlstate TEXT, detail TEXT
) ON COMMIT DROP;

DO $$
DECLARE
    t RECORD;
    caught_state TEXT;
    caught_constraint TEXT;
    caught_message TEXT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.orders WHERE order_reference = 'CM-1001')
       OR NOT EXISTS (SELECT 1 FROM public.products WHERE sku = 'EL001') THEN
        RAISE EXCEPTION 'Run 02_seed_data.sql before the constraint checks.';
    END IF;

    FOR t IN SELECT * FROM (VALUES
      (1, 'Duplicate customer email', '23505', 'uq_customers_email',
       $q$INSERT INTO public.customers(full_name,email) VALUES ('Duplicate Test','amina@example.test')$q$),
      (2, 'Unknown customer on an order', '23503', 'fk_orders_customer',
       $q$INSERT INTO public.orders(customer_id,order_reference) VALUES (-1,'TEST-UNKNOWN')$q$),
      (3, 'Negative product stock', '23514', 'ck_products_stock',
       $q$UPDATE public.products SET stock_quantity = -1 WHERE sku = 'EL001'$q$),
      (4, 'Zero order-item quantity', '23514', 'ck_order_items_quantity',
       $q$UPDATE public.order_items SET quantity = 0 WHERE order_id = (SELECT order_id FROM public.orders WHERE order_reference='CM-1001') AND product_id = (SELECT product_id FROM public.products WHERE sku='EL001')$q$),
      (5, 'Negative current price', '23514', 'ck_products_price',
       $q$UPDATE public.products SET price = -1 WHERE sku = 'EL001'$q$),
      (6, 'Missing customer name', '23502', '',
       $q$INSERT INTO public.customers(full_name,email) VALUES (NULL,'null-name@example.test')$q$),
      (7, 'Duplicate product line in one order', '23505', 'pk_order_items',
       $q$INSERT INTO public.order_items(order_id,product_id,quantity,unit_price) SELECT order_id,product_id,quantity,unit_price FROM public.order_items WHERE order_id=(SELECT order_id FROM public.orders WHERE order_reference='CM-1001') AND product_id=(SELECT product_id FROM public.products WHERE sku='EL001')$q$),
      (8, 'Unknown product category', '23503', 'fk_products_category',
       $q$INSERT INTO public.products(category_id,sku,product_name,price,stock_quantity) VALUES (-1,'TEST-CAT','Category Test',100,1)$q$),
      -- PostgreSQL releases can report RESTRICT as 23001 or 23503.
      (9, 'Delete customer with historical orders', '23001|23503', 'fk_orders_customer',
       $q$DELETE FROM public.customers WHERE email='amina@example.test'$q$),
      (10, 'Invalid order status', '23514', 'ck_orders_status',
       $q$UPDATE public.orders SET status='unknown' WHERE order_reference='CM-1001'$q$),
      (11, 'Negative charged price', '23514', 'ck_order_items_price',
       $q$UPDATE public.order_items SET unit_price=-1 WHERE order_id=(SELECT order_id FROM public.orders WHERE order_reference='CM-1001') AND product_id=(SELECT product_id FROM public.products WHERE sku='EL001')$q$),
      (12, 'Blank product name', '23514', 'ck_products_name',
       $q$UPDATE public.products SET product_name='   ' WHERE sku='EL001'$q$)
    ) AS x(test_no,test_name,expected_sqlstate,expected_constraint,statement_sql)
    LOOP
        BEGIN
            EXECUTE t.statement_sql;
            RAISE EXCEPTION USING ERRCODE = 'P0001',
                MESSAGE = 'FAIL: invalid operation was accepted or no target row was found';
        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS
                caught_state = RETURNED_SQLSTATE,
                caught_constraint = CONSTRAINT_NAME,
                caught_message = MESSAGE_TEXT;
            INSERT INTO p1_constraint_results VALUES (
                t.test_no, t.test_name,
                CASE WHEN caught_state = ANY(string_to_array(t.expected_sqlstate, '|'))
                          AND (t.expected_constraint = '' OR caught_constraint = t.expected_constraint)
                     THEN 'PASS' ELSE 'FAIL' END,
                t.expected_sqlstate, caught_state, caught_message
            );
        END;
    END LOOP;
END $$;

SELECT * FROM p1_constraint_results ORDER BY test_no;
ROLLBACK;
