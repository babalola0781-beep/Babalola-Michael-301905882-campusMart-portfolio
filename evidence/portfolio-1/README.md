# Portfolio 1 — Recorded validation evidence

**Executed:** 2026-10-06T20:08:17.987Z  
**Environment:** embedded PostgreSQL 18.3 through PGlite 0.5.8  
**Source:** actual assistant-run execution of the four supplied SQL scripts

These outputs were recorded by executing the submitted SQL. They are not sample
values, a mock pgAdmin screen or a claim about the student's desktop run.

| Evidence | Content |
|---|---|
| [validation-results.json](validation-results.json) | Full run metadata, results, constraints and actual error messages |
| [execution-log.txt](execution-log.txt) | Captured console output from this validation run |
| [row-counts.csv](row-counts.csv) | Five actual versus expected counts |
| [order-values.csv](order-values.csv) | Eight calculated order values and statuses |
| [constraint-checks.csv](constraint-checks.csv) | Twelve invalid-operation checks and rejection details |
| [screenshots/](screenshots/README.md) | Student's own database screenshots: awaiting upload |

## Results

- Schema creation and sample-data insertion succeeded.
- All five row-count comparisons passed.
- All eight order values matched the expected calculations.
- For CM-1005 / BK001, charged price remained 16000.00 while current price was 18000.00.
- No seeded placed/completed order lacked items.
- All twelve invalid operations were rejected for their intended reasons.
- Permanent row counts stayed unchanged after the test transaction rolled back.
- A second seed-data load was rejected as intended.

## Reproduce

Run the four numbered SQL files on a fresh PostgreSQL database as described in
[Portfolio 1](../../portfolio-1-database-design/README.md). Save Query Tool result
exports and screenshots. The test engine here has one connection and this stage
does not claim to verify multi-user concurrency or the student's installation.
