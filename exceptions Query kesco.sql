--DLP
select status_message,count(distinct meter_number) cnt from (
select *,row_number() over(partition by ed.meter_number order by ed.meter_time desc) rn from fep.fep_csv_ed ed (nolock) where ed.record_status=1
and ed.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59'
and ed.status='Failure' and ed.meter_number not in (
select a.meter_number from fep.fep_csv_ed a (nolock) where a.meter_number=ed.meter_number and a.record_status=1 and a.status='Success' 
and a.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59')
)Z where rn=1 group by status_message


--BLP

select status_message,count(distinct meter_number) cnt from (
select *,row_number() over(partition by ed.meter_number order by ed.meter_time desc) rn from fep.fep_csv_lp ed (nolock) where ed.record_status=1
and ed.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59'
and ed.status='Failure' and ed.meter_number not in (
select a.meter_number from fep.fep_csv_lp a (nolock) where a.meter_number=ed.meter_number and a.record_status=1 and a.status='Success' 
and a.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59')
--and meter_number='GP4986077'
)Z where rn=1 group by status_message



--EOB
select status_message,count(distinct meter_number) cnt from (
select *,row_number() over(partition by ed.meter_number order by ed.meter_time desc) rn from fep.fep_csv_eob_ed ed (nolock) where ed.record_status=1
and ed.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59'
and ed.status='Failure' and ed.meter_number not in (
select a.meter_number from fep.fep_csv_eob_ed a (nolock) where a.meter_number=ed.meter_number and a.record_status=1 and a.status='Success' 
and a.meter_time between '2026-09-17 00:00:00' and '2026-09-17 23:59:59')
--and meter_number='GP4986077'
)Z where rn=1 group by status_message



SELECT DISTINCT METER_NUMBER FROM FEP.FEP_CSV_EOB_ED WHERE METER_TIME between '2024-02-01 00:00:00' and '2024-02-01 23:59:59' --total meters


SELECT DISTINCT METER_NUMBER FROM FEP.FEP_CSV_EOB_ED (NOLOCK)  WHERE METER_TIME between '2024-02-01 00:00:00' and '2024-02-01 23:59:59'
AND STATUS='Success' -- billed meters
