---PSPCL
 
select status_message,count(*) from (
select 
row_number() over(partition by meter_number,to_char(dcu_time,'yyyy-mm-dd') order by dcu_time desc) rn,
* from fep.fep_csv_ED where meter_time between '2025-04-17 00:00:00'
and '2025-04-17 23:59:59' and --meter_number='5001217' and 
status<>'Success' 
	)j where rn=1 group by status_message;



---PSPCL
 
select status_message,count(*) from (
select 
row_number() over(partition by meter_number,to_char(dcu_time,'yyyy-mm-dd') order by dcu_time desc) rn,
* from fep.fep_csv_lp where meter_time between '2024-02-02 00:00:00'
and '2024-02-02 23:59:59' and --meter_number='5001217' and 
status<>'Success' 
	)j where rn=1 group by status_message





--EOB
select status_message,count(distinct meter_number) cnt from (
select *,row_number() over(partition by ed.meter_number order by ed.meter_time desc) rn from fep.fep_csv_eob_ed ed (nolock) where ed.record_status=1
and ed.meter_time between '2024-07-01 00:00:00' and '2024-07-01 23:59:59'
and ed.status='Failure' and ed.meter_number not in (
select a.meter_number from fep.fep_csv_eob_ed a (nolock) where a.meter_number=ed.meter_number and a.record_status=1 and a.status='Success' 
and a.meter_time between '2024-07-01 00:00:00' and '2024-07-01 23:59:59')
--and meter_number='GP4986077'
)Z where rn=1 group by status_message


