# Portfolio 2 execution evidence

These files record an automated execution in **PGlite 0.5.8 / PostgreSQL 18.3**, independent of desktop pgAdmin. They contain actual query outputs and measured plans from that execution. Desktop screenshots for Portfolio 2 are not part of this revision.

All eight business queries passed their expected-result checks. The complete benchmark result was identical before and after indexing, and every original table retained its initial contents. The validation JSON contains environment details, source-file SHA-256 checksums, results and checks.

## Evidence files

- [P2-00-environment.csv](P2-00-environment.csv)
- [P2-01-benchmark-setup.csv](P2-01-benchmark-setup.csv)
- [P2-02-plan-before.txt](P2-02-plan-before.txt)
- [P2-03-measure-before.csv](P2-03-measure-before.csv)
- [P2-04-create-index.csv](P2-04-create-index.csv)
- [P2-05-plan-after.txt](P2-05-plan-after.txt)
- [P2-06-measure-after.csv](P2-06-measure-after.csv)
- [P2-07-comparison.csv](P2-07-comparison.csv)
- [P2-08-result-check.csv](P2-08-result-check.csv)
- [P2-09-all-runs.csv](P2-09-all-runs.csv)
- [Q01-low-stock.csv](Q01-low-stock.csv)
- [Q02-customer-orders.csv](Q02-customer-orders.csv)
- [Q03-all-order-values.csv](Q03-all-order-values.csv)
- [Q04-product-sales.csv](Q04-product-sales.csv)
- [Q05-customers-without-orders.csv](Q05-customers-without-orders.csv)
- [Q06-monthly-completed-sales.csv](Q06-monthly-completed-sales.csv)
- [Q07-customer-ranking.csv](Q07-customer-ranking.csv)
- [Q08-category-sales.csv](Q08-category-sales.csv)
- [benchmark-query-result.csv](benchmark-query-result.csv)
- [execution-plans.json](execution-plans.json)
- [validation-results.json](validation-results.json)

The text plans are individual diagnostic executions. Median comparisons use the five recorded executions per phase in `P2-09-all-runs.csv`. A digest is calculated once per phase; `phase_results_match` compares these digests. `twenty_rows_each_run` checks the actual-row counts in all ten measured plans.

[Performance analysis](../../portfolio-2-query-optimisation/performance-analysis.md) · [SQL](../../portfolio-2-query-optimisation/sql/)
