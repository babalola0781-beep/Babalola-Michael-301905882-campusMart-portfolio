# Portfolio 3: Transactions and Concurrency

**Case study:** CampusMart  
**Student:** Michael Olayemi Babalola  
**Course:** MIT 8103 Advanced Database Systems

The implementation covers order placement and stock control using explicit transactions, two isolation levels and row locking. A separate `p3_lab` schema contains copies of the five CampusMart tables. The original `public` tables and the Portfolio 2 benchmark are outside the experiment's write operations.

## Implementation

| Component | Purpose |
|---|---|
| [SQL scripts](sql/) | Session identification, isolated schema, transaction examples, isolation comparisons and locking checks |
| [Transaction design](transaction-design.md) | Atomic order placement, snapshot behaviour, concurrency control and limitations |
| [References](references.md) | Assessment and PostgreSQL sources |
| [AI-use declaration](../documentation/AI-Use-and-Evidence.md) | Assistance acknowledged across the portfolio |

`p3_lab.place_order` locks the selected product with `SELECT ... FOR UPDATE`, checks the remaining stock, and creates an order and item together with the stock deduction. Insufficient stock produces a rejection result without creating an order. The surrounding transaction determines whether an accepted change is committed or rolled back.

## Experimental cases

| Case | SQL files | Verification criterion |
|---|---|---|
| Commit | P3-02 | Order, item and stock deduction persist after COMMIT |
| Rollback | P3-03 to P3-04 | The temporary order and item disappear and stock returns to its preceding value |
| Read Committed | P3-06 to P3-08 | Two reads in one transaction can observe a committed update from the other session |
| Repeatable Read | P3-09 to P3-12 | The same transaction retains its snapshot; a read after COMMIT sees the newer value |
| Row locking | P3-13 to P3-17 | The competing request waits, then checks stock after the first transaction commits |
| Integrity | P3-18 | Scenario invariants and original-table row counts and fingerprints match their comparisons |

The SQL exposes session PIDs, isolation levels, transaction start times, blocking relationships and final state. These identify the transactions involved and distinguish a live lock wait from a connection or execution error. Runtime evidence is recorded separately from the implementation design.

[Portfolio overview](../README.md)
