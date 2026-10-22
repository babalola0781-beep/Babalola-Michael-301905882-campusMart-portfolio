SELECT check_name, value FROM (VALUES
 (1, 'database_name', current_database()),
 (2, 'server_version', current_setting('server_version')),
 (3, 'session_timezone', current_setting('TimeZone')),
 (4, 'categories', (SELECT count(*)::text FROM public.categories)),
 (5, 'customers', (SELECT count(*)::text FROM public.customers)),
 (6, 'products', (SELECT count(*)::text FROM public.products)),
 (7, 'orders', (SELECT count(*)::text FROM public.orders)),
 (8, 'order_items', (SELECT count(*)::text FROM public.order_items)),
 (9, 'benchmark_schema_exists', (to_regnamespace('p2_benchmark') IS NOT NULL)::text),
 (10, 'benchmark_index_exists', (to_regclass('p2_benchmark.idx_orders_customer_date') IS NOT NULL)::text)
) AS checks(position, check_name, value) ORDER BY position;
