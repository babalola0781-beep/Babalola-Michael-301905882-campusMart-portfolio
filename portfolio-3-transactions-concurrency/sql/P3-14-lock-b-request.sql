BEGIN ISOLATION LEVEL READ COMMITTED;
SET LOCAL lock_timeout = '180s';
SELECT * FROM p3_lab.place_order('CM-P3-LOCK-B', 'tunde@example.test', 'EL001', 5);
