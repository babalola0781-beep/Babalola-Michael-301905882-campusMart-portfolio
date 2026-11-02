COMMIT;
SELECT p.sku, p.stock_quantity,
       EXISTS (SELECT 1 FROM p3_lab.orders WHERE order_reference = 'CM-P3-LOCK-A') AS order_a_exists,
       EXISTS (SELECT 1 FROM p3_lab.orders WHERE order_reference = 'CM-P3-LOCK-B') AS order_b_exists,
       (SELECT i.quantity FROM p3_lab.order_items AS i
        JOIN p3_lab.orders AS o USING(order_id)
        WHERE o.order_reference = 'CM-P3-LOCK-A') AS order_a_quantity
FROM p3_lab.products AS p WHERE p.sku = 'EL001';
