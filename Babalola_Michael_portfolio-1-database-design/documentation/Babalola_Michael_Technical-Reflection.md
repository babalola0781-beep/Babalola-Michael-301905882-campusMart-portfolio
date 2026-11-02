# Portfolio 1 Technical Reflection

The historical-price query provides a concrete reason for keeping `order_items.unit_price` separate from `products.price`. In CM-1005, the textbook was charged at NGN 16,000 even though its current price is NGN 18,000. Using the current catalogue price for past orders would alter the recorded value of the purchase.

The composite key in `order_items` gives each line a clear meaning: one product within one order. Quantity and charged price depend on both identifiers. Customer details and category names remain in their own tables, reducing repeated values and conflicting updates.

When capturing the constraint evidence, the successful execution message alone did not display the result table. The relevant evidence is the result grid produced by the SELECT on the temporary results table before the final ROLLBACK. The submitted screenshot shows all 12 PASS rows. The repeated count query then shows that the permanent table counts match their initial values.

These checks establish the tested integrity rules. They do not establish a complete ordering workflow. A foreign key validates an existing order item, but it does not require an order to contain an item. Minimum-item enforcement and atomic stock updates require transaction logic beyond this schema.
