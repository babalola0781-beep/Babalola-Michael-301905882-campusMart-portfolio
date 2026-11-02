# Portfolio 2 Query Processing and Optimisation

**Case study:** CampusMart  
**Student:** Michael Olayemi Babalola  
**Course:** MIT 8103 Advanced Database Systems

This activity implements eight business queries and compares a customer-order lookup before and after a composite B-tree index. The business queries use the Portfolio 1 tables. A separate `p2_benchmark` schema contains 1,000 fictional customers and 20,000 orders for the performance experiment.

## Submission materials

- [Technical analysis](Babalola_Michael_performance-analysis.md)
- [SQL scripts](sql)
- [Desktop screenshots, query outputs and execution plans](../evidence/Babalola_Michael_portfolio-2/Babalola_Michael_README.md)
- [References](Babalola_Michael_references.md)
- [AI-use declaration](../documentation/Babalola_Michael_AI-Use-and-Evidence.md)

## Business queries

| Query | Business purpose | SQL features | Result rows |
|---|---|---|---:|
| [Q01-low-stock](sql/Babalola_Michael_Q01-low-stock.sql) | Low-stock products | Selection and ordering | 2 |
| [Q02-customer-orders](sql/Babalola_Michael_Q02-customer-orders.sql) | Customer order history | Joins and grouped totals | 2 |
| [Q03-all-order-values](sql/Babalola_Michael_Q03-all-order-values.sql) | Order values across all statuses | LEFT JOIN, COALESCE and aggregation | 8 |
| [Q04-product-sales](sql/Babalola_Michael_Q04-product-sales.sql) | Completed sales by product | Joins, filtering and aggregation | 9 |
| [Q05-customers-without-orders](sql/Babalola_Michael_Q05-customers-without-orders.sql) | Customers without orders | Correlated NOT EXISTS | 1 |
| [Q06-monthly-completed-sales](sql/Babalola_Michael_Q06-monthly-completed-sales.sql) | Monthly completed sales | Time-zone-aware grouping and COUNT DISTINCT | 1 |
| [Q07-customer-ranking](sql/Babalola_Michael_Q07-customer-ranking.sql) | Customer spending ranking | CTE and DENSE_RANK | 4 |
| [Q08-category-sales](sql/Babalola_Michael_Q08-category-sales.sql) | Completed sales by category | Four-table join and aggregation | 4 |

Completed sales use `order_items.unit_price`, the price charged at purchase. Draft, placed and cancelled orders are excluded from sales totals. Q03 deliberately includes every order status and therefore reports order values rather than recognised sales.

## Optimisation implementation and testing

The lookup selects customer 125's orders, sorted by date and order ID descending. The index is `idx_orders_customer_date(customer_id, order_date DESC, order_id DESC)`. The experiment retains PostgreSQL's normal planner settings and uses `ANALYZE` statistics, text execution plans and five recorded `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` executions per phase after an unrecorded warm-up.

I executed the queries and indexing experiment in PostgreSQL 18.6 using pgAdmin 4. The submitted desktop evidence includes 17 screenshots and 19 CSV exports. The sequential scan changed to a bitmap index scan and bitmap heap scan, with a sort in both plans. Median execution time fell from **1.630 ms to 0.095 ms**, a **94.17% reduction** across five recorded runs per phase.

The result checks show matching phase digests, twenty rows in every measured run and unchanged original table counts. The performance analysis discusses the warm-cache, single-query experiment and the index's storage and write costs.

[Portfolio overview](../README.md)
