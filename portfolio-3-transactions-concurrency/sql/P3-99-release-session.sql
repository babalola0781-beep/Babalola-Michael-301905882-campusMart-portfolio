ROLLBACK;
RESET lock_timeout;
RESET idle_in_transaction_session_timeout;
SELECT pg_backend_pid() AS session_pid, 'transaction released' AS session_state;
