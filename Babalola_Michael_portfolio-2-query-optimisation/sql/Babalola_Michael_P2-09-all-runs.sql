SELECT phase, run_no, measured_at, execution_ms, planning_ms, actual_rows,
       shared_hit_blocks, shared_read_blocks, result_digest
FROM p2_benchmark.runs
ORDER BY CASE phase WHEN 'before' THEN 1 ELSE 2 END, run_no;
