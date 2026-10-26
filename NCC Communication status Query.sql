
SELECT flag as status ,COUNT (distinct meter_number) as Counts FROM (
select 
meter_number, mtr_last_communicated, duration, last_gasp_dt as max_powerfailured_time, last_breath_dt max_powerrestored_time,
case when last_breath_dt>last_gasp_dt and mtr_last_communicated is not null then 'NonComm' 
    when last_breath_dt<last_gasp_dt and mtr_last_communicated is not null then 'Power Failure state'
    when  mtr_last_communicated is  null then 'Never Comm' else 'NonComm' end as flag
from dwh.hes_non_communication_view 
) GROUP BY flag

