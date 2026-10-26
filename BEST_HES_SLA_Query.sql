BLP
---
ORIGINAL BLP counts---SLADATE 10TH,METER TIME 9TH DCUTIME---9TH 15TO 10TH 24
------------
SELECT count(distinct t.meter_number)
FROM fep.fep_csv_lp t
inner join  bkp.sat_final_meters S on s.meter_number=t.meter_number
WHERE  
t.meter_time BETWEEN '2026-04-09 00:00:15'
                    AND '2026-04-09 00:00:00'::timestamp + interval'1 day'
AND t.dcu_time  between  '2026-04-09 00:00:00' and '2026-04-09 24:00:00'::timestamp +interval '1 day' and t.status='Success';
 
 
DATA AVAILBILITY BLP---SLA DATE2ND----METERTIME---1ST----DCUTIME->2ND
--------------------
SELECT count(distinct t.meter_number)
FROM fep.fep_csv_lp t
inner join  bkp.sat_final_meters S on s.meter_number=t.meter_number
WHERE  
t.meter_time BETWEEN '2026-06-20 00:00:15'
                    AND '2026-06-20 00:00:00'::timestamp + interval'1 day'
--AND t.dcu_time> '2026-04-01 23:59:59'::timestamp + interval'1 day' 
and t.status='Success';
 
 
NOT AVAIBLE METERS BLP
-----------------------
SELECT METER_NUMBER FROM bkp.sat_final_meters
EXCEPT
SELECT count(distinct t.meter_number)
FROM fep.fep_csv_lp t
inner join  bkp.sat_final_meters S on s.meter_number=t.meter_number
WHERE  
t.meter_time BETWEEN '2026-04-01 00:00:15'
                    AND '2026-04-01 00:00:00'::timestamp + interval'1 day'
AND t.dcu_time> '2026-04-01 23:59:59'::timestamp + interval'1 day' and t.status='Success';














----DLP----------------------------------------
data avaiability
************************************************************

select count(distinct meter_number)--,meter_time,dcu_time,row_number()over() 
from FEP.FEP_CSV_ED 
WHERE METER_NUMBER IN(SELECT METER_NUMBER FROM bkp.sat_final_meters )
    AND meter_time='2026-06-02 00:00:00'
--    AND dcu_time >= '2026-06-02 00:00:00' 
and status='Success' and status_message = 'Successfully Completed'

 
not avaible meters
--------------------
SELECT METER_NUMBER FROM bkp.sat_final_meters
except
select distinct meter_number--,meter_time,dcu_time,row_number()over() 
from FEP.FEP_CSV_ED 
WHERE METER_NUMBER IN(SELECT METER_NUMBER FROM bkp.sat_final_meters )
    AND meter_time='2026-06-03 00:00:00'
    --AND dcu_time >= '2026-06-02 00:00:00' 
and status='Success' and status_message = 'Successfully Completed'

Original Data Availability
----------------
select count(distinct meter_number) from  fep.fep_csv_ed where meter_time='2026-06-02 00:00:00' 
and dcu_time between '2026-06-02 00:00:00' and '2026-06-02 23:59:59' 
and status='Success' and status_message = 'Successfully Completed'
--and create_date < '2026-06-13 23:59:59' 
--and record_status ='1'
and meter_number in(select meter_number from bkp.sat_final_meters );
