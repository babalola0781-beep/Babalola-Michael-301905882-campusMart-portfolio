WITH summary AS (
 SELECT phase, COUNT(*) AS measured_runs,
 percentile_cont(0.5) WITHIN GROUP(ORDER BY execution_ms) AS median_execution_ms,
 MIN(actual_rows) AS min_rows, MAX(actual_rows) AS max_rows,
 COUNT(DISTINCT result_digest) AS result_versions
 FROM p2_benchmark.runs GROUP BY phase
)
SELECT b.before_runs, a.after_runs, b.median_execution_ms AS before_median_ms, a.median_execution_ms AS after_median_ms, round((100*(b.median_execution_ms-a.median_execution_ms)/NULLIF(b.median_execution_ms,0))::numeric,2) AS reduction_percent
FROM (SELECT measured_runs AS before_runs,median_execution_ms FROM summary WHERE phase='before') b
CROSS JOIN (SELECT measured_runs AS after_runs,median_execution_ms FROM summary WHERE phase='after') a;
