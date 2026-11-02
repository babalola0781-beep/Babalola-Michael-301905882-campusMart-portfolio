CREATE INDEX idx_orders_customer_date
ON p2_benchmark.orders(customer_id, order_date DESC, order_id DESC);
SELECT indexname, indexdef FROM pg_indexes
WHERE schemaname='p2_benchmark' AND indexname='idx_orders_customer_date';
