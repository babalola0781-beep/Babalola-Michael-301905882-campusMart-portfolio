EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, order_reference, order_date, status FROM p2_benchmark.orders WHERE customer_id=125 ORDER BY order_date DESC, order_id DESC;
