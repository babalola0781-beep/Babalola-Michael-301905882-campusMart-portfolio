# Technical reflection on the implementation

The most important design choice is the separation of a product's current price
from the price charged on a historical order. Reusing the catalogue price to
calculate old orders would change past order values whenever a product price
changed. Keeping `order_items.unit_price` preserves the business fact at purchase.

The composite key `(order_id, product_id)` makes the meaning of one order line
explicit: a product occurs at most once within an order. Quantity and charged
price describe that pair, while product names and customer details remain in
their own relations. This supports the normalisation explanation with actual
functional dependencies rather than an unsupported claim of 3NF.

Validation identified a portability detail in the automated checks: PostgreSQL
versions may report restricted parent deletion using SQLSTATE 23001 or 23503.
The check was adjusted to accept either expected state while still requiring
the correct foreign-key constraint name. Accepting any error would have hidden
the possibility that a test failed for an unrelated reason.

Another useful distinction is between schema integrity and business workflow.
Foreign keys ensure an order item has valid parents, but they do not force a
placed order to contain an item. A detection query is supplied; atomic stock
changes and order placement remain tasks for the transaction portfolio.

The implementation has verified automated results, but evidence from the
student's own PostgreSQL/pgAdmin session is still outstanding. This reflection
describes the design and observed validation; it does not assert personal
learning experiences or desktop actions that have not been documented.
