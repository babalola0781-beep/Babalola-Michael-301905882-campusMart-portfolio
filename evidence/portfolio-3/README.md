# Portfolio 3 execution evidence


These 19 pgAdmin 4 screenshots and 19 CSV exports record the CampusMart transaction experiment in PostgreSQL 18.6, database `campusmart_portfolio`, with session time zone `Africa/Lagos`. The isolation outputs are dated 30 October 2026. The screenshots and exports are retained as captured.


## Results and evidence scope


The committed order and item remain with EL002 stock 38. Read Committed changes A's read from 25 to 24 after B's update; Repeatable Read retains 35 until A ends its transaction, after which it reads 34. The lock observer identifies B (25544) waiting for A (18460). A's seven-unit purchase succeeds, and B's five-unit request is rejected when only three units remain. All 15 final-state checks return PASS.


The rollback outputs use the same PID, 18460. Before `ROLLBACK`, EL002 has stock 35 with one temporary order and item; afterward, stock is 38 and neither temporary row remains. The before and after outputs therefore document the rollback in the same PostgreSQL session.


## Evidence index


| Evidence and observation | SQL | Screenshot | Export |
|---|---|---|---|
| 01-session-a: PostgreSQL 18.6, PID 1140, Africa/Lagos. | [P3-00-session-a.sql](../../portfolio-3-transactions-concurrency/sql/P3-00-session-a.sql) | [PNG](screenshots/01-session-a.png) | [CSV](results/01-session-a.csv) |
| 02-lab-setup: Five copied tables: 4 categories, 6 customers, 10 products, 8 orders and 16 items. | [P3-01-setup.sql](../../portfolio-3-transactions-concurrency/sql/P3-01-setup.sql) | [PNG](screenshots/02-lab-setup.png) | [CSV](results/02-lab-setup.csv) |
| 03-commit: EL002 stock 38, one committed order and item, PID 1140. | [P3-02-commit.sql](../../portfolio-3-transactions-concurrency/sql/P3-02-commit.sql) | [PNG](screenshots/03-commit.png) | [CSV](results/03-commit.csv) |
| 04-before-rollback: EL002 stock 35, one temporary order and item, PID 18460. | [P3-03-rollback-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-03-rollback-start.sql) | [PNG](screenshots/04-before-rollback.png) | [CSV](results/04-before-rollback.csv) |
| 05-after-rollback: EL002 stock 38, no temporary order or item, PID 18460 after explicit `ROLLBACK`. | [P3-04-rollback-end.sql](../../portfolio-3-transactions-concurrency/sql/P3-04-rollback-end.sql) | [PNG](screenshots/05-after-rollback.png) | [CSV](results/05-after-rollback.csv) |
| 06-session-b: PostgreSQL 18.6, Session B PID 25544. | [P3-05-session-b.sql](../../portfolio-3-transactions-concurrency/sql/P3-05-session-b.sql) | [PNG](screenshots/06-session-b.png) | [CSV](results/06-session-b.csv) |
| 07-read-committed-first: A reads EL003 stock 25 at Read Committed. | [P3-06-read-committed-a-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-06-read-committed-a-start.sql) | [PNG](screenshots/07-read-committed-first.png) | [CSV](results/07-read-committed-first.csv) |
| 08-read-committed-writer: B commits EL003 stock 24. | [P3-07-read-committed-b-update.sql](../../portfolio-3-transactions-concurrency/sql/P3-07-read-committed-b-update.sql) | [PNG](screenshots/08-read-committed-writer.png) | [CSV](results/08-read-committed-writer.csv) |
| 09-read-committed-second: A reads 24 in the same Read Committed transaction. | [P3-08-read-committed-a-read.sql](../../portfolio-3-transactions-concurrency/sql/P3-08-read-committed-a-read.sql) | [PNG](screenshots/09-read-committed-second.png) | [CSV](results/09-read-committed-second.csv) |
| 10-repeatable-read-first: A reads AC002 stock 35 at Repeatable Read. | [P3-09-repeatable-read-a-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-09-repeatable-read-a-start.sql) | [PNG](screenshots/10-repeatable-read-first.png) | [CSV](results/10-repeatable-read-first.csv) |
| 11-repeatable-read-writer: B commits AC002 stock 34. | [P3-10-repeatable-read-b-update.sql](../../portfolio-3-transactions-concurrency/sql/P3-10-repeatable-read-b-update.sql) | [PNG](screenshots/11-repeatable-read-writer.png) | [CSV](results/11-repeatable-read-writer.csv) |
| 12-repeatable-read-second: A still reads 35 in the same Repeatable Read transaction. | [P3-11-repeatable-read-a-read.sql](../../portfolio-3-transactions-concurrency/sql/P3-11-repeatable-read-a-read.sql) | [PNG](screenshots/12-repeatable-read-second.png) | [CSV](results/12-repeatable-read-second.csv) |
