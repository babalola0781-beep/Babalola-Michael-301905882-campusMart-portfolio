-- Fictional seed dataset for the CampusMart schema.
-- Expected counts: 6 customers, 4 categories, 10 products, 8 orders, 16 items.
-- The guard prevents a repeated load into populated tables.
BEGIN;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.customers)
       OR EXISTS (SELECT 1 FROM public.categories)
       OR EXISTS (SELECT 1 FROM public.products)
       OR EXISTS (SELECT 1 FROM public.orders)
       OR EXISTS (SELECT 1 FROM public.order_items) THEN
        RAISE EXCEPTION 'Seed data requires all five tables to be empty.';
    END IF;
END $$;

INSERT INTO public.customers (full_name, email) VALUES
    ('Amina Yusuf', 'amina@example.test'),
    ('Tunde Bello', 'tunde@example.test'),
    ('Chidinma Okeke', 'chidinma@example.test'),
    ('Emeka Obi', 'emeka@example.test'),
    ('Zainab Musa', 'zainab@example.test'),
    ('Ada Nwosu', 'ada@example.test');

INSERT INTO public.categories (category_name) VALUES
    ('Electronics'), ('Books'), ('Clothing'), ('Accessories');

INSERT INTO public.products (category_id, sku, product_name, price, stock_quantity)
SELECT c.category_id, v.sku, v.product_name, v.price, v.stock_quantity
FROM (VALUES
    ('Electronics', 'EL001', 'Student Laptop', 450000.00, 10),
    ('Electronics', 'EL002', 'Wireless Mouse', 8500.00, 40),
    ('Electronics', 'EL003', 'USB Flash Drive', 12000.00, 25),
    ('Books', 'BK001', 'Database Systems Textbook', 18000.00, 20),
    ('Books', 'BK002', 'A5 Notebook', 1500.00, 100),
    ('Clothing', 'CL001', 'Campus T-shirt', 6500.00, 30),
    ('Clothing', 'CL002', 'Campus Hoodie', 18000.00, 12),
    ('Accessories', 'AC001', 'Student Backpack', 14000.00, 18),
    ('Accessories', 'AC002', 'Water Bottle', 4500.00, 35),
    ('Accessories', 'AC003', 'Compact Umbrella', 5500.00, 0)
) AS v(category_name, sku, product_name, price, stock_quantity)
JOIN public.categories c ON c.category_name = v.category_name;

INSERT INTO public.orders (customer_id, order_reference, order_date, status)
SELECT c.customer_id, v.order_reference, v.order_date::timestamptz, v.status
FROM (VALUES
    ('amina@example.test', 'CM-1001', '2026-10-01 09:00:00+01', 'completed'),
    ('tunde@example.test', 'CM-1002', '2026-10-01 10:30:00+01', 'completed'),
    ('chidinma@example.test', 'CM-1003', '2026-10-02 12:15:00+01', 'completed'),
    ('emeka@example.test', 'CM-1004', '2026-10-03 14:00:00+01', 'completed'),
    ('amina@example.test', 'CM-1005', '2026-10-04 11:00:00+01', 'completed'),
    ('zainab@example.test', 'CM-1006', '2026-10-05 13:30:00+01', 'placed'),
    ('tunde@example.test', 'CM-1007', '2026-10-06 08:45:00+01', 'draft'),
    ('chidinma@example.test', 'CM-1008', '2026-10-06 09:15:00+01', 'cancelled')
) AS v(email, order_reference, order_date, status)
JOIN public.customers c ON c.email = v.email;

INSERT INTO public.order_items (order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, v.quantity, v.unit_price
FROM (VALUES
    ('CM-1001', 'EL001', 1, 450000.00),
    ('CM-1001', 'EL002', 2, 8500.00),
    ('CM-1002', 'BK001', 1, 18000.00),
    ('CM-1002', 'BK002', 4, 1500.00),
    ('CM-1003', 'CL001', 2, 6500.00),
    ('CM-1003', 'AC001', 1, 14000.00),
    ('CM-1004', 'EL003', 2, 12000.00),
    ('CM-1004', 'AC002', 1, 4500.00),
    ('CM-1005', 'CL002', 1, 18000.00),
    -- Historical sale price differs from the textbook's current price.
    ('CM-1005', 'BK001', 1, 16000.00),
    ('CM-1006', 'AC001', 1, 14000.00),
    ('CM-1006', 'AC003', 1, 5500.00),
    ('CM-1007', 'BK002', 10, 1500.00),
    ('CM-1007', 'AC002', 2, 4500.00),
    ('CM-1008', 'EL002', 1, 8500.00),
    ('CM-1008', 'CL001', 1, 6500.00)
) AS v(order_reference, sku, quantity, unit_price)
JOIN public.orders o ON o.order_reference = v.order_reference
JOIN public.products p ON p.sku = v.sku;

COMMIT;
