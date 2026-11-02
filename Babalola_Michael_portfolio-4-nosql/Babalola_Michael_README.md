# Portfolio 4: NoSQL and Advanced Data Models

**Case study:** CampusMart, a simulated Nigerian online retail business. It serves customers who browse products and place orders; the database stores a product catalogue, current stock, customer details, order status, and the prices charged on each order.

This submission models the same CampusMart data in MongoDB. It uses a document model with separate product and order collections and embeds an order's customer snapshot and line items in the order document.

## Model and relational mapping

The **products** collection represents the current catalogue. Each document uses the existing product SKU as its identifier and stores the product name, category, current price in NGN, and stock quantity.

The **orders** collection uses the existing order reference as its identifier. Each order contains a customer snapshot and an **items** array. Each item records the SKU, product name, category, quantity, and unit price charged for that sale. The order also stores its status, UTC date, and NGN total.

Embedding the line items makes the complete order available from one document read. Keeping the current catalogue separate means stock and current prices can change without rewriting old orders. The order snapshot also preserves historical prices: order CM-1005 charged NGN 16,000 for BK001 even though the current catalogue price is NGN 18,000.

| Collection | Document identity | Main content |
| --- | --- | --- |
| products | SKU | Current product name, category, price, and stock |
| orders | Order reference | Customer snapshot, status, date, embedded items, and order total |

## Implementation files

| File | Submitted implementation |
| --- | --- |
| mongo/Babalola_Michael_01_seed.js | Creates the collections with MongoDB JSON Schema validation, upserts the 10 products and 8 orders from the CampusMart seed data, and creates query indexes. |
| mongo/Babalola_Michael_02_order_lookup.js | Reads order CM-1005 and Amina Yusuf's order history from embedded order documents. |
| mongo/Babalola_Michael_03_low_stock.js | Finds products with stock quantity at or below 10. |
| mongo/Babalola_Michael_04_completed_sales.js | Aggregates completed-order sales by the category recorded in each embedded line item. |
| Babalola_Michael_sample-product.json | Example of a current catalogue document in Extended JSON. |
| Babalola_Michael_sample-order.json | Example of an order document with embedded customer and line-item snapshots. |
| Babalola_Michael_references.md | Course brief and MongoDB documentation used for the model. |

## Run evidence

The [Portfolio 4 evidence index](../evidence/Babalola_Michael_portfolio-4/Babalola_Michael_README.md) links to the screenshots and saved text output for the seed summary, order lookup, low-stock query, and completed-sales aggregation.

## Suitability and trade-offs

Orders are a useful document boundary because an order and its line items are normally read together. The embedded customer and item snapshots reduce cross-collection lookups and keep the purchase-time information with the order. The separate product collection remains the source for current stock and current prices. The category and stock index supports the low-stock lookup, while the customer email and order date index supports customer order history.

The model intentionally duplicates customer and product descriptions in an order. That preserves the historical order view, but current profile or catalogue changes do not update those snapshots. Very large or independently queried histories may be better represented with references or a separate event collection. This small teaching dataset does not measure production-scale performance.


