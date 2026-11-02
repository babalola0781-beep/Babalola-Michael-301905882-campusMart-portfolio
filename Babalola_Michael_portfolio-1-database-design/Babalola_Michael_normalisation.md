# Normalisation: explanation tied to this implementation

## Starting problem

An unnormalised order record containing order_reference, customer name/email, product1, quantity1,
product2, quantity2 and a category name would place repeated data in one wide table. The repeating
product columns limit how many items an order can hold. Repeating customer and
category details creates opportunities for conflicting updates.

## First normal form (1NF)

Each column stores one value for its intended domain. An order with several
products uses several ORDER_ITEMS rows, not a comma-separated product list or
numbered product columns. Each table has a key that distinguishes its rows.
Storing a display name in one column is appropriate because this model does not
need to process separate name components.

## Second normal form (2NF)

The single-column primary keys in CUSTOMERS, CATEGORIES, PRODUCTS and ORDERS
do not have a proper subset on which a non-key field could partially depend.
Their alternate single-column keys are email, category_name, sku and
order_reference respectively.

ORDER_ITEMS has the composite key (order_id, product_id). Quantity describes
the number of that product in that order. The charged unit_price also describes
that order/product combination: discounts or price changes can result in
different charged prices for the same product on different orders.

Product_name is not stored in ORDER_ITEMS because it depends on product_id
alone. Customer details are not stored there because they depend on the order's
customer, rather than the whole order/product key.

## Third normal form (3NF)

Non-key fields describe keys directly rather than being stored through another
non-key determinant. Relevant functional dependencies are:

- customer_id -> full_name, email; email -> customer_id, full_name.
- category_id -> category_name; category_name -> category_id.
- product_id -> category_id, sku, product_name, price, stock_quantity.
- sku -> product_id, category_id, product_name, price, stock_quantity.
- order_id -> customer_id, order_reference, order_date, status.
- order_reference -> order_id, customer_id, order_date, status.
- (order_id, product_id) -> quantity, unit_price.

Category_name stays in CATEGORIES instead of PRODUCTS, avoiding a stored chain
product_id -> category_id -> category_name. Full_name and email stay in
CUSTOMERS instead of ORDERS, avoiding repeated customer details for every order.
Under the stated rules and dependencies, the five relations satisfy 3NF.

## Why two prices are correct

PRODUCTS.price and ORDER_ITEMS.unit_price are different business facts: today's
catalogue price versus the historical price charged on a particular order.
For CM-1005, BK001 was charged at NGN 16,000 while its current price is NGN 18,000.
The historical value is not redundant copying of a fact with the same meaning.

## Why totals are derived

Line value is quantity * unit_price; order value is the sum of line values.
Computing them avoids keeping stored totals synchronised after an item changes.
This is a deliberate redundancy-control decision, not proof of normalisation
by itself. Stock is a stored current snapshot in this limited model; a full stock
movement ledger is outside this stage.
