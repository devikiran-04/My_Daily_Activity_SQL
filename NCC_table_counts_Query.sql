select * from fep.fep_job_schedule_log
where start_time between '2026-02-17 00:00:00' and '2026-02-17 23:59:59'
order by start_time desc

--schedule_job_report
select *--,job_name, job_group_name, start_time, end_time, total_cnt, success, failure
from fep.fep_job_schedule_log
where start_time::date = '2026-09-16'
order by start_time desc
--********************************************************************************************************************************
--********************************************************************************************************************************
--success counts
select '1.ED' as profile_name,count(distinct meter_number) as Success_counts 
from fep.fep_csv_ed
where meter_time::date = '2026-09-16'
and status = 'Success'
union all
select '2.LP' as profile_name ,count(distinct meter_number) as Success_counts 
from fep.fep_csv_lp
where meter_time::date = '2026-09-16'
and status = 'Success' --11693
union all
select '3.INST' as profile_name ,count(distinct meter_number) as Success_counts 
from fep.fep_csv_instant
where meter_time::date = '2026-09-16'
and status = 'Success'
union all
select '4.EOB' as profile_name , count(distinct meter_number) as Success_counts 
from fep.fep_csv_eob_ed
where meter_time::date = '2026-09-16'
and status = 'Success'
order by profile_name;
--********************************************************************************************************************************
--********************************************************************************************************************************
--Failure Counts
select '1.ED' as profile_name, --status,
count(distinct meter_number) as Failure_counts 
from fep.fep_csv_ed
where meter_time::date = '2026-09-16'
and status = 'Failure'
group by status
union all
select '2.LP' as profile_name, count(distinct meter_number) as Failure_counts 
from fep.fep_csv_lp
where meter_time::date = '2026-09-16'
and status = 'Failure'
union all
select '3.INST' as profile_name,count(distinct meter_number) as Failure_counts 
from fep.fep_csv_instant
where meter_time::date = '2026-09-16'
and status = 'Failure'
union all
select '4.EOB' as profile_name, count(distinct meter_number) as Failure_counts 
from fep.fep_csv_eob_ed
where meter_time between '2025-03-01 00:00:00' and '2026-09-01 23:59:59'
and status = 'Failure'
order by profile_name

