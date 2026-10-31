# Portfolio 4 Execution Evidence

These screenshots and saved text outputs record the CampusMart MongoDB execution using MongoDB 9.0.4. The seed screenshot preserves the initial PowerShell command error and the corrected command that produced the successful seed summary.

## Results

The seed run reports 10 product documents, 8 order documents, 16 embedded line items, and the expected product and order indexes. The CM-1005 lookup shows Amina Yusuf's order and the purchase-time BK001 price of NGN 16,000; the current catalogue example lists BK001 at NGN 18,000. The low-stock query returns AC003 with zero units and EL001 with ten. The completed-sales aggregation totals NGN 491,000 for Electronics, NGN 40,000 for Books, NGN 31,000 for Clothing, and NGN 18,500 for Accessories.

## Evidence index

| Run | Script | Screenshot | Saved output |
|---|---|---|---|
| Seed summary: MongoDB version, document counts, embedded line-item count, and indexes. | [01_seed.js](../../portfolio-4-nosql/mongo/01_seed.js) | [PNG](screenshots/01-seed-summary.png) | [TXT](results/01-seed-summary.txt) |
| CM-1005 order document and Amina Yusuf's order history. | [02_order_lookup.js](../../portfolio-4-nosql/mongo/02_order_lookup.js) | [Part A](screenshots/02-order-lookup-a.png), [Part B](screenshots/02-order-lookup-b.png) | [TXT](results/02-order-lookup.txt) |
| Products with stock at or below 10. | [03_low_stock.js](../../portfolio-4-nosql/mongo/03_low_stock.js) | [PNG](screenshots/03-low-stock.png) | [TXT](results/03-low-stock.txt) |
| Completed-order sales totals by category using purchase-time line-item prices. | [04_completed_sales.js](../../portfolio-4-nosql/mongo/04_completed_sales.js) | [PNG](screenshots/04-completed-sales.png) | [TXT](results/04-completed-sales.txt) |
