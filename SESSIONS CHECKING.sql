ACTIVE
*******
SELECT pid,client_addr,usename,pg_stat_activity.query_start,now() - pg_stat_activity.query_start AS query_time, query,state,wait_event_type,wait_event 
FROM pg_stat_activity  
WHERE state='active'
order by query_time desc

REFRESH MATERIALIZED VIEW DWH.COMMUNICATION_COUNT_DA_VIEW;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE mdms.mdm_energy_data TO etluser;

GRANT USAGE, SELECT ON SEQUENCE dwh.lowpowerfactor_data_sno_seq TO etluser;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dwh' and table_name='lowpowerfactor_data'

SELECT * FROM pg_indexes WHERE schemaname = 'mdms'  AND tablename = 'mdms_csv_lp';

SELECT * FROM pg_partition_tree('mdms.mdm_loadprofile_data_invalid'::regclass);

IDLE  ALL KILLING
*******
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE  state = 'idle'
---usename='etluser'
AND now() - state_change > interval '10 minutes'
AND pid <> pg_backend_pid() 
and query not like '%SHOW TRANSACTION ISOLATION LEVEL%' 
and query not like '%SET search_path%' --and usename<>'rdsadmin'

select * from pg_stat_activity WHERE  state = 'idle'
AND now() - state_change > interval '10 minutes'
AND pid <> pg_backend_pid() and query not like '%SHOW TRANSACTION ISOLATION LEVEL%' and query not like '%SET search_path%' --and usename<>'rdsadmin'



long running killing
**********
select pg_terminate_backend('1042');
select pg_terminate_backend('336468');
select pg_terminate_backend('22124');
select pg_terminate_backend('21454');
select pg_terminate_backend('25270');
select pg_terminate_backend('1594358');
select pg_terminate_backend('15280');
select pg_terminate_backend('217472');
select pg_terminate_backend('4305');
select pg_terminate_backend('23982');
select pg_terminate_backend('381878');
select pg_terminate_backend('2245');
select pg_terminate_backend('326578');

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
where --usename = 'etluser'
pid IN (
13866,
13865,
13861);




idle in_active
------------------
SELECT pid,client_addr,usename,pg_stat_activity.query_start,now() - pg_stat_activity.query_start AS query_time,
state,wait_event_type,wait_event,query
FROM pg_stat_activity  WHERE state='idle in transaction'  and usename='wsiuser'
and query like 'select consumerma0_.ID as ID1_7_%'
order by query_time desc
 
idle in killing
--------------------
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity WHERE usename='wsiuser' AND
query like 'select consumerma0_.ID as ID1_7_%'
and state = 'idle in transaction'


BIHAR DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('nbpdcl_db')); --31TB

NDMC DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('ndmc_prd'));

APDCL DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('apdcl_prd'));

BEST MDMS DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('bestmdm_tnd'));


AEML DB SIZE 
*********
SELECT PG_SIZE_PRETTY(pg_database_size('aemlfgproddb'));

BEST HES DB SIZE
**********
SELECT PG_SIZE_PRETTY(pg_database_size('best_prd'));

PSPCL OCI DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('hes_proddb'));

KESCO DB SIZE
*********
SELECT PG_SIZE_PRETTY(pg_database_size('kesco_prd'));

SELECT * FROM pg_stat_archiver;

UPPCL DB SIZE
*******
SELECT PG_SIZE_PRETTY(pg_database_size('uppcl_prd'));

ADNOC DB SIZE
*******
SELECT PG_SIZE_PRETTY(pg_database_size('adnoc_prd'));

PSPCL 2L
*********
SELECT PG_SIZE_PRETTY(pg_database_size('pspcldb'));

APDCL2L
********
SELECT PG_SIZE_PRETTY(pg_database_size('apdcl_2l_prd'));

PDC
********
SELECT PG_SIZE_PRETTY(pg_database_size('pdc_prd'));

PNG
*********
SELECT PG_SIZE_PRETTY(pg_database_size('nuri_hes'));


-- KESCO RC DC --
select * from spm.intr_req_trans irt  
where   req_time  >= cast(now() as date) 
order by req_time DESC;

locking sessins
****************
SELECT activity.pid,activity.usename,activity.query,blocking.pid AS blocking_id,blocking.query AS blocking_query
FROM pg_stat_activity AS activity
JOIN pg_stat_activity AS blocking 
ON blocking.pid = ANY(pg_blocking_pids(activity.pid));


SELECT
    numbackends AS active_connections,
    xact_commit,
    xact_rollback,
    blks_read,
    blks_hit
FROM pg_stat_database
WHERE datname = 'apdcl_prd';

select count(*) FROM mdms.mdms_vee_kettle_job_integ_ed
WHERE record_status = 0 and create_date<now() - interval '2 day'
--203835
--199146

select count(*) FROM mdms.mdms_vee_kettle_job_integ_lp
WHERE record_status = 0 and create_date<now() - interval '2 day'
--126696
--120906

--ADNOC 
select * from fep.fep_CSV_instant order by create_date desc limit 100

 
select count(*) FROM mdms.mdms_vee_kettle_job_integ_eob
where create_date between '2026-04-22 00:00:00' and '2026-04-22 23:59:59'
limit 1
WHERE record_status = 0 and create_date= -- interval '2 day'
--21932
--

select * from mdms.mdms_vee_kettle_job_integ_lp
where create_date between '2026-04-22 00:00:00' and '2026-04-22 23:59:59'
limit 10


-- Check ED table status
SELECT 
    'ED' as table_type,
    COUNT(*) as total_pending,
    MIN(create_date) as oldest_record,
    MAX(create_date) as newest_record
FROM mdms.mdms_vee_kettle_job_integ_ed
WHERE record_status = 0 
  AND create_date < now() - interval '2 day'

UNION ALL

-- Check LP table status
SELECT 
    'LP' as table_type,
    COUNT(*) as total_pending,
    MIN(create_date) as oldest_record,
    MAX(create_date) as newest_record
FROM mdms.mdms_vee_kettle_job_integ_lp
WHERE record_status = 0 
  AND create_date < now() - interval '2 day';
