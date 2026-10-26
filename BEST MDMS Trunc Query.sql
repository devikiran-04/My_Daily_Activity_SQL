
SELECT 'truncate table partition_sub.'||tablename||';'
FROM pg_catalog.pg_tables
WHERE schemaname = 'partition_sub'
  AND tablename LIKE 'mdms_stg_csv_lp_%'
  AND length(split_part(tablename, 'mdms_stg_csv_lp_', 2)) = 8
  AND split_part(tablename, 'mdms_stg_csv_lp_', 2) ~ '^[0-9]{8}$'
  AND to_date(split_part(tablename, 'mdms_stg_csv_lp_', 2), 'YYYYMMDD')
< (CURRENT_DATE - INTERVAL '3 days');

