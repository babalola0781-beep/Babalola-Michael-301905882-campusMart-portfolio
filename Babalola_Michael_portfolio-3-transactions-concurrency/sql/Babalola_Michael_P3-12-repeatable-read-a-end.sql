COMMIT;

SELECT 'after_rr_commit' AS phase, pg_backend_pid() AS session_pid,
       current_setting('transaction_isolation') AS isolation_level,
       transaction_timestamp() AS transaction_started,
       sku, stock_quantity
FROM p3_lab.products WHERE sku = 'AC002';
