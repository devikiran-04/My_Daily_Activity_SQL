--response either SUCCESS or FAILED can be seen in below tale 
SELECT response_flag,failure_reason,id,event_date,delivery_status, * from spm.spm_rcdc  WHERE  create_date >='2025-03-05 00:00:00'  order by request_time DESC

--scheduler request can be see in below table
select * FROM spm.intr_req_trans irt  
--where req_type = 'DISCONNECT'
where req_type = 'CONNECT'
AND req_time >= '2025-03-25 00:00:00.000' ORDER BY req_time DESC

Select count(distinct(METER_NUMBER))
from fep.fep_csv_lp --(nolock) 
where record_status=1 and READING_TYPE='S'
and CREATE_DATE between '2025-03-26 00:00:00' and '2025-03-26 23:59:59'
