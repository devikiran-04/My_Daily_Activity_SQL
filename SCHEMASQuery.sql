select schemaname,relname,last_vacuum,last_autovacuum,last_analyze,last_autoanalyze
from pg_stat_user_tables where schemaname in
--('cdb')
--('dwh')
--('fuel')
--('nfms')
--('public')
--('wfms')
--('mmg')
--('fep')
--('mdms')
--('spm')
--('partition_sub')





WITH schema_list AS (SELECT unnest(ARRAY['cdb','dwh','fuel','nfms','public','wfms','mmg','fep','mdms','spm','partition_sub']) AS schemaname),
schema_stats AS (SELECT schemaname,MAX(last_vacuum)AS last_vacuum,MAX(last_analyze)  AS last_analyze FROM pg_stat_user_tables GROUP BY schemaname)
SELECT s.schemaname,
-- last_vacuum logic
CASE
WHEN ss.last_vacuum IS NULL 
AND EXISTS (SELECT 1 FROM pg_stat_user_tables WHERE schemaname = s.schemaname)
THEN NULL -- schema exists and vacuum is NULL
WHEN ss.last_vacuum IS NULL THEN 'NA'   -- schema has no tables
ELSE ss.last_vacuum::text
END AS last_vacuum,
-- last_analyze logic
CASE
WHEN ss.last_analyze IS NULL 
AND EXISTS (SELECT 1 FROM pg_stat_user_tables WHERE schemaname = s.schemaname)
THEN NULL-- schema exists but last_analyze is NULL
WHEN ss.last_analyze IS NULL THEN 'NA'
ELSE ss.last_analyze::text
END AS last_analyze
FROM schema_list s LEFT JOIN schema_stats ss
ON s.schemaname = ss.schemaname
ORDER BY s.schemaname;




select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('cdb') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('cdb') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('dwh') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('fep') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('fuel') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('mdms') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('mmg') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('nfms') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('partition_sub') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('public') and table_type='BASE TABLE';

select 'vacuum analyze '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema in('spm') and table_type='BASE TABLE';


SELECT schema_name
FROM information_schema.schemata


