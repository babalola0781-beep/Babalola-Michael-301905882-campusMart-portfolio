# CampusMart query processing and performance analysis

**Michael Olayemi Babalola | MIT 8103 | Portfolio 2**

## Scope and execution environment

Eight SQL queries support CampusMart stock checks, customer order histories, sales summaries and customer rankings. A separate indexing experiment tests a selective customer-order lookup. I executed the scripts in pgAdmin 4 using PostgreSQL 18.6 and database `campusmart_portfolio`, with session timezone `Africa/Lagos`. The [desktop evidence](../evidence/Babalola_Michael_portfolio-2/Babalola_Michael_README.md) contains 17 screenshots and 19 CSV exports. The recorded benchmark runs are dated 28 October 2026.

## Business query results

Q01 returns Compact Umbrella with zero stock and Student Laptop with ten units. Q02 returns Amina Yusuf's orders CM-1005 and CM-1001 at NGN 34,000 and NGN 467,000. Q03 returns eight order values across all statuses; these are not all completed sales. Its `LEFT JOIN` and `COALESCE` also retain a zero-valued order if it has no items.

Q04 returns nine products sold in completed orders, including textbook sales of NGN 34,000 calculated from historical charged prices. Q05 uses `NOT EXISTS` to identify Ada Nwosu as the customer without an order.

Q06 reports five completed orders and NGN 580,500 for October 2026. `COUNT(DISTINCT order_id)` avoids counting an order repeatedly after joining its items. Q07 ranks completed spending: Amina Yusuf (501,000), Emeka Obi (28,500), Chidinma Okeke (27,000) and Tunde Bello (24,000). Q08 reports Electronics (491,000), Books (40,000), Clothing (31,000) and Accessories (18,500). The product, customer, category and monthly totals reconcile to NGN 580,500. [Screenshots and exports 02–09](../evidence/Babalola_Michael_portfolio-2/Babalola_Michael_README.md#evidence-index) record these results.

## Indexing experiment

The original eight-order dataset is small, so the experiment uses a separate `p2_benchmark` schema with 1,000 fictional customers and 20,000 orders. Each customer has twenty orders. Both phases execute the same lookup:

```sql
SELECT order_id, order_reference, order_date, status
FROM p2_benchmark.orders
WHERE customer_id = 125
ORDER BY order_date DESC, order_id DESC;
```

The query selects twenty rows, or 0.1% of the orders. The existing primary-key and unique-reference indexes do not begin with `customer_id`. The additional index is:

```sql
CREATE INDEX idx_orders_customer_date
ON p2_benchmark.orders(customer_id, order_date DESC, order_id DESC);
```

The leading column supports the equality filter [2]. After `ANALYZE`, each phase performs one unrecorded warm-up and five recorded `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` executions. The scripts leave planner settings unchanged and store planning and execution times separately. The comparison uses median execution time.

## Desktop measurements

| Metric | Before index | After index |
|---|---:|---:|
| Recorded executions | 5 | 5 |
| Median execution time (ms) | 1.630 | 0.095 |
| Rows returned in every run | 20 | 20 |
| Shared buffer hits in each recorded run | 186 | 22 |
| Shared buffer reads in each recorded run | 0 | 0 |

The reduction is `100 × (1.630 − 0.095) / 1.630` = **94.17%**. The [comparison screenshot](../evidence/Babalola_Michael_portfolio-2/screenshots/Babalola_Michael_16-performance-comparison.png) and [comparison CSV](../evidence/Babalola_Michael_portfolio-2/results/Babalola_Michael_16-performance-comparison.csv) show the same result.

| Run | Before execution (ms) | After execution (ms) |
|---:|---:|---:|
| 1 | 1.663 | 0.157 |
| 2 | 1.914 | 0.091 |
| 3 | 1.529 | 0.095 |
| 4 | 1.630 | 0.077 |
| 5 | 1.590 | 0.102 |

Sources: [all ten measurements](../evidence/Babalola_Michael_portfolio-2/results/Babalola_Michael_18-all-runs.csv) and their [JSON plans](../evidence/Babalola_Michael_portfolio-2/plans/Babalola_Michael_19-json-plans.csv).

## Execution plan interpretation

The [before-index plan](../evidence/Babalola_Michael_portfolio-2/plans/Babalola_Michael_11-plan-before.csv) uses a sequential scan followed by a sort. It filters out 19,980 rows. The [after-index plan](../evidence/Babalola_Michael_portfolio-2/plans/Babalola_Michael_14-plan-after.csv) uses a bitmap index scan on `idx_orders_customer_date`, then a bitmap heap scan over twenty matching heap blocks. A sort remains because bitmap access visits heap locations rather than preserving index order [3]. The improvement is consistent with the smaller amount of scanning shown in the plans and buffer counts.

The standalone plans took 1.633 ms before indexing and 0.142 ms after indexing. These are separate diagnostic runs, not the five-run medians. The standalone after-index plan reports twenty shared hits and two reads; the subsequent recorded runs each report 22 hits and no reads. Buffer reads are not a direct measurement of physical disk activity [1].

The [result checks](../evidence/Babalola_Michael_portfolio-2/results/Babalola_Michael_17-result-check.csv) report matching phase result digests and twenty rows in every measured run. Original row counts remain 4 categories, 6 customers, 10 products, 8 orders and 16 order items. The digest compares the selected benchmark result; unchanged counts alone do not establish equality of every value in the original tables.

## Reflection and limitations

The experiment shows why execution plans matter alongside timings: the index reduced scanning even though it did not remove the sort. The result checks also support comparing performance without changing the selected result.

The 94.17% reduction applies to one selective query on a uniformly generated dataset on this installation. Five runs per phase, warm caches and a fixed before-then-after sequence limit how far the result can be generalised. Concurrent workloads, cold-cache performance and customers with different order counts were not tested. `EXPLAIN ANALYZE` also adds instrumentation overhead and excludes sending result rows to the client [1].

The index requires storage and maintenance during writes. Its benefit for this lookup does not establish the same improvement for other queries or overall application performance.

## References

[1] PostgreSQL Global Development Group. [PostgreSQL 18 documentation: Using EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html).

[2] PostgreSQL Global Development Group. [PostgreSQL 18 documentation: Multicolumn Indexes](https://www.postgresql.org/docs/18/indexes-multicolumn.html).

[3] PostgreSQL Global Development Group. [PostgreSQL 18 documentation: Combining Multiple Indexes](https://www.postgresql.org/docs/18/indexes-bitmap-scans.html).
