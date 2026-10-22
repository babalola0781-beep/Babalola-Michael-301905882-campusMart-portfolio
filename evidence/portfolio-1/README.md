# Portfolio 1 Execution Evidence

## Desktop execution

The [seven pgAdmin screenshots](screenshots/README.md) document my execution on `campusmart_portfolio`. The server-version query reports PostgreSQL 18.6.

The row-count queries show 4 categories, 6 customers, 10 products, 8 orders and 16 order items both before and after the checks. All 12 constraint tests show PASS. The order-value and price screenshots show that historical amounts use the charged unit price.

## Supplementary validation

The following files retain the earlier automated validation from 6 October 2026 in PGlite 0.5.8, reporting embedded PostgreSQL 18.3. They are supplementary results from a separate environment; the screenshots above are the evidence of my desktop execution.

| File | Recorded content |
|---|---|
| [validation-results.json](validation-results.json) | Engine metadata, results and error messages |
| [execution-log.txt](execution-log.txt) | Captured output from the automated validation |
| [row-counts.csv](row-counts.csv) | Five actual and expected counts |
| [order-values.csv](order-values.csv) | Eight order values and statuses |
| [constraint-checks.csv](constraint-checks.csv) | Twelve constraint-test results |

The automated run also checked the repeated-seed guard and absence of empty placed or completed orders. Those additional checks are not separately demonstrated by the seven desktop screenshots.
