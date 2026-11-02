BEGIN;
UPDATE p3_lab.products SET stock_quantity = stock_quantity - 1 WHERE sku = 'EL003';
COMMIT;

SELECT 'rc_writer_committed' AS phase, pg_backend_pid() AS session_pid,
       current_setting('transaction_isolation') AS isolation_level,
       transaction_timestamp() AS transaction_started,
       sku, stock_quantity
FROM p3_lab.products WHERE sku = 'EL003';
