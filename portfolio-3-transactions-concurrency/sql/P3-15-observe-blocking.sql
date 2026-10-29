SELECT pg_stat_clear_snapshot();
SELECT pg_backend_pid() AS session_a_pid,
       b.pid AS session_b_pid,
       b.state AS session_b_state,
       b.wait_event_type, b.wait_event,
       pg_blocking_pids(b.pid) AS blocking_pids,
       pg_backend_pid() = ANY(pg_blocking_pids(b.pid)) AS blocked_by_session_a
FROM pg_stat_activity AS b
WHERE b.datname = current_database()
  AND b.application_name = 'campusmart_p3_b'
  AND b.pid <> pg_backend_pid()
ORDER BY b.pid;
