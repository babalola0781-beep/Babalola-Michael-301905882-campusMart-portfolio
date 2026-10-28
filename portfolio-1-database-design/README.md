# Portfolio 1 Database Design and Modelling

CampusMart records customers, product categories, products, orders and order items. The implementation uses PostgreSQL 18.6 and was executed in pgAdmin 4 against `campusmart_portfolio`.

## Design

Each order belongs to one customer, and each product belongs to one category. `order_items` resolves the many-to-many relationship between orders and products. Its composite primary key `(order_id, product_id)` limits each product to one line per order. The line stores quantity and the historical unit price.

- [Case study and business rules](case-study.md)
- [ER diagram](diagrams/campusmart-erd.png)
- [Relational schema and data dictionary](data-dictionary.md)
- [Normalisation and functional dependencies](normalisation.md)

## Implementation and testing

| SQL file | Role in the implementation |
|---|---|
| [01_schema.sql](sql/01_schema.sql) | Defines the five tables, primary and foreign keys, unique values, required fields and checks. |
| [02_seed_data.sql](sql/02_seed_data.sql) | Loads the fictional dataset into the empty schema. A guard rejects loading into populated tables. |
| [03_verify_data.sql](sql/03_verify_data.sql) | Queries row counts, order values, historical prices, empty placed orders and constraint definitions. |
| [04_constraint_checks.sql](sql/04_constraint_checks.sql) | Attempts 12 invalid operations and checks the rejection codes and constraint names within a transaction that ends in ROLLBACK. |

The implementation sequence was schema creation, sample-data loading, read-only verification and constraint testing. The schema and data scripts use transactions. The test script records its results in a temporary table before rolling back. The seven [screenshots](../evidence/portfolio-1/screenshots/README.md) document the desktop results.

## Results

| Table | Initial count | Count after checks |
|---|---:|---:|
| categories | 4 | 4 |
| customers | 6 | 6 |
| products | 10 | 10 |
| orders | 8 | 8 |
| order_items | 16 | 16 |

All 12 constraint checks passed. The result grid includes duplicate keys, invalid references, missing values and invalid stock, quantity, price, status and name values. The initial and final count comparisons both show five PASS rows.

For order CM-1005, product BK001 has a charged price of NGN 16,000 and a current price of NGN 18,000. Order values are calculated from `quantity * unit_price`. The eight displayed amounts include draft, placed and cancelled orders as well as completed orders, so their combined value is not reported as sales revenue.

## Scope and limitations

The tables enforce valid parent references and field-level rules. They do not enforce a minimum number of items before an order is placed, or automatically couple order placement with stock deduction. The empty-order query detects violations of the intended rule; it does not prevent them. Stock is a current snapshot, and payment, delivery and refund processing are outside this design.

[Technical report](documentation/Portfolio-1-Report.pdf) · [Reflection](documentation/Technical-Reflection.md) · [References](references.md)
