-- Separate customer-order performance dataset. No changes to public tables.
BEGIN;
CREATE SCHEMA p2_benchmark;
CREATE TABLE p2_benchmark.customers (
 customer_id integer PRIMARY KEY,
 full_name varchar(100) NOT NULL
);
CREATE TABLE p2_benchmark.orders (
 order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_id integer NOT NULL REFERENCES p2_benchmark.customers,
 order_reference varchar(20) NOT NULL UNIQUE,
 order_date timestamptz NOT NULL,
 status varchar(15) NOT NULL CHECK (status IN ('draft','placed','completed','cancelled'))
);
INSERT INTO p2_benchmark.customers
SELECT n, 'Benchmark Customer ' || n FROM generate_series(1,1000) n;
INSERT INTO p2_benchmark.orders(customer_id, order_reference, order_date, status)
SELECT ((n-1)%1000)+1, 'P2-'||lpad(n::text,6,'0'),
       timestamptz '2026-01-01 00:00:00+01' + n*interval '10 minutes',
       CASE WHEN n%10=0 THEN 'cancelled' WHEN n%5=0 THEN 'placed' ELSE 'completed' END
FROM generate_series(1,20000) n;
CREATE TABLE p2_benchmark.runs (
 phase text NOT NULL CHECK (phase IN ('before','after')), run_no integer NOT NULL,
 measured_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 execution_ms numeric, planning_ms numeric, actual_rows integer,
 shared_hit_blocks integer, shared_read_blocks integer, result_digest text,
 plan jsonb NOT NULL, PRIMARY KEY(phase,run_no)
);
COMMIT;
ANALYZE p2_benchmark.customers;
ANALYZE p2_benchmark.orders;
SELECT current_database() AS database_name, current_setting('server_version') AS server_version,
       (SELECT count(*) FROM p2_benchmark.customers) AS benchmark_customers,
       (SELECT count(*) FROM p2_benchmark.orders) AS benchmark_orders,
       (SELECT count(*) FROM public.customers) AS original_customers,
       (SELECT count(*) FROM public.orders) AS original_orders;
