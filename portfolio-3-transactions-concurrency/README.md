# Portfolio 3: Transactions and Concurrency

**Case study:** CampusMart  
**Student:** Michael Olayemi Babalola  
**Course:** MIT 8103 Advanced Database Systems

This portfolio examines order placement and stock control using explicit transactions, Read Committed, Repeatable Read and row locking. The desktop evidence was captured in pgAdmin 4 against PostgreSQL 18.6 on 30 October 2026. A separate p3_lab schema contains copies of the five CampusMart tables.

## Submission material

| Material | File |
|---|---|
| Implementation | [Transaction and concurrency SQL](sql/) |
| Design and trade-offs | [Transaction design](transaction-design.md) |
| Results and interpretation | [Transaction analysis](transaction-analysis.md) |
| Short observations | [Observations](observations.txt) |
| Desktop evidence | [19 screenshots and 19 CSV exports](../evidence/portfolio-3/README.md) |
| Sources | [References](references.md) |
| AI use | [Declaration](../documentation/AI-Use-and-Evidence.md) |

## Recorded results

| Case | Observation |
|---|---|
| COMMIT | The order and item remained; EL002 stock was 38. |
| ROLLBACK | In PID 18460, EL002 stock was 35 with one temporary order and item before ROLLBACK; afterward, stock was 38 and neither temporary row remained. |
| Read Committed | A read EL003 stock as 25 and then 24 after B's committed update, within the same reader transaction. |
| Repeatable Read | A read AC002 stock as 35 twice, although B committed 34. A new transaction then read 34. |
| Row locking | B (25544) waited for A (18460). A bought seven of ten EL001 units. B's request for five was rejected after A committed, leaving three units and no B order. |
| Final state | All 15 state checks returned PASS, including the original-table count and fingerprint comparisons. |

The results support the commit, rollback, isolation and locking demonstrations. The before and after rollback outputs share PID 18460, and the after output shows the explicit ROLLBACK statement.

[Portfolio overview](../README.md)
