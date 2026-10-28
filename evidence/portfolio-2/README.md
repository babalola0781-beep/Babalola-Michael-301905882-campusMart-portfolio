# Portfolio 2 execution evidence

These screenshots and CSV exports record my execution in pgAdmin 4 against `campusmart_portfolio`, running PostgreSQL 18.6 with session timezone `Africa/Lagos`. The recorded benchmark runs are dated 28 October 2026.

The evidence contains 17 screenshots and 19 CSV exports. The execution plans and repeated timing records are included alongside the visible result grids.

## Results

The sequential scan changed to a bitmap index scan on `idx_orders_customer_date` followed by a bitmap heap scan. Both plans retain a sort. Median execution time decreased from **1.630 ms to 0.095 ms**, a **94.17% reduction** across five recorded runs per phase. All ten runs returned twenty rows, and the before/after phase digests match. The five original table counts remain 4 categories, 6 customers, 10 products, 8 orders and 16 order items.

## Evidence index

| Evidence | SQL | Screenshot | Export |
|---|---|---|---|
| 01-environment: PostgreSQL 18.6, Africa/Lagos, original table counts and no benchmark schema or index before setup. | [P2-00-environment.sql](../../portfolio-2-query-optimisation/sql/P2-00-environment.sql) | [PNG](screenshots/01-environment.png) | [CSV](results/01-environment.csv) |
| 02-low-stock: Two products: Compact Umbrella at zero stock and Student Laptop at ten units. | [Q01-low-stock.sql](../../portfolio-2-query-optimisation/sql/Q01-low-stock.sql) | [PNG](screenshots/02-low-stock.png) | [CSV](results/02-low-stock.csv) |
| 03-customer-orders: CM-1005 and CM-1001, valued at NGN 34,000 and NGN 467,000. | [Q02-customer-orders.sql](../../portfolio-2-query-optimisation/sql/Q02-customer-orders.sql) | [PNG](screenshots/03-customer-orders.png) | [CSV](results/03-customer-orders.csv) |
| 04-all-order-values: Eight orders across completed, placed, draft and cancelled statuses. | [Q03-all-order-values.sql](../../portfolio-2-query-optimisation/sql/Q03-all-order-values.sql) | [PNG](screenshots/04-all-order-values.png) | [CSV](results/04-all-order-values.csv) |
| 05-product-sales: Nine products sold in completed orders; sales total NGN 580,500. | [Q04-product-sales.sql](../../portfolio-2-query-optimisation/sql/Q04-product-sales.sql) | [PNG](screenshots/05-product-sales.png) | [CSV](results/05-product-sales.csv) |
| 06-customers-without-orders: Ada Nwosu is the customer without an order. | [Q05-customers-without-orders.sql](../../portfolio-2-query-optimisation/sql/Q05-customers-without-orders.sql) | [PNG](screenshots/06-customers-without-orders.png) | [CSV](results/06-customers-without-orders.csv) |
| 07-monthly-sales: October 2026: five completed orders and NGN 580,500. | [Q06-monthly-completed-sales.sql](../../portfolio-2-query-optimisation/sql/Q06-monthly-completed-sales.sql) | [PNG](screenshots/07-monthly-sales.png) | [CSV](results/07-monthly-sales.csv) |
| 08-customer-ranking: Four customers ranked by completed spending. | [Q07-customer-ranking.sql](../../portfolio-2-query-optimisation/sql/Q07-customer-ranking.sql) | [PNG](screenshots/08-customer-ranking.png) | [CSV](results/08-customer-ranking.csv) |
| 09-category-sales: Four category totals reconcile to NGN 580,500. | [Q08-category-sales.sql](../../portfolio-2-query-optimisation/sql/Q08-category-sales.sql) | [PNG](screenshots/09-category-sales.png) | [CSV](results/09-category-sales.csv) |
| 10-benchmark-counts: 1,000 benchmark customers and 20,000 benchmark orders; six original customers and eight original orders. | [P2-01-benchmark-setup.sql](../../portfolio-2-query-optimisation/sql/P2-01-benchmark-setup.sql) | [PNG](screenshots/10-benchmark-counts.png) | [CSV](results/10-benchmark-counts.csv) |
| 11-plan-before: Sequential scan and sort; 19,980 rows removed by the filter. | [P2-02-plan-before.sql](../../portfolio-2-query-optimisation/sql/P2-02-plan-before.sql) | [PNG](screenshots/11-plan-before.png) | [CSV](plans/11-plan-before.csv) |
| 12-before-timings: Five recorded runs; median execution time 1.630 ms. | [P2-03-measure-before.sql](../../portfolio-2-query-optimisation/sql/P2-03-measure-before.sql) | [PNG](screenshots/12-before-timings.png) | [CSV](results/12-before-timings.csv) |
| 13-index-definition: B-tree index on customer_id, order_date DESC and order_id DESC. | [P2-04-create-index.sql](../../portfolio-2-query-optimisation/sql/P2-04-create-index.sql) | [PNG](screenshots/13-index-definition.png) | [CSV](results/13-index-definition.csv) |
| 14-plan-after: Bitmap index scan, bitmap heap scan and sort; twenty matching heap blocks. | [P2-05-plan-after.sql](../../portfolio-2-query-optimisation/sql/P2-05-plan-after.sql) | [PNG](screenshots/14-plan-after.png) | [CSV](plans/14-plan-after.csv) |
| 15-after-timings: Five recorded runs; median execution time 0.095 ms. | [P2-06-measure-after.sql](../../portfolio-2-query-optimisation/sql/P2-06-measure-after.sql) | [PNG](screenshots/15-after-timings.png) | [CSV](results/15-after-timings.csv) |
| 16-performance-comparison: Median execution time reduced by 94.17%. | [P2-07-comparison.sql](../../portfolio-2-query-optimisation/sql/P2-07-comparison.sql) | [PNG](screenshots/16-performance-comparison.png) | [CSV](results/16-performance-comparison.csv) |
| 17-result-check: Matching phase digests, twenty rows in every run and unchanged original row counts. | [P2-08-result-check.sql](../../portfolio-2-query-optimisation/sql/P2-08-result-check.sql) | [PNG](screenshots/17-result-check.png) | [CSV](results/17-result-check.csv) |
| 18-all-runs: Ten timestamped measurements with planning times, execution times, buffers and phase result digests. | [P2-09-all-runs.sql](../../portfolio-2-query-optimisation/sql/P2-09-all-runs.sql) | — | [CSV](results/18-all-runs.csv) |
| 19-json-plans: The JSON execution plan for each of the ten recorded runs. | [P2-10-json-plans.sql](../../portfolio-2-query-optimisation/sql/P2-10-json-plans.sql) | — | [CSV](plans/19-json-plans.csv) |

The standalone plans are separate diagnostic executions: 1.633 ms before indexing and 0.142 ms after indexing. The median comparison uses the five recorded runs per phase, not those two individual plan times. The matching phase digests compare the selected benchmark result; the original-table check compares row counts.

[Performance analysis](../../portfolio-2-query-optimisation/performance-analysis.md) · [SQL scripts](../../portfolio-2-query-optimisation/sql/)
