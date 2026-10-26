
WITH
 --1. dwh.drop_comm_stats_tables_safe
dwh_pending AS (
    SELECT 'dwh.drop_comm_stats_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           MIN(create_date) AS oldest_record
    FROM dwh.mdms_communication_stats_integ
    WHERE record_status = 1
      AND create_date < date_trunc('day', now() - interval '1 day')
),

 --2. kettle.f_sec_tables_safe
kettle_pending AS (
    SELECT 'kettle.f_sec_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           NULL::timestamp AS oldest_record
    FROM information_schema.tables
    WHERE table_schema = 'kettle'
      AND table_name NOT LIKE '%' || to_char(current_date, 'DDMMYYYY') || '%'
      AND ( table_name LIKE '%primary%' OR table_name LIKE '%sec%' 
            OR table_name LIKE '%f_in%' OR table_name LIKE '%mic%'
            OR table_name LIKE '%hard%' OR table_name LIKE '%inmc%'
            OR table_name LIKE '%json%' )
),


-- 3. mdms.drop_lp_tables_safe
mdms_lp_pending AS (
    SELECT 'mdms.drop_lp_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           MIN(create_date) AS oldest_record
    FROM mdms.mdms_vee_kettle_job_integ_lp
    WHERE record_status = 0
      AND create_date < now() - interval '2 day'
),

-- 4. mdms.drop_ed_tables_safe
mdms_ed_pending AS (
    SELECT 'mdms.drop_ed_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           MIN(create_date) AS oldest_record
    FROM mdms.mdms_vee_kettle_job_integ_ed
    WHERE record_status = 0
      AND create_date < now() - interval '2 day'
),

-- 5. mdms.drop_eob_tables_safe
mdms_eob_pending AS (
    SELECT 'mdms.drop_eob_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           MIN(create_date) AS oldest_record
    FROM mdms.mdms_vee_kettle_job_integ_eob
    WHERE record_status = 0
      AND create_date < now() - interval '2 day'
),

-- 6. mdms.drop_events_tables_safe
mdms_events_pending AS (
    SELECT 'mdms.drop_events_tables_safe' AS proc_name,
           COUNT(*) AS pending_count,
           MIN(create_date) AS oldest_record
    FROM mdms.mdms_vee_kettle_job_integ_events
    WHERE record_status = 0
      AND create_date < now() - interval '2 day'
),

-- 7. partition_sub.truncate_lp_with_commit
trunc_lp_pending AS (
    SELECT 'partition_sub.truncate_lp_with_commit' AS proc_name,
           COUNT(*) AS pending_count,
           NULL::timestamp AS oldest_record
    FROM pg_catalog.pg_tables
    WHERE schemaname = 'partition_sub'
      AND tablename LIKE 'mdms_stg_csv_lp_%'
      AND length(split_part(tablename, 'mdms_stg_csv_lp_', 2)) = 8
      AND split_part(tablename, 'mdms_stg_csv_lp_', 2) ~ '^[0-9]{8}$'
      AND to_date(split_part(tablename, 'mdms_stg_csv_lp_', 2), 'YYYYMMDD')
          < (CURRENT_DATE - INTERVAL '7 days')
),

-- 8. partition_sub.truncate_ed_with_commit
trunc_ed_pending AS (
    SELECT 'partition_sub.truncate_ed_with_commit' AS proc_name,
           COUNT(*) AS pending_count,
           NULL::timestamp AS oldest_record
    FROM pg_catalog.pg_tables
    WHERE schemaname = 'partition_sub'
      AND tablename LIKE 'mdms_stg_csv_ed_%'
      AND length(split_part(tablename, 'mdms_stg_csv_ed_', 2)) = 8
      AND split_part(tablename, 'mdms_stg_csv_ed_', 2) ~ '^[0-9]{8}$'
      AND to_date(split_part(tablename, 'mdms_stg_csv_ed_', 2), 'YYYYMMDD')
          < (CURRENT_DATE - INTERVAL '7 days')
),

-- 9. partition_sub.truncate_eob_ed_with_commit
trunc_eob_ed_pending AS (
    SELECT 'partition_sub.truncate_eob_ed_with_commit' AS proc_name,
           COUNT(*) AS pending_count,
           NULL::timestamp AS oldest_record
    FROM pg_catalog.pg_tables
    WHERE schemaname = 'partition_sub'
      AND tablename LIKE 'mdms_stg_csv_eob_ed_%'
      AND length(split_part(tablename, 'mdms_stg_csv_eob_ed_', 2)) = 8
      AND split_part(tablename, 'mdms_stg_csv_eob_ed_', 2) ~ '^[0-9]{8}$'
      AND to_date(split_part(tablename, 'mdms_stg_csv_eob_ed_', 2), 'YYYYMMDD')
          < (CURRENT_DATE - INTERVAL '7 days')
),

-- Combine all pending counts
all_pending AS (
--    SELECT * FROM dwh_pending
--    UNION ALL 
SELECT * FROM kettle_pending
    UNION ALL SELECT * FROM mdms_lp_pending
    UNION ALL SELECT * FROM mdms_ed_pending
    UNION ALL SELECT * FROM mdms_eob_pending
    UNION ALL SELECT * FROM mdms_events_pending
    UNION ALL SELECT * FROM trunc_lp_pending
    UNION ALL SELECT * FROM trunc_ed_pending
    UNION ALL SELECT * FROM trunc_eob_ed_pending
),

-- Check if any procedure is currently running (active)
running_procs AS (
    SELECT DISTINCT regexp_replace(query, '^.*PROCEDURE\s+(\S+)\s*\(.*$', '\1', 'i') AS proc_name
    FROM pg_stat_activity
    WHERE state = 'active'
      AND query ~* '(call|select.*(drop_comm_stats_tables_safe|f_sec_tables_safe|drop_lp_tables_safe|drop_ed_tables_safe|drop_eob_tables_safe|drop_events_tables_safe|truncate_lp_with_commit|truncate_ed_with_commit|truncate_eob_ed_with_commit))'
)

SELECT 
    p.proc_name,
    COALESCE(p.pending_count, 0) AS pending_tables,
    CASE WHEN r.proc_name IS NOT NULL THEN 'RUNNING' ELSE 'IDLE' END AS current_status,
    p.oldest_record AS oldest_pending_record
FROM all_pending p
LEFT JOIN running_procs r ON p.proc_name = r.proc_name
ORDER BY pending_tables DESC;
 

