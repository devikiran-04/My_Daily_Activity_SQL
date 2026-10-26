
select * from fep.fep_job_schedule_log
where start_time between '2026-08-26 00:00:00' and '2026-08-26 23:59:59'
order by start_time desc;


select *
from fep.fep_csv_ed
where meter_time between '2026-08-26 00:00:00' and '2026-08-26 23:59:59'
and transaction_id = 'bccb9f9f-6051-4f85-89a1-aff484b43e84'
and status = 'Success';


UPDATE fep.fep_job_schedule_log SET success = (SELECT COUNT(*) FROM fep.fep_csv_ed WHERE transaction_id = 'bccb9f9f-6051-4f85-89a1-aff484b43e84' AND status = 'Success' AND meter_time BETWEEN '2026-08-26 00:00:00' AND '2026-08-26 23:59:59')
WHERE id = 'bccb9f9f-6051-4f85-89a1-aff484b43e84';

