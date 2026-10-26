

----    DLP -----------------


select hes_vendor,sum(cnt)cnt  from (select hes_vendor ,count(distinct mtr_number) cnt from mdms.mdm_energy_data med
inner join sla_t.group_meter_sat gms  on  gms.meter_number =med.mtr_number
where bill_date =20250729
AND d_type = 1
     AND record_status = 1
group by gms.hes_vendor
union
select hes_vendor ,count(distinct med.meter_number)cnt from mdms.mdm_energy_data_invalid med
inner join sla_t.group_meter_sat gms  on  gms.meter_number =med.meter_number
where bill_date =20250729
AND d_type = 1
     AND record_status = 1
group by gms.hes_vendor)k group by hes_vendor



------  BLP ---------------


WITH RankedData AS (
  SELECT *,
           ROW_NUMBER() OVER (PARTITION BY MNO, lp_time ORDER BY TBL, RT) AS rnk
  FROM (
    SELECT mtr_number AS MNO,hes_vendor, lp_date, lp_time,file_name, LEFT(file_name, 3) as HES,update_by, response_time AS RT,create_date CT, 1 AS TBL
    FROM mdms.mdm_loadprofile_data  a inner join sla_t.group_meter_sat  b on a.mtr_number=b.meter_number
    WHERE lp_date = '20250728'
      AND record_status = 1
    UNION
    SELECT mtr_number AS MNO,hes_vendor, lp_date, lp_time,file_name, LEFT(file_name, 3) as HES,update_by, create_time AS RT,create_date CT, 2 AS TBL
    FROM mdms.mdm_loadprofile_data_invalid a inner join sla_t.group_meter_sat  b on a.mtr_number=b.meter_number
    WHERE lp_date ='20250728'
      AND record_status = 1
  ) a
)
SELECT r.LP_Date,hes_vendor, count(distinct r.MNO) No_of_Meters,
count (case when r.tbl=1 then r.tbl else null end) as Valid_Blocks,
count (case when r.tbl=2 then r.tbl else null end) as Invalid_Blocks, count (case when r.tbl is null then 1 else null end) as No_Block_Meter_Count
FROM RankedData r
WHERE (r.rnk = 1) --and r.MNO = 'AIK159667'
group by r.LP_Date,hes_vendor;


--------- event -------------------



select HES_VENDOR,SUM(COUNT) as CNT from (select HES_VENDOR,COUNT(distinct mtr_number) from MDMS.mdm_powerfailure_details m  
inner join SLA_T.group_meter_sat g  on M.mtr_number =G.meter_number
where m.event_date ='20250729'
group by HES_VENDOR
UNION
select HES_VENDOR,COUNT(distinct mtr_number) from MDMS.mdm_powerfailure_details_invalid m
inner join SLA_T.group_meter_sat g  on M.mtr_number =G.meter_number
where m.event_date ='20250729'
group by HES_VENDOR
union
select HES_VENDOR,COUNT(distinct M.mEtEr_number) from MDMS.mdm_event_details m
inner join SLA_T.group_meter_sat g  on M.mEtEr_number =G.meter_number
where m.event_date ='20250729'
group by HES_VENDOR
union
select HES_VENDOR,COUNT(distinct M.mEtEr_number) from MDMS.mdm_event_details_INVALID m
inner join SLA_T.group_meter_sat g  on M.mEtEr_number =G.meter_number
where m.event_date ='20250729'
group by HES_VENDOR
)K group by HES_VENDOR




------------------ALARMS-----------------------


SELECT
    g.HES_VENDOR,
    COUNT(DISTINCT m.meter_id) AS TOTAL_CNT
FROM (
    SELECT meter_id FROM MDMS.mdm_alarm_details WHERE alarm_date::DATE = '2025-07-29'
    UNION ALL
    SELECT meter_id FROM MDMS.mdm_alarm_details_invalid WHERE alarm_date::DATE = '2025-07-29'
) m
INNER JOIN SLA_T.group_meter_sat g
    ON m.meter_id = g.meter_number
GROUP BY g.HES_VENDOR;
 