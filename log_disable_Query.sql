
ALTER SYSTEM SET log_statement = 'none';
ALTER SYSTEM SET log_min_duration_statement = -1;
ALTER SYSTEM SET log_min_duration_sample = -1;
ALTER SYSTEM SET log_connections = off;
ALTER SYSTEM SET log_disconnections = off;
ALTER SYSTEM SET log_checkpoints = off;
ALTER SYSTEM SET log_autovacuum_min_duration = -1;
ALTER SYSTEM SET log_duration = off;
ALTER SYSTEM SET logging_collector=off;

show logging_collector;

SELECT pg_reload_conf();

