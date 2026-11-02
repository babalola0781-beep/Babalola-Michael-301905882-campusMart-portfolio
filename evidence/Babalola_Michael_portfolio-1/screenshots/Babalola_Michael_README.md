# Portfolio 1 PostgreSQL screenshots

I captured these seven screenshots from my PostgreSQL execution in pgAdmin 4. The database is `campusmart_portfolio`; the server-version query reports `18.6`.

| Screenshot | Evidence | Observation |
|---|---|---|
| [01-database-tables.png](Babalola_Michael_01-database-tables.png) | Five public tables | The object browser lists categories, customers, order_items, orders and products. |
| [02-row-counts.png](Babalola_Michael_02-row-counts.png) | Initial row counts | All five actual counts match the expected seed counts. |
| [03-constraint-results.png](Babalola_Michael_03-constraint-results.png) | Constraint checks | All 12 tests show PASS, with expected and actual SQLSTATE values. |
| [04-server-version.png](Babalola_Michael_04-server-version.png) | Database and server | campusmart_portfolio; server_version 18.6; pgAdmin 4 interface. |
| [05-order-values.png](Babalola_Michael_05-order-values.png) | Order values | Eight order values are displayed with customer names and order statuses. |
| [06-historical-price.png](Babalola_Michael_06-historical-price.png) | Historical price | CM-1005 / BK001: current price NGN 18,000; charged price NGN 16,000. |
| [07-counts-after-checks.png](Babalola_Michael_07-counts-after-checks.png) | Counts after testing | The same five counts remain after the constraint checks. |
