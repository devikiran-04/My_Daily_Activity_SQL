--DAY WISE DLP NOT RECEIVED SAT 1-5 meters

WITH dates AS (
    SELECT generate_series(
        DATE '2024-12-02',
        DATE '2025-01-01',
        INTERVAL '1 day'
    )::date AS dt
),
meter_base AS (
    SELECT meter_number
    FROM bkp.sat_final_meters
),
ed_success AS (
    SELECT DISTINCT
        meter_number,
        meter_time::date AS dt
    FROM fep.fep_csv_ed
    WHERE status = 'Success'
      AND meter_time::date BETWEEN DATE '2024-12-02' AND DATE '2025-01-01'
)
SELECT
    d.dt AS date,
    m.meter_number
FROM dates d
CROSS JOIN meter_base m
LEFT JOIN ed_success e
       ON e.dt = d.dt
      AND e.meter_number = m.meter_number
WHERE e.meter_number IS NULL
ORDER BY d.dt, m.meter_number;


--DAY WISE DLP NOT RECEIVED SAT 1-5 meters
----------------------------------------------------------
select count(*) from (select METER_NUMBER 
from bkp.sat_final_meters
except
select  distinct meter_number from(
select meter_number,meter_time,dcu_time,row_number() over(partition by meter_number order by dcu_time) rn from fep.fep_csv_ed where 
meter_time='2026-01-02 00:00:00'
and status='Success' and meter_number in(select METER_NUMBER from bkp.sat_final_meters )
)k where rn=1);



--BLP COUNTS DAY WISE>=96 INTERVAL
----------------------------------------
select lp_date,count(distinct meter_number) 
from dwh.communication_count_data 
where lp_date between '20251202' and '20260101' 
and meter_number in(select METER_NUMBER from bkp.sat_final_meters )
and lp_cnt>=96
group by lp_date


--EOB Received 
----------------------------------
select * from (SELECT meter_number,meter_time,dcu_time,row_number() over(partition by meter_number order by dcu_time) rn 
from fep.fep_csv_eob_ed where meter_time='2025-11-01 00:00:00'
and status='Success' and meter_number in(select METER_NUMBER from bkp.sat_final_meters )
)k where rn=1




SELECT rolname FROM pg_roles;
