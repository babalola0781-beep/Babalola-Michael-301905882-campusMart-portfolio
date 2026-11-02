BEGIN;
SELECT * FROM p3_lab.place_order('CM-P3-COMMIT', 'amina@example.test', 'EL002', 2);
COMMIT;

SELECT 'after_commit' AS phase, pg_backend_pid() AS session_pid,
       p.sku, p.stock_quantity,
       (SELECT count(*) FROM p3_lab.orders WHERE order_reference = 'CM-P3-COMMIT') AS order_rows,
       (SELECT count(*) FROM p3_lab.order_items AS i
        JOIN p3_lab.orders AS o USING (order_id)
        WHERE o.order_reference = 'CM-P3-COMMIT') AS item_rows
FROM p3_lab.products AS p WHERE p.sku = 'EL002';
