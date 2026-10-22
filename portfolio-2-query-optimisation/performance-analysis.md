# CampusMart query processing and performance analysis

**Michael Olayemi Babalola | MIT 8103 | Portfolio 2**

## Scope and evidence

CampusMart needs stock checks, customer order histories, sales summaries and customer rankings. Eight SQL queries address these operations using the relational model from Portfolio 1. The optimisation experiment focuses on a selective customer-order lookup as the order history grows.

The results below were produced by automated validation using **PGlite 0.5.8 with embedded PostgreSQL 18.3**. They are separate from the PostgreSQL 18.6 desktop execution documented for Portfolio 1. The [raw evidence](../evidence/portfolio-2/README.md) includes query outputs, text and JSON plans, all ten timing measurements, source checksums and validation checks.

## Query results and correctness

Q01 identifies Compact Umbrella with zero stock and Student Laptop with ten units. Q02 returns Amina Yusuf's orders CM-1005 and CM-1001 with charged values of NGN 34,000 and NGN 467,000. Q03 returns eight orders, including incomplete and cancelled orders. Its `LEFT JOIN` and `COALESCE` also preserve a zero-valued order if it has no items.

Q04 returns nine products sold in completed orders. The textbook total is NGN 34,000 because historical charged prices are retained; multiplying by the current catalogue price would overstate this amount. Q05 uses `NOT EXISTS` to identify Ada Nwosu as the customer without an order.

Q06 reports five completed orders and NGN 580,500 for October 2026 using Africa/Lagos calendar months. `COUNT(DISTINCT order_id)` prevents orders with several items from being counted repeatedly. Q07 ranks customers by completed spending: Amina Yusuf (501,000), Emeka Obi (28,500), Chidinma Okeke (27,000), and Tunde Bello (24,000). `DENSE_RANK` gives equal ranks to equal totals without gaps. Q08 groups completed sales into Electronics (491,000), Books (40,000), Clothing (31,000), and Accessories (18,500). Product, customer, category and monthly summaries reconcile to NGN 580,500.

## Experimental design

The eight-order sample is useful for checking correctness but is too small for a meaningful access-path comparison. A separate `p2_benchmark` schema therefore contains 1,000 generated customers and 20,000 generated orders, with twenty orders per customer. This retains the customer-order relationship while leaving all original tables unchanged. The records are fictional and uniformly distributed.

Both phases execute the same query:

```sql
SELECT order_id, order_reference, order_date, status
FROM p2_benchmark.orders
WHERE customer_id = 125
ORDER BY order_date DESC, order_id DESC;
```

Customer 125 matches 20 rows, or 0.1% of the orders. The initial table has primary-key and unique-reference indexes, but neither begins with `customer_id`. The added index is:

```sql
CREATE INDEX idx_orders_customer_date
ON p2_benchmark.orders(customer_id, order_date DESC, order_id DESC);
```

The equality filter uses the leading index column. The remaining columns match the requested ordering, although whether the final plan can avoid a sort depends on the selected access path [2].

The setup collects table statistics with `ANALYZE`. Each phase records five executions after an unrecorded warm-up. Measurements come from PostgreSQL's JSON plan output. Planning and execution times are stored separately. The comparison uses median execution time to reduce the influence of a single unusually slow run. The table data and query text are unchanged between phases; planner settings are not forced.

## Observed measurements

| Metric | Before index | After index |
|---|---:|---:|
| Recorded executions | 5 | 5 |
| Median execution time (ms) | 1.857 | 0.101 |
| Returned rows per execution | 20 | 20 |
| Shared buffer hits per recorded execution | 186 | 22 |
| Shared buffer reads per recorded execution | 0 | 0 |

Execution-time reduction = `100 * (before median - after median) / before median` = **94.56%** for this automated run.

| Run | Before execution (ms) | After execution (ms) |
|---:|---:|---:|
| 1 | 1.655 | 0.070 |
| 2 | 1.857 | 0.342 |
| 3 | 1.778 | 0.101 |
| 4 | 2.408 | 0.143 |
| 5 | 1.912 | 0.096 |

## Plan interpretation

The before plan uses a **sequential scan followed by a sort**. It reads the order table and removes 19,980 non-matching rows. The after plan uses a **bitmap index scan on `idx_orders_customer_date`, a bitmap heap scan, and a sort**. The index identifies the relevant rows and the heap scan visits twenty matching heap blocks. The sort remains because the bitmap access path does not deliver the requested ordering. The measured improvement therefore comes from reducing the rows and blocks inspected, rather than eliminating sorting.

The standalone text plans are separate diagnostic executions. Their elapsed times differ from the five-run medians. The first after-index text plan records two shared-buffer reads; all five recorded after runs show 22 hits and zero reads. These are PostgreSQL buffer counters, not direct measurements of physical disk activity.

The same ordered result digest was recorded for both phases. All ten plans reported twenty returned rows. The validation harness also compared the complete ordered result arrays before and after indexing and checked that the contents of the five Portfolio 1 tables were unchanged.

## Limitations and trade-offs

The measurement demonstrates an access-path improvement for one selective lookup in an embedded PostgreSQL environment. It does not establish the same percentage improvement on a desktop installation or a production server. The dataset has uniform customer activity; real customers may have very different order counts. The experiment uses warm caches, performs the before phase first, and has only five recorded runs per phase. It is not a cold-cache or concurrent-load benchmark.

`EXPLAIN ANALYZE` executes and instruments the query; its timing includes measurement overhead and excludes transfer of result rows to a client [1]. Very short execution times can vary considerably. The buffer and plan changes provide additional evidence beyond elapsed time alone.

The composite index consumes storage and adds maintenance work to inserts, updates and deletes. It benefits lookups beginning with customer ID, but does not replace indexes required by unrelated workloads. For this experiment, indexing preserves the result while reducing work for the selected customer-order query. Further assessment would compare different customer selectivities, larger and less uniform data, and write overhead.

## References

[1] PostgreSQL Global Development Group. PostgreSQL 18 documentation: [Using EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html).

[2] PostgreSQL Global Development Group. PostgreSQL 18 documentation: [Multicolumn Indexes](https://www.postgresql.org/docs/18/indexes-multicolumn.html).

[3] ElectricSQL. [PGlite](https://pglite.dev/), version 0.5.8. Embedded PostgreSQL runtime used for supplementary automated validation.
