WITH spending AS (
 SELECT c.customer_id, c.full_name,
        SUM(oi.quantity * oi.unit_price)::numeric(14,2) AS completed_spend_ngn
 FROM public.customers c JOIN public.orders o USING(customer_id)
 JOIN public.order_items oi USING(order_id)
 WHERE o.status='completed' GROUP BY c.customer_id
)
SELECT DENSE_RANK() OVER (ORDER BY completed_spend_ngn DESC) AS spending_rank,
       full_name, completed_spend_ngn
FROM spending ORDER BY spending_rank, customer_id;
