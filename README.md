# MIT 8103 Advanced Database Systems Portfolio

**Michael Olayemi Babalola**  
**Academic session:** 2026/2027, First Semester  
**Case study:** CampusMart, a simulated Nigerian online retail business

This repository contains the five MIT 8103 portfolio activities using CampusMart as a consistent case study. Portfolio 1 contains the completed relational model, SQL scripts, normalisation analysis and seven screenshots from my PostgreSQL execution in pgAdmin 4.

## Portfolio overview

| Portfolio | Activity | Marks | Progress |
|---|---|---:|---|
| [Portfolio 1](portfolio-1-database-design/) | Database Design and Modelling | 7 | Complete |
| [Portfolio 2](portfolio-2-query-optimisation/) | Query Processing and Optimisation | 7 | Next activity |
| [Portfolio 3](portfolio-3-transactions-concurrency/) | Transactions and Concurrency | 7 | Planned |
| [Portfolio 4](portfolio-4-nosql/) | NoSQL and Advanced Data Models | 7 | Planned |
| [Portfolio 5](portfolio-5-distributed-cloud/) | Distributed and Cloud Database Exercise | 6 | Planned |

Final documentation and technical reflection carry a further 6 marks, bringing the assessment total to 40. The final LMS summary covers all five activities.

## Portfolio 1 Database Design and Modelling

| Submission material | File |
|---|---|
| Technical report | [PDF](documentation/Portfolio-1-Report.pdf) · [Word](documentation/Portfolio-1-Report.docx) · [Markdown](documentation/Portfolio-1-Report.md) |
| Implementation and results | [Portfolio 1](portfolio-1-database-design/README.md) |
| Case study and business rules | [Case study](portfolio-1-database-design/case-study.md) |
| Entity relationship diagram | [ER diagram](portfolio-1-database-design/diagrams/campusmart-erd.png) |
| Relational schema | [Data dictionary](portfolio-1-database-design/data-dictionary.md) |
| Functional dependencies | [Normalisation](portfolio-1-database-design/normalisation.md) |
| Execution evidence | [Seven pgAdmin screenshots](evidence/portfolio-1/screenshots/README.md) |
| Reflection | [Technical reflection](documentation/Technical-Reflection.md) |
| Sources | [References](portfolio-1-database-design/references.md) |
| AI use | [Declaration](documentation/AI-Use-and-Evidence.md) |

## Verified results

The database contains 6 customers, 4 categories, 10 products, 8 orders and 16 order items. All 12 constraint tests passed. Row counts after testing match the initial counts. The textbook in order CM-1005 retains its charged price of NGN 16,000 while the current product price is NGN 18,000.

The database name and reported server version are `campusmart_portfolio` and PostgreSQL `18.6`, as shown in the server-version screenshot. All case-study records are fictional and monetary values are in Nigerian naira.

The completed implementation and evidence currently cover Portfolio 1. Portfolios 2 to 5 retain their own directories for the remaining assessment activities.
