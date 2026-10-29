SET application_name = 'campusmart_p3_a';
SET TIME ZONE 'Africa/Lagos';
SET idle_in_transaction_session_timeout = '15min';
SELECT current_database() AS database_name,
       current_setting('server_version') AS server_version,
       pg_backend_pid() AS session_pid,
       current_setting('application_name') AS session_name,
       current_setting('TimeZone') AS session_timezone,
       current_setting('transaction_isolation') AS isolation_level;
