# MIT 8103 Advanced Database Systems Portfolio

**Michael Olayemi Babalola**  
**Academic session:** 2026/2027, First Semester  
**Case study:** CampusMart, a simulated Nigerian online retail business

This repository contains the five MIT 8103 portfolio activities using CampusMart as a consistent case study. Portfolios 1 to 3 contain database design, SQL implementation, query optimisation and transaction analysis, with evidence from my PostgreSQL 18.6 execution in pgAdmin 4.

## Portfolio overview

| Portfolio | Activity | Marks | Progress |
|---|---|---:|---|
| [Portfolio 1](portfolio-1-database-design/) | Database Design and Modelling | 7 | Complete |
| [Portfolio 2](portfolio-2-query-optimisation/) | Query Processing and Optimisation | 7 | Complete |
| [Portfolio 3](portfolio-3-transactions-concurrency/) | Transactions and Concurrency | 7 | Evidence recorded; rollback verification limited |
| [Portfolio 4](portfolio-4-nosql/) | NoSQL and Advanced Data Models | 7 | Planned |
| [Portfolio 5](portfolio-5-distributed-cloud/) | Distributed and Cloud Database Exercise | 6 | Planned |

Final documentation and technical reflection carry a further 6 marks, bringing the assessment total to 40. The final LMS summary covers all five activities.

## Portfolio 1 Database Design and Modelling

| Submission material | File |
|---|---|
| Technical report | [PDF](portfolio-1-database-design/documentation/Portfolio-1-Report.pdf) · [Word](portfolio-1-database-design/documentation/Portfolio-1-Report.docx) · [Markdown](portfolio-1-database-design/documentation/Portfolio-1-Report.md) |
| Implementation and results | [Portfolio 1](portfolio-1-database-design/README.md) |
| Case study and business rules | [Case study](portfolio-1-database-design/case-study.md) |
| Entity relationship diagram | [ER diagram](portfolio-1-database-design/diagrams/campusmart-erd.png) |
| Relational schema | [Data dictionary](portfolio-1-database-design/data-dictionary.md) |
| Functional dependencies | [Normalisation](portfolio-1-database-design/normalisation.md) |
| Execution evidence | [Seven pgAdmin screenshots](evidence/portfolio-1/screenshots/README.md) |
| Reflection | [Technical reflection](portfolio-1-database-design/documentation/Technical-Reflection.md) |
| Sources | [References](portfolio-1-database-design/references.md) |
| AI use | [Declaration](documentation/AI-Use-and-Evidence.md) |

## Verified results

The database contains 6 customers, 4 categories, 10 products, 8 orders and 16 order items. All 12 constraint tests passed. Row counts after testing match the initial counts. The textbook in order CM-1005 retains its charged price of NGN 16,000 while the current product price is NGN 18,000.

The database name and reported server version are `campusmart_portfolio` and PostgreSQL `18.6`, as shown in the server-version screenshot. All case-study records are fictional and monetary values are in Nigerian naira.

## Portfolio 2 Query Processing and Optimisation

Portfolio 2 contains [eight business queries and the indexing experiment](portfolio-2-query-optimisation/README.md), [performance analysis](portfolio-2-query-optimisation/performance-analysis.md), and [17 desktop screenshots and 19 CSV exports](evidence/portfolio-2/README.md). The PostgreSQL 18.6 experiment changed the sequential scan to bitmap index and heap scans. Median execution time decreased from 1.630 ms to 0.095 ms, a 94.17% reduction across five recorded runs per phase. Matching phase digests and twenty rows in every run support result consistency.

## Portfolio 3 Transactions and Concurrency

Portfolio 3 contains [transaction and concurrency SQL](portfolio-3-transactions-concurrency/README.md), the [implementation design](portfolio-3-transactions-concurrency/transaction-design.md), [transaction analysis](portfolio-3-transactions-concurrency/transaction-analysis.md), and [19 desktop screenshots and 19 CSV exports](evidence/portfolio-3/README.md). The evidence records a committed order, contrasting Read Committed and Repeatable Read observations, and a blocked stock request that is rejected after the first purchase commits. All 15 final-state checks pass. The rollback observations use different session PIDs, so they do not yet verify an explicit rollback in the original connection.

Portfolios 4 and 5 retain their own directories for the remaining assessment activities.
