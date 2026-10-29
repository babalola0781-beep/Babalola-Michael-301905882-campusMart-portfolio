# CampusMart transaction and concurrency design

## Scope

The experiment extends the CampusMart order and inventory case study. It uses the same five-table model in the separate `p3_lab` schema. `LIKE ... INCLUDING ALL` copies column definitions, check constraints, indexes and identity definitions. Foreign keys are explicitly recreated between the copied tables, and the copied identity sequences are advanced to the copied maximum keys. No experimental order is inserted into the original tables.

The setup records row counts and ordered JSON row fingerprints for the original tables. The fingerprint function fixes the time zone to UTC so timestamp formatting is consistent across sessions. The final comparison covers stored row values as well as counts; an MD5 fingerprint is a practical regression check, not a cryptographic proof or a check of every database object.

## Atomic order placement

`p3_lab.place_order(reference, email, sku, quantity)` validates the request and identifies a customer. It obtains a row lock on the selected product, reads the stock and price, and rejects a quantity above available stock. An accepted request inserts an order, inserts its line item with the current charged price, and decreases stock within the caller's transaction.

`COMMIT` makes the accepted order, item and stock change durable under the server's configured durability settings. `ROLLBACK` cancels those row changes [1]. Identity sequence values can still advance after a rollback, so gaps in order IDs are not treated as failed rollback evidence [2]. The examples compare business references and row values instead of assuming consecutive IDs.

## Isolation comparison

The Read Committed case reads product EL003 in Session A, commits a stock update in Session B and reads the same product again in A's open transaction. PostgreSQL uses a new statement snapshot for the second read, so the design permits a nonrepeatable read [2]. Session PID, isolation level and transaction start time identify the reader's transaction.

The Repeatable Read case uses product AC002. A's first read establishes its transaction snapshot. B then commits a stock change. A's second read uses the earlier snapshot; the read after A commits uses a new snapshot [2]. This is a snapshot demonstration, not evidence that Repeatable Read prevents every possible concurrent anomaly.

## Competing stock requests

The row-lock case uses product EL001 with an initial copied stock of ten. Session A requests seven units and leaves its transaction open. Session B requests five units through the same function. `SELECT ... FOR UPDATE` prevents B from acquiring the conflicting product lock until A's transaction ends [3].

The observer query in A uses `pg_blocking_pids` and `pg_stat_activity` to expose B's wait and identify A as a blocker [4]. After A commits, B's Read Committed locking read obtains the updated row. The function then evaluates the available stock and can reject the second request without creating its order. The 180-second lock timeout bounds an accidentally abandoned wait; an idle transaction is limited to fifteen minutes.

The numeric starting values define the experimental inputs and expected comparisons. They are not a record of desktop execution. The SQL result grids and screenshots provide that record.

## Trade-offs and limitations

The function handles one product per order. A multi-product workflow would need a consistent lock order to reduce deadlock risk, along with retry handling for deadlocks and serialization failures. Long transactions reduce concurrency because competing writers wait. Ordinary non-locking reads can still see committed versions while a writer holds a row lock [3].

Only two sessions and a small fictional dataset are covered. The experiment does not measure throughput under load, crash recovery, distributed transactions or serializable anomaly detection. The business rule is enforced through this function; other direct write paths would require appropriate application design and database permissions.

## References

[1] PostgreSQL Global Development Group. [Transactions](https://www.postgresql.org/docs/18/tutorial-transactions.html).

[2] PostgreSQL Global Development Group. [Transaction Isolation](https://www.postgresql.org/docs/18/transaction-iso.html).

[3] PostgreSQL Global Development Group. [Explicit Locking](https://www.postgresql.org/docs/18/explicit-locking.html).

[4] PostgreSQL Global Development Group. [System Information Functions](https://www.postgresql.org/docs/18/functions-info.html).
