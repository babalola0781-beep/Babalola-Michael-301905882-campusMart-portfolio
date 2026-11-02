SELECT phase, run_no, jsonb_pretty(plan) AS json_execution_plan
FROM p2_benchmark.runs
ORDER BY CASE phase WHEN 'before' THEN 1 ELSE 2 END, run_no;
