select 'drop table '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema='kettle' and table_type='BASE TABLE' 
and table_name   like '%072026%' and table_name  NOT like '%08102026%' and table_name like '%f_lp%'
-- and  table_name  not LIKE '%stg%' 
limit 3000
 
select count(*) from (select 'drop table '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema='kettle' and table_type='BASE TABLE' 
and table_name  NOT like '%07102026%' and table_name like '%f_lp%'  )k
 
select count(*) from (
select 'drop table '||table_Schema ||'.'||table_name||';' from information_schema.tables where table_schema='kettle' and table_type='BASE TABLE' 
and table_name   like '%082026%' and table_name  NOT like '%09102026%' and table_name like '%f_pf%')k
 
select count(*) from pg_tables where schemaname='kettle'
and tablename  NOT like '%22102026%'
and tablename   like '%072026%'
and tablename like '%STAT%'

limit 1000


select * from pg_tables where schemaname='kettle'and 
tablename like '%MDSTATS%'
and tablename  NOT like '%22102026%'
limit 1000;
