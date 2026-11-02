-- One unrecorded warm-up and five recorded executions of the same query.
DO $$
DECLARE p jsonb; i integer; fingerprint text;
BEGIN
 IF to_regclass('p2_benchmark.idx_orders_customer_date') IS NOT NULL THEN RAISE EXCEPTION 'Before measurements require the experimental index to be absent.'; END IF;
 SELECT md5(string_agg(order_id::text||'|'||order_reference||'|'||(order_date AT TIME ZONE 'UTC')::text||'|'||status, ',' ORDER BY order_date DESC, order_id DESC))
 INTO fingerprint FROM p2_benchmark.orders WHERE customer_id=125;
 FOR i IN 0..5 LOOP
  EXECUTE 'EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) SELECT order_id, order_reference, order_date, status FROM p2_benchmark.orders WHERE customer_id=125 ORDER BY order_date DESC, order_id DESC' INTO p;
  IF i>0 THEN
   INSERT INTO p2_benchmark.runs(phase,run_no,execution_ms,planning_ms,actual_rows,shared_hit_blocks,shared_read_blocks,result_digest,plan)
   VALUES ('before',i,(p->0->>'Execution Time')::numeric,(p->0->>'Planning Time')::numeric,
    (p->0->'Plan'->>'Actual Rows')::numeric::integer,(p->0->'Plan'->>'Shared Hit Blocks')::integer,
    (p->0->'Plan'->>'Shared Read Blocks')::integer,fingerprint,p)
   ON CONFLICT(phase,run_no) DO UPDATE SET measured_at=clock_timestamp(), execution_ms=EXCLUDED.execution_ms,
    planning_ms=EXCLUDED.planning_ms,actual_rows=EXCLUDED.actual_rows,shared_hit_blocks=EXCLUDED.shared_hit_blocks,
    shared_read_blocks=EXCLUDED.shared_read_blocks,result_digest=EXCLUDED.result_digest,plan=EXCLUDED.plan;
  END IF;
 END LOOP;
END $$;
SELECT phase,run_no,execution_ms,planning_ms,actual_rows,shared_hit_blocks,shared_read_blocks
FROM p2_benchmark.runs WHERE phase='before' ORDER BY run_no;
