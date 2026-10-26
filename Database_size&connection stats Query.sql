-- Database size and connection stats
SELECT
    pg_database.datname AS database_name,
    pg_size_pretty(pg_database_size(pg_database.datname)) AS size,
    numbackends AS active_connections,
    xact_commit,
    xact_rollback,
    blks_read,
    blks_hit
FROM
    pg_stat_database
JOIN
    pg_database ON pg_database.datname = pg_stat_database.datname
WHERE
    pg_database.datname NOT IN ('template0', 'template1')
ORDER BY
    pg_database_size(pg_database.datname) DESC;


select * from pg_tables

--Tables Sizes
SELECT 
  n.nspname AS schema_name,
  c.relname AS table_name,
  pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'  -- 'r' = ordinary table
ORDER BY pg_total_relation_size(c.oid) DESC;

--Schemas & Table count

SELECT
    table_schema,
    COUNT(*) AS table_count
FROM
    information_schema.tables
WHERE
    table_type = 'BASE TABLE'
GROUP BY
    table_schema
ORDER BY
    table_count DESC;



SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
  --AND table_schema = 'mdms'
ORDER BY table_name;




WITH idx AS (
    SELECT
        n.nspname AS schema_name,
        t.relname AS table_name,
        i.relname AS index_name,
        i.reltuples AS est_rows,
        i.relpages AS index_pages,
        current_setting('block_size')::int AS bs
    FROM pg_index x
    JOIN pg_class t ON t.oid = x.indrelid
    JOIN pg_class i ON i.oid = x.indexrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
),
calc AS (
    SELECT
        schema_name,
        table_name,
        index_name,
        (index_pages::bigint * bs::bigint) AS index_size_bytes,
        GREATEST((index_pages::bigint * bs::bigint) - (est_rows::bigint * 16), 0) AS bloat_bytes
    FROM idx
)
SELECT
    schema_name,
    table_name,
    index_name,
    pg_size_pretty(index_size_bytes) AS index_size,
    pg_size_pretty(bloat_bytes) AS bloat_size,
    ROUND((bloat_bytes::numeric / NULLIF(index_size_bytes, 0)) * 100, 2) AS bloat_pct,
    'REINDEX INDEX ' || schema_name || '.' || index_name || ';' AS reindex_cmd
FROM calc
WHERE schema_name = 'partition_sub'
  AND index_size_bytes > 10 * 1024 * 1024
ORDER BY index_size_bytes DESC
--LIMIT 100000;



