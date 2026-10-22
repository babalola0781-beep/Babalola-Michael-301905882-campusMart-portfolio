-- Products at or below ten units in stock.
SELECT sku, product_name, stock_quantity
FROM public.products WHERE stock_quantity <= 10
ORDER BY stock_quantity, sku;
