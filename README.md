# MIT 8103 — Advanced Database Systems Portfolio

**Student:** Michael Olayemi Babalola  
**Academic session:** 2026/2027, First Semester  
**Case study:** CampusMart — a simulated Nigerian online retail business  
**GitHub account:** babalola0781-beep

This repository contains practical database work, reproducible SQL, design
documentation and recorded results. The same CampusMart case study will be used
throughout. Only Portfolio 1 has been implemented at this stage.

## Start here

- [Portfolio 1 technical report (PDF)](documentation/Portfolio-1-Report.pdf)
- [Portfolio 1 technical report (editable Word)](documentation/Portfolio-1-Report.docx)
- [Portfolio 1 overview and execution instructions](portfolio-1-database-design/README.md)
- [ER diagram](portfolio-1-database-design/diagrams/campusmart-erd.png)
- [Recorded validation evidence](evidence/portfolio-1/README.md)

The implementation and automated checks are available. The student's PostgreSQL/
pgAdmin screenshot has not yet been supplied, so Portfolio 1 is not labelled
fully ready for submission. A colleague's GitHub screenshots were used only to
understand repository organisation; they are not included as database evidence.

## Portfolio structure

| Portfolio | Activity | Marks | Status |
|---|---|---:|---|
| [Portfolio 1](portfolio-1-database-design/README.md) | Database Design and Modelling | 7 | Implemented and checked; student screenshot pending |
| [Portfolio 2](portfolio-2-query-optimisation/README.md) | Query Processing and Optimisation | 7 | Not started |
| [Portfolio 3](portfolio-3-transactions-concurrency/README.md) | Transactions and Concurrency | 7 | Not started |
| [Portfolio 4](portfolio-4-nosql/README.md) | NoSQL and Advanced Data Models | 7 | Not started |
| [Portfolio 5](portfolio-5-distributed-cloud/README.md) | Distributed and Cloud Database Exercise | 6 | Not started |
| Final | Documentation and Technical Reflection | 6 | Prepared after all five portfolios |
| **Total** | | **40** | |

The final 2–3 page LMS summary covering all five portfolios is a separate
deliverable. The report linked above documents Portfolio 1 only.

## Technology used

| Component | Tool | Purpose |
|---|---|---|
| Relational database | PostgreSQL | Tables, keys, constraints and SQL |
| Desktop interface | pgAdmin 4 | Execute the SQL and capture the student's own results |
| Automated validation environment | PGlite 0.5.8 / embedded PostgreSQL 18.3 | Execute the supplied scripts and record actual outputs |
| Version control | GitHub | Store code, documentation, evidence and genuine progressive changes |
| Diagrams | Supplied PNG, PDF, SVG and editable draw.io source | Explain the implemented relationships |

The user's installed PostgreSQL/pgAdmin version is not established by the supplied
images. PGlite is the assistant's validation environment, not a claim about the
student's desktop installation. Docker and MongoDB are not prerequisites for
this stage.

## Run Portfolio 1

1. Create a fresh PostgreSQL database named `campusmart_portfolio`.
2. Open pgAdmin's Query Tool connected to that database.
3. Execute `portfolio-1-database-design/sql/01_schema.sql` in full.
4. Execute `portfolio-1-database-design/sql/02_seed_data.sql` in full, once.
5. Execute the individual queries in `03_verify_data.sql`.
6. Execute `04_constraint_checks.sql` in full; expect 12 PASS rows.
7. Save your own screenshots in `evidence/portfolio-1/screenshots/`.

The SQL creates five tables; it does not drop or overwrite previous work.
Detailed reproduction and expected results appear in the Portfolio 1 README.

## Sources and assistance

- [Source references](portfolio-1-database-design/references.md)
- [AI-use and evidence provenance](documentation/AI-Use-and-Evidence.md)
- [Technical reflection](documentation/Technical-Reflection.md)

The repository must remain private for the assessment. Access for the assessor
must be arranged before LMS submission using the lecturer's specified account.
No earlier work dates or development history are represented by these files.
