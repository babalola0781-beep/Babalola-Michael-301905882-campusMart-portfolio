-- Calendar months in Nigeria; completed orders only.
SELECT to_char(date_trunc('month', o.order_date AT TIME ZONE 'Africa/Lagos'),'YYYY-MM') AS sales_month,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       SUM(oi.quantity * oi.unit_price)::numeric(14,2) AS sales_ngn
FROM public.orders o JOIN public.order_items oi USING(order_id)
WHERE o.status='completed'
GROUP BY 1 ORDER BY 1;
