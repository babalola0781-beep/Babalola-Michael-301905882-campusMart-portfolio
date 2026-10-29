WITH checks AS (
    SELECT 'original_' || b.table_name AS check_name,
           (c.row_count = b.row_count AND c.row_digest = b.row_digest)::text AS actual,
           'true'::text AS expected
    FROM p3_lab.original_baseline AS b
    JOIN p3_lab.original_fingerprints() AS c USING(table_name)
    UNION ALL SELECT 'committed_order', count(*)::text, '1'
        FROM p3_lab.orders WHERE order_reference = 'CM-P3-COMMIT'
    UNION ALL SELECT 'rolled_back_order', count(*)::text, '0'
        FROM p3_lab.orders WHERE order_reference = 'CM-P3-ROLLBACK'
    UNION ALL SELECT 'mouse_stock_after_rollback', stock_quantity::text, '38'
        FROM p3_lab.products WHERE sku = 'EL002'
    UNION ALL SELECT 'read_committed_stock', stock_quantity::text, '24'
        FROM p3_lab.products WHERE sku = 'EL003'
    UNION ALL SELECT 'repeatable_read_final_stock', stock_quantity::text, '34'
        FROM p3_lab.products WHERE sku = 'AC002'
    UNION ALL SELECT 'locked_product_stock', stock_quantity::text, '3'
        FROM p3_lab.products WHERE sku = 'EL001'
    UNION ALL SELECT 'accepted_concurrent_order', count(*)::text, '1'
        FROM p3_lab.orders WHERE order_reference = 'CM-P3-LOCK-A'
    UNION ALL SELECT 'rejected_concurrent_order', count(*)::text, '0'
        FROM p3_lab.orders WHERE order_reference = 'CM-P3-LOCK-B'
    UNION ALL SELECT 'lab_orders_count', count(*)::text,
        (SELECT (row_count + 2)::text FROM p3_lab.original_baseline WHERE table_name = 'orders')
        FROM p3_lab.orders
    UNION ALL SELECT 'lab_items_count', count(*)::text,
        (SELECT (row_count + 2)::text FROM p3_lab.original_baseline WHERE table_name = 'order_items')
        FROM p3_lab.order_items
)
SELECT check_name, actual, expected,
       CASE WHEN actual = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM checks ORDER BY check_name;
