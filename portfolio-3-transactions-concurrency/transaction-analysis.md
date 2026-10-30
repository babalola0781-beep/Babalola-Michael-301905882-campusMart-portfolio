# Portfolio 3 transaction analysis

## Environment and scope

The experiment used pgAdmin 4 with PostgreSQL 18.6, database `campusmart_portfolio` and session time zone `Africa/Lagos`. The isolation outputs are dated 30 October 2026. The initial A connection was PID 1140; the later isolation and locking work used A PID 18460 and B PID 25544. The [evidence index](../evidence/portfolio-3/README.md) links all 19 screenshots and their 19 CSV exports to the relevant SQL.

The copied `p3_lab` tables initially held 4 categories, 6 customers, 10 products, 8 orders and 16 order items. `place_order` combines the order, line item and stock deduction in the caller's transaction. Its locking read checks current stock before accepting a request. The [design](transaction-design.md) explains the implementation and its PostgreSQL references.

## COMMIT and ROLLBACK

The committed `CM-P3-COMMIT` order bought two EL002 units. After COMMIT, the output from PID 1140 contained one order and one line item, with stock at 38. The final checks also found that committed order.

| Rollback observation | PID | EL002 stock | Temporary orders | Temporary items |
|---|---:|---:|---:|---:|
| Before ROLLBACK | 18460 | 35 | 1 | 1 |
| After ROLLBACK | 18460 | 38 | 0 | 0 |

Both rollback captures use PID 18460. The before capture shows EL002 stock 35 with one temporary order and item. The after capture shows the explicit ROLLBACK statement and, in the same PID, stock 38 with no temporary order or item. The matching connection identity and rollback command establish that the transaction's temporary changes were reversed.

## Isolation comparison

| Isolation level | Product | A's first read | B's committed value | A's second read | A after ending its transaction |
|---|---|---:|---:|---:|---:|
| Read Committed | EL003 | 25 | 24 | 24 | Not separately captured |
| Repeatable Read | AC002 | 35 | 34 | 35 | 34 |

Both Read Committed reads have PID 18460 and transaction start time `2026-10-30 14:07:47.646561+01`. The second statement saw B's committed stock value, demonstrating a nonrepeatable read within one transaction. This agrees with PostgreSQL's statement-level snapshots at Read Committed [1].

Both Repeatable Read observations have PID 18460 and transaction start time `2026-10-30 14:35:00.04921+01`. Although B committed stock 34, A continued to read 35 from its existing transaction snapshot. The subsequent read has a new transaction start time, `2026-10-30 14:57:26.95503+01`, reports Read Committed and returns 34. This distinguishes snapshot retention from a failed update or a stale result grid [1].

## Competing stock requests

EL001 began with ten units. A's seven-unit request returned `accepted`, with stock changing from 10 to 3. Before A committed, the observer output recorded B PID 25544 as active with `wait_event_type = Lock`, `wait_event = transactionid`, `blocking_pids = {18460}` and `blocked_by_session_a = True`. This identifies a database lock wait caused by A, rather than merely a slow response.

The implementation holds the product row lock until the surrounding transaction ends [2]. After A committed, B acquired the lock and checked the updated stock. Its five-unit request returned `rejected_insufficient_stock`, with stock remaining 3. The final output shows A's order and quantity seven, no B order, and three units remaining. Both requests together would require twelve units; checking stock after the wait prevented the second request from overselling the product.

## Final checks and limitations

All 15 checks in `19-final-checks.csv` returned PASS. The lab ended with ten visible orders and eighteen visible line items. Product stocks were EL001 = 3, EL002 = 38, EL003 = 24 and AC002 = 34. All five original-table row-count and ordered-row-fingerprint comparisons matched their setup baselines.

These checks validate the queried state and support preservation of the original tables. They complement the rollback pair: the matching PID and explicit ROLLBACK statement show that the temporary changes were reversed in that connection.

The experiment uses two connections, a small fictional dataset and one product per order. It does not measure throughput under many customers, multi-product deadlocks, crash recovery or distributed transactions. The locking test demonstrates one controlled waiting and rejection sequence, not reliability under every concurrent schedule.

The main lesson is that result values need connection and transaction context. Matching PIDs and transaction start times support the isolation comparisons; in the rollback test, the matching PID and visible ROLLBACK statement link the before and after results. The stock test also shows the trade-off in holding a lock: the second request waits, but its eventual decision uses stock remaining after the first purchase.

## References

[1] PostgreSQL Global Development Group. [Transaction Isolation](https://www.postgresql.org/docs/18/transaction-iso.html).

[2] PostgreSQL Global Development Group. [Explicit Locking](https://www.postgresql.org/docs/18/explicit-locking.html).
