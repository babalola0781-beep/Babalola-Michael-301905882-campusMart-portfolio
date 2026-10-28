# Portfolio 2 execution plans

The before-index plan uses a sequential scan and sort. The after-index plan uses a bitmap index scan on `idx_orders_customer_date`, a bitmap heap scan and a sort. The two standalone plans are exported from pgAdmin as CSV with a `QUERY PLAN` column.

- [Before-index plan](11-plan-before.csv)
- [After-index plan](14-plan-after.csv)
- [JSON plans for all ten recorded runs](19-json-plans.csv)

The standalone execution times are 1.633 ms and 0.142 ms. The five-run medians are 1.630 ms and 0.095 ms, calculated from the repeated measurements.

[Evidence index](../README.md) · [Performance analysis](../../../portfolio-2-query-optimisation/performance-analysis.md)
