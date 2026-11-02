# MIT 8103 Advanced Database Systems Portfolio

**Michael Olayemi Babalola**  
**Academic session:** 2026/2027, First Semester  
**Case study:** CampusMart, a simulated Nigerian online retail business

This repository contains the five MIT 8103 portfolio activities using CampusMart as a consistent case study. Portfolios 1 to 3 cover database design, SQL implementation, query optimisation and transaction analysis, with evidence from my PostgreSQL 18.6 execution in pgAdmin 4. Portfolio 4 documents a MongoDB NoSQL model, and Portfolio 5 records a distributed MongoDB replica-set exercise, with their implementation and execution evidence.

## Portfolio overview

| Portfolio | Activity | Marks | Progress |
|---|---|---:|---|
| [Portfolio 1](Babalola_Michael_portfolio-1-database-design) | Database Design and Modelling | 7 | Complete |
| [Portfolio 2](Babalola_Michael_portfolio-2-query-optimisation) | Query Processing and Optimisation | 7 | Complete |
| [Portfolio 3](Babalola_Michael_portfolio-3-transactions-concurrency) | Transactions and Concurrency | 7 | Complete |
| [Portfolio 4](Babalola_Michael_portfolio-4-nosql) | NoSQL and Advanced Data Models | 7 | Complete |
| [Portfolio 5](Babalola_Michael_portfolio-5-distributed-cloud) | Distributed and Cloud Database Exercise | 6 | Complete |

Final documentation and technical reflection carry a further 6 marks, bringing the assessment total to 40. The final LMS summary covers all five activities.

## Portfolio 1 Database Design and Modelling

| Submission material | File |
|---|---|
| Technical report | [Markdown](Babalola_Michael_portfolio-1-database-design/documentation/Babalola_Michael_Portfolio-1-Report.md) |
| Implementation and results | [Portfolio 1](Babalola_Michael_portfolio-1-database-design/Babalola_Michael_README.md) |
| Case study and business rules | [Case study](Babalola_Michael_portfolio-1-database-design/Babalola_Michael_case-study.md) |
| Entity relationship diagram | [ER diagram](Babalola_Michael_portfolio-1-database-design/diagrams/Babalola_Michael_campusmart-erd.png) |
| Relational schema | [Data dictionary](Babalola_Michael_portfolio-1-database-design/Babalola_Michael_data-dictionary.md) |
| Functional dependencies | [Normalisation](Babalola_Michael_portfolio-1-database-design/Babalola_Michael_normalisation.md) |
| Execution evidence | [Seven pgAdmin screenshots](evidence/Babalola_Michael_portfolio-1/screenshots/Babalola_Michael_README.md) |
| Reflection | [Technical reflection](Babalola_Michael_portfolio-1-database-design/documentation/Babalola_Michael_Technical-Reflection.md) |
| Sources | [References](Babalola_Michael_portfolio-1-database-design/Babalola_Michael_references.md) |
| AI use | [Declaration](documentation/Babalola_Michael_AI-Use-and-Evidence.md) |

## Verified results

The database contains 6 customers, 4 categories, 10 products, 8 orders and 16 order items. All 12 constraint tests passed. Row counts after testing match the initial counts. The textbook in order CM-1005 retains its charged price of NGN 16,000 while the current product price is NGN 18,000.

The database name and reported server version are `campusmart_portfolio` and PostgreSQL `18.6`, as shown in the server-version screenshot. All case-study records are fictional and monetary values are in Nigerian naira.

## Portfolio 2 Query Processing and Optimisation

Portfolio 2 contains [eight business queries and the indexing experiment](Babalola_Michael_portfolio-2-query-optimisation/Babalola_Michael_README.md), [performance analysis](Babalola_Michael_portfolio-2-query-optimisation/Babalola_Michael_performance-analysis.md), and [17 desktop screenshots and 19 CSV exports](evidence/Babalola_Michael_portfolio-2/Babalola_Michael_README.md). The PostgreSQL 18.6 experiment changed the sequential scan to bitmap index and heap scans. Median execution time decreased from 1.630 ms to 0.095 ms, a 94.17% reduction across five recorded runs per phase. Matching phase digests and twenty rows in every run support result consistency.

## Portfolio 3 Transactions and Concurrency

Portfolio 3 contains [transaction and concurrency SQL](Babalola_Michael_portfolio-3-transactions-concurrency/Babalola_Michael_README.md), the [implementation design](Babalola_Michael_portfolio-3-transactions-concurrency/Babalola_Michael_transaction-design.md), [transaction analysis](Babalola_Michael_portfolio-3-transactions-concurrency/Babalola_Michael_transaction-analysis.md), and [19 desktop screenshots and 19 CSV exports](evidence/Babalola_Michael_portfolio-3/Babalola_Michael_README.md). The evidence records a committed order, contrasting Read Committed and Repeatable Read observations, and a blocked stock request that is rejected after the first purchase commits. All 15 final-state checks pass. The rollback captures use PID 18460 in both results: EL002 stock was 35 with one temporary order and item before ROLLBACK, then 38 with neither temporary row afterward.

## Portfolio 4 NoSQL and Advanced Data Models

Portfolio 4 implements the CampusMart document model in MongoDB with separate `products` and `orders` collections and embedded customer and line-item snapshots. The [implementation and model explanation](Babalola_Michael_portfolio-4-nosql/Babalola_Michael_README.md) are supported by the [MongoDB execution evidence](evidence/Babalola_Michael_portfolio-4/Babalola_Michael_README.md).

## Portfolio 5 Distributed and Cloud Database Exercise

Portfolio 5 applies a three-member local MongoDB replica set to CampusMart. The [technical design and scripts](Babalola_Michael_portfolio-5-distributed-cloud/Babalola_Michael_README.md), [execution evidence](evidence/Babalola_Michael_portfolio-5/Babalola_Michael_README.md), and [technical reflection](Babalola_Michael_portfolio-5-distributed-cloud/Babalola_Michael_technical-reflection.md) record replication, a majority write and secondary read, and a primary election. Before step-down, 27101 was PRIMARY; after the corrected step-down, 27102 was PRIMARY and all three members reported health 1. The members ran on one computer, so this demonstrates replica-set behavior but not recovery from a computer failure.
