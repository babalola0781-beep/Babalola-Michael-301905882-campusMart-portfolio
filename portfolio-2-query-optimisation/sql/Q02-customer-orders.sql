-- Amina Yusuf's order history, with charged order amounts.
SELECT o.order_reference, o.order_date, o.status,
       SUM(oi.quantity * oi.unit_price)::numeric(14,2) AS order_value_ngn
FROM public.orders o JOIN public.customers c USING(customer_id)
JOIN public.order_items oi USING(order_id)
WHERE c.email = 'amina@example.test'
GROUP BY o.order_id ORDER BY o.order_date DESC, o.order_id DESC;
