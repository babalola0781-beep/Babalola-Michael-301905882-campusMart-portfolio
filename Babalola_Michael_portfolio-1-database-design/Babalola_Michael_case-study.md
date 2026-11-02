# CampusMart: case study and business rules

## Organisation and purpose

CampusMart is a simulated Nigerian online retail business serving university
students and staff. It sells electronics, books, clothing and accessories.
All sample people, transactions and addresses are fictional. Monetary values are
in Nigerian naira (NGN); this is a single-currency teaching system.

## Users

- Customers browse products and place orders.
- Sales staff review order details and status.
- Stock staff maintain product information and current stock.
- Administrators maintain reference data and produce reports.

These are business roles. Separate database login roles and application
authentication are outside Portfolio 1's implementation scope.

## Stored information and supported operations

Customers have names and email addresses. Products have a unique SKU, category,
current price and stock quantity. Orders identify a customer, reference, date and
status. Order items record each purchased product, its quantity and charged price.
The model supports customer registration, product listing, order recording,
stock maintenance and historical order-value reporting.

## Rules and enforcement

| Rule | Implementation |
|---|---|
| A customer can have zero or many orders | One-to-many relationship through `orders.customer_id` |
| Each order has exactly one existing customer | NOT NULL foreign key |
| Each product has exactly one category | NOT NULL foreign key |
| A category can have zero or many products | No minimum-child constraint |
| A product appears at most once in a particular order | Composite primary key on `(order_id, product_id)` |
| An order item belongs to exactly one order and one product | Two NOT NULL foreign keys |
| Customer emails are unique | UNIQUE; lower-case, trimmed storage required |
| Stock cannot be negative | Integer, NOT NULL and CHECK |
| Ordered quantity must be positive | Integer, NOT NULL and CHECK |
| Current and charged prices must be finite and non-negative | NUMERIC(12,2), NOT NULL and CHECK excluding NaN |
| Historical charged prices survive current-price changes | Separate `order_items.unit_price` |
| Referenced parent records cannot be deleted | ON DELETE RESTRICT |
| Draft orders may initially have zero items | Schema permits this |
| Placed/completed orders should contain at least one item | Checked in file 03; workflow enforcement deferred to Portfolio 3 |

## Deliberate boundaries

This stage does not integrate payments, refunds, shipping, taxes or authentication.
An order's total is derived from its items instead of stored redundantly. Email
format checking is minimal and does not verify ownership or deliverability.
Names and category labels are not globally case-insensitive. Referential
constraints preserve relationships but do not implement a complete sales workflow.
