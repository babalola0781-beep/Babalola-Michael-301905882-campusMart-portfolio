# Portfolio 3 execution evidence

These 19 pgAdmin 4 screenshots and 19 CSV exports record the CampusMart transaction experiment in PostgreSQL 18.6, database `campusmart_portfolio`, with session time zone `Africa/Lagos`. The isolation outputs are dated 30 October 2026. The screenshots and exports are retained as captured.

## Results and evidence scope

The committed order and item remain with EL002 stock 38. Read Committed changes A's read from 25 to 24 after B's update; Repeatable Read retains 35 until A ends its transaction, after which it reads 34. The lock observer identifies B (25544) waiting for A (18460). A's seven-unit purchase succeeds, and B's five-unit request is rejected when only three units remain. All 15 final-state checks return PASS.

The rollback outputs use different PIDs: 1140 before and 18460 after. The later connection sees stock 38 and no temporary order or item, but cannot establish that an explicit ROLLBACK ended the original transaction. This limitation is included in the [transaction analysis](../../portfolio-3-transactions-concurrency/transaction-analysis.md).

## Evidence index

| Evidence and observation | SQL | Screenshot | Export |
|---|---|---|---|
| 01-session-a: PostgreSQL 18.6, PID 1140, Africa/Lagos. | [P3-00-session-a.sql](../../portfolio-3-transactions-concurrency/sql/P3-00-session-a.sql) | [PNG](screenshots/01-session-a.png) | [CSV](results/01-session-a.csv) |
| 02-lab-setup: Five copied tables: 4 categories, 6 customers, 10 products, 8 orders and 16 items. | [P3-01-setup.sql](../../portfolio-3-transactions-concurrency/sql/P3-01-setup.sql) | [PNG](screenshots/02-lab-setup.png) | [CSV](results/02-lab-setup.csv) |
| 03-commit: EL002 stock 38, one committed order and item, PID 1140. | [P3-02-commit.sql](../../portfolio-3-transactions-concurrency/sql/P3-02-commit.sql) | [PNG](screenshots/03-commit.png) | [CSV](results/03-commit.csv) |
| 04-before-rollback: EL002 stock 35, one temporary order and item, PID 1140. | [P3-03-rollback-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-03-rollback-start.sql) | [PNG](screenshots/04-before-rollback.png) | [CSV](results/04-before-rollback.csv) |
| 05-after-rollback: EL002 stock 38, no temporary order or item, different PID 18460. | [P3-04-rollback-end.sql](../../portfolio-3-transactions-concurrency/sql/P3-04-rollback-end.sql) | [PNG](screenshots/05-after-rollback.png) | [CSV](results/05-after-rollback.csv) |
| 06-session-b: PostgreSQL 18.6, Session B PID 25544. | [P3-05-session-b.sql](../../portfolio-3-transactions-concurrency/sql/P3-05-session-b.sql) | [PNG](screenshots/06-session-b.png) | [CSV](results/06-session-b.csv) |
| 07-read-committed-first: A reads EL003 stock 25 at Read Committed. | [P3-06-read-committed-a-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-06-read-committed-a-start.sql) | [PNG](screenshots/07-read-committed-first.png) | [CSV](results/07-read-committed-first.csv) |
| 08-read-committed-writer: B commits EL003 stock 24. | [P3-07-read-committed-b-update.sql](../../portfolio-3-transactions-concurrency/sql/P3-07-read-committed-b-update.sql) | [PNG](screenshots/08-read-committed-writer.png) | [CSV](results/08-read-committed-writer.csv) |
| 09-read-committed-second: A reads 24 in the same Read Committed transaction. | [P3-08-read-committed-a-read.sql](../../portfolio-3-transactions-concurrency/sql/P3-08-read-committed-a-read.sql) | [PNG](screenshots/09-read-committed-second.png) | [CSV](results/09-read-committed-second.csv) |
| 10-repeatable-read-first: A reads AC002 stock 35 at Repeatable Read. | [P3-09-repeatable-read-a-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-09-repeatable-read-a-start.sql) | [PNG](screenshots/10-repeatable-read-first.png) | [CSV](results/10-repeatable-read-first.csv) |
| 11-repeatable-read-writer: B commits AC002 stock 34. | [P3-10-repeatable-read-b-update.sql](../../portfolio-3-transactions-concurrency/sql/P3-10-repeatable-read-b-update.sql) | [PNG](screenshots/11-repeatable-read-writer.png) | [CSV](results/11-repeatable-read-writer.csv) |
| 12-repeatable-read-second: A still reads 35 in the same Repeatable Read transaction. | [P3-11-repeatable-read-a-read.sql](../../portfolio-3-transactions-concurrency/sql/P3-11-repeatable-read-a-read.sql) | [PNG](screenshots/12-repeatable-read-second.png) | [CSV](results/12-repeatable-read-second.csv) |
| 13-repeatable-read-new-transaction: After COMMIT, A reads 34 in a new transaction. | [P3-12-repeatable-read-a-end.sql](../../portfolio-3-transactions-concurrency/sql/P3-12-repeatable-read-a-end.sql) | [PNG](screenshots/13-repeatable-read-new-transaction.png) | [CSV](results/13-repeatable-read-new-transaction.csv) |
| 14-lock-session-a: A's seven-unit request is accepted; stock changes from 10 to 3. | [P3-13-lock-a-start.sql](../../portfolio-3-transactions-concurrency/sql/P3-13-lock-a-start.sql) | [PNG](screenshots/14-lock-session-a.png) | [CSV](results/14-lock-session-a.csv) |
| 15-blocking: B PID 25544 waits on a transactionid lock; A PID 18460 is the blocker. | [P3-15-observe-blocking.sql](../../portfolio-3-transactions-concurrency/sql/P3-15-observe-blocking.sql) | [PNG](screenshots/15-blocking.png) | [CSV](results/15-blocking.csv) |
| 16-lock-a-commit: A commits its order and item; EL001 stock is 3. | [P3-16-lock-a-commit.sql](../../portfolio-3-transactions-concurrency/sql/P3-16-lock-a-commit.sql) | [PNG](screenshots/16-lock-a-commit.png) | [CSV](results/16-lock-a-commit.csv) |
| 17-lock-b-result: B's five-unit request is rejected for insufficient stock; stock stays 3. | [P3-14-lock-b-request.sql](../../portfolio-3-transactions-concurrency/sql/P3-14-lock-b-request.sql) | [PNG](screenshots/17-lock-b-result.png) | [CSV](results/17-lock-b-result.csv) |
| 18-lock-final-state: A's order exists with quantity seven; B's order is absent; stock is 3. | [P3-17-lock-b-end.sql](../../portfolio-3-transactions-concurrency/sql/P3-17-lock-b-end.sql) | [PNG](screenshots/18-lock-final-state.png) | [CSV](results/18-lock-final-state.csv) |
| 19-final-checks: All 15 state checks return PASS, including original-table fingerprints. | [P3-18-final-checks.sql](../../portfolio-3-transactions-concurrency/sql/P3-18-final-checks.sql) | [PNG](screenshots/19-final-checks.png) | [CSV](results/19-final-checks.csv) |

The matching PIDs and transaction start times support each isolation comparison. Final-state checks cover visible rows and original-table fingerprints; they do not independently validate the rollback transaction boundary.

[Portfolio 3](../../portfolio-3-transactions-concurrency/README.md) · [Observations](../../portfolio-3-transactions-concurrency/observations.txt)
