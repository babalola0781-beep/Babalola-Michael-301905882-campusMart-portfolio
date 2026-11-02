-- All order statuses; these amounts are not total sales revenue.
SELECT o.order_reference, o.status,
       COALESCE(SUM(oi.quantity * oi.unit_price),0)::numeric(14,2) AS order_value_ngn
FROM public.orders o LEFT JOIN public.order_items oi USING(order_id)
GROUP BY o.order_id ORDER BY o.order_reference;
