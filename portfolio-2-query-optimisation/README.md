# Portfolio 2: Query Processing and Optimisation

**Case study:** CampusMart  
**Student:** Michael Olayemi Babalola  
**Course:** MIT 8103 Advanced Database Systems

This activity implements eight business queries and compares a customer-order lookup before and after a composite B-tree index. The business queries use the Portfolio 1 tables. A separate `p2_benchmark` schema contains 1,000 fictional customers and 20,000 orders for the performance experiment.

## Submission materials

- [Technical analysis](performance-analysis.md)
- [SQL scripts](sql/)
- [Query outputs, execution plans and automated validation](../evidence/portfolio-2/README.md)
- [References](references.md)
- [AI-use declaration](../documentation/AI-Use-and-Evidence.md)

## Business queries

| Query | Business purpose | SQL features | Result rows |
|---|---|---|---:|
| [Q01-low-stock](sql/Q01-low-stock.sql) | Low-stock products | Selection and ordering | 2 |
| [Q02-customer-orders](sql/Q02-customer-orders.sql) | Customer order history | Joins and grouped totals | 2 |
| [Q03-all-order-values](sql/Q03-all-order-values.sql) | Order values across all statuses | LEFT JOIN, COALESCE and aggregation | 8 |
| [Q04-product-sales](sql/Q04-product-sales.sql) | Completed sales by product | Joins, filtering and aggregation | 9 |
| [Q05-customers-without-orders](sql/Q05-customers-without-orders.sql) | Customers without orders | Correlated NOT EXISTS | 1 |
| [Q06-monthly-completed-sales](sql/Q06-monthly-completed-sales.sql) | Monthly completed sales | Time-zone-aware grouping and COUNT DISTINCT | 1 |
| [Q07-customer-ranking](sql/Q07-customer-ranking.sql) | Customer spending ranking | CTE and DENSE_RANK | 4 |
| [Q08-category-sales](sql/Q08-category-sales.sql) | Completed sales by category | Four-table join and aggregation | 4 |

Completed sales use `order_items.unit_price`, the price charged at purchase. Draft, placed and cancelled orders are excluded from sales totals. Q03 deliberately includes every order status and therefore reports order values rather than recognised sales.

## Optimisation implementation and testing

The lookup selects customer 125's orders, sorted by date and order ID descending. The index is `idx_orders_customer_date(customer_id, order_date DESC, order_id DESC)`. The experiment retains PostgreSQL's normal planner settings and uses `ANALYZE` statistics, text execution plans and five recorded `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` executions per phase after an unrecorded warm-up.

Automated validation in PGlite 0.5.8 / PostgreSQL 18.3 confirmed all eight query outputs, 20 identical benchmark orders before and after indexing, and unchanged contents of all five original tables. Median execution time changed from 1.857 ms to 0.101 ms in that environment. These measurements describe the automated run; Portfolio 2 desktop pgAdmin evidence is not included in this revision.

[Portfolio overview](../README.md)
