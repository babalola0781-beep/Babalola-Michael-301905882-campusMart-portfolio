SELECT cat.category_name, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price)::numeric(14,2) AS sales_ngn
FROM public.order_items oi JOIN public.orders o USING(order_id)
JOIN public.products p USING(product_id)
JOIN public.categories cat USING(category_id)
WHERE o.status='completed'
GROUP BY cat.category_id ORDER BY sales_ngn DESC, cat.category_name;
