COMMIT;

SELECT 'lock_a_committed' AS phase, pg_backend_pid() AS session_pid,
       p.sku, p.stock_quantity,
       (SELECT count(*) FROM p3_lab.orders WHERE order_reference = 'CM-P3-LOCK-A') AS order_rows,
       (SELECT count(*) FROM p3_lab.order_items AS i
        JOIN p3_lab.orders AS o USING (order_id)
        WHERE o.order_reference = 'CM-P3-LOCK-A') AS item_rows
FROM p3_lab.products AS p WHERE p.sku = 'EL001';
