WITH checks AS (
 SELECT COUNT(*) AS measured_runs, COUNT(DISTINCT phase) AS measured_phases,
        COUNT(DISTINCT result_digest)=1 AND COUNT(result_digest)=10 AS phase_results_match,
        MIN(actual_rows)=20 AND MAX(actual_rows)=20 AND COUNT(*)=10 AS twenty_rows_each_run
 FROM p2_benchmark.runs
)
SELECT check_name, value FROM checks, LATERAL (VALUES
 (1, 'measured_phases', measured_phases::text),
 (2, 'measured_runs', measured_runs::text),
 (3, 'phase_results_match', phase_results_match::text),
 (4, 'twenty_rows_each_run', twenty_rows_each_run::text),
 (5, 'original_categories', (SELECT count(*)::text FROM public.categories)),
 (6, 'original_customers', (SELECT count(*)::text FROM public.customers)),
 (7, 'original_products', (SELECT count(*)::text FROM public.products)),
 (8, 'original_orders', (SELECT count(*)::text FROM public.orders)),
 (9, 'original_order_items', (SELECT count(*)::text FROM public.order_items))
) AS results(position, check_name, value) ORDER BY position;
