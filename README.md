# MIT 8103 Advanced Database Systems Portfolio

**Michael Olayemi Babalola**  
**Academic session:** 2026/2027, First Semester  
**Case study:** CampusMart, a simulated Nigerian online retail business

This repository documents the database design, implementation and verification for CampusMart. Portfolio 1 contains the relational model, SQL scripts, normalisation analysis and seven screenshots from my PostgreSQL execution in pgAdmin 4.

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

This submission documents Portfolio 1. The course portfolio uses the same case study across its remaining activities.
