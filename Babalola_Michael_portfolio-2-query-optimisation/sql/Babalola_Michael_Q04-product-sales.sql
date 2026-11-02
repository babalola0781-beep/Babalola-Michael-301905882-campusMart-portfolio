-- Sales mean completed orders only.
SELECT p.sku, p.product_name, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price)::numeric(14,2) AS sales_ngn
FROM public.order_items oi JOIN public.orders o USING(order_id)
JOIN public.products p USING(product_id)
WHERE o.status = 'completed'
GROUP BY p.product_id ORDER BY units_sold DESC, p.sku;
