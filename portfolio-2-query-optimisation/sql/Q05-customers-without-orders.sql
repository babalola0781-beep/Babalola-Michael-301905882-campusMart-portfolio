SELECT c.customer_id, c.full_name, c.email
FROM public.customers c
WHERE NOT EXISTS (SELECT 1 FROM public.orders o WHERE o.customer_id=c.customer_id)
ORDER BY c.customer_id;
