
--DLP
WITH CombinedReads AS (
  SELECT 
    m.mtr_number AS MNO,
    ven.vendor_name,
    hi.bill_date,
    1 AS TBL,
    hi.response_time AS RT
  FROM cdb.meter_master m
  JOIN mdms.mdm_energy_data hi ON m.mtr_number = hi.mtr_number
  JOIN cdb.hes_vendor_m ven ON m.mtr_entry_type = ven.id
  WHERE hi.bill_date = '20260925'
    AND hi.record_status = 1
    AND m.record_status = 1
    AND ven.record_status = 1
  UNION
  SELECT 
    m.mtr_number AS MNO,
    ven.vendor_name,
    hi.bill_date,
    2 AS TBL,
    hi.create_date AS RT
  FROM cdb.meter_master m
  JOIN mdms.mdm_energy_data_invalid hi ON m.mtr_number = hi.meter_number
  JOIN cdb.hes_vendor_m ven ON m.mtr_entry_type = ven.id
  WHERE hi.bill_date = '20260925'
    AND hi.record_status = 1
    AND m.record_status = 1
    AND ven.record_status = 1
),
RankedReads AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY MNO ORDER BY TBL, RT) AS rnk
  FROM CombinedReads
)
SELECT 
  bill_date,
  vendor_name,
  COUNT(DISTINCT MNO) AS total_reads,
  COUNT(CASE WHEN TBL = 1 THEN 1 END) AS valid_reads,
  COUNT(CASE WHEN TBL = 2 THEN 1 END) AS invalid_reads,
  COUNT(CASE WHEN TBL IS NULL THEN 1 END) AS not_available
FROM RankedReads
WHERE rnk = 1
GROUP BY bill_date, vendor_name;
 

--BLP
WITH CombinedLoadProfile AS (
  SELECT 
    m.mtr_number AS MNO,
    ven.vendor_name,
    hi.lp_date,
    hi.lp_time,
    hi.file_name,
    LEFT(hi.file_name, 3) AS HES,
    hi.update_by,
    hi.response_time AS RT,
    hi.create_date AS CT,
    1 AS TBL
  FROM cdb.meter_master m
  JOIN mdms.mdm_loadprofile_data hi ON m.mtr_number = hi.mtr_number
  JOIN cdb.hes_vendor_m ven ON m.mtr_entry_type = ven.id
  WHERE hi.lp_date = '20260925'
    AND hi.record_status = 1
    AND m.record_status = 1
    AND ven.record_status = 1
  UNION
  SELECT 
    m.mtr_number AS MNO,
    ven.vendor_name,
    hi.lp_date,
    hi.lp_time,
    hi.file_name,
    LEFT(hi.file_name, 3) AS HES,
    hi.update_by,
    hi.create_time AS RT,
    hi.create_date AS CT,
    2 AS TBL
  FROM cdb.meter_master m
  JOIN mdms.mdm_loadprofile_data_invalid hi ON m.mtr_number = hi.mtr_number
  JOIN cdb.hes_vendor_m ven ON m.mtr_entry_type = ven.id
  WHERE hi.lp_date = '20260925'
    AND hi.record_status = 1
    AND m.record_status = 1
    AND ven.record_status = 1
),
RankedData AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY MNO, lp_time ORDER BY TBL, RT) AS rnk
  FROM CombinedLoadProfile
)
SELECT 
  lp_date,
  vendor_name,
  COUNT(DISTINCT MNO) AS no_of_meters,
  COUNT(CASE WHEN TBL = 1 THEN 1 END) AS valid_blocks,
  COUNT(CASE WHEN TBL = 2 THEN 1 END) AS invalid_blocks,
  COUNT(CASE WHEN TBL IS NULL THEN 1 END) AS no_block_meter_count
FROM RankedData
WHERE rnk = 1
GROUP BY lp_date, vendor_name;
 



---STAGE TABLE COUNTS---
SELECT DATE(METER_TIME) AS D, hes_vendor_name, 'LP' AS table_name, COUNT(DISTINCT(METER_NUMBER)) AS daily_success_count
FROM MDMS.MDMS_CSV_LP WHERE STATUS = 'Success' AND STATUS_MESSAGE = 'Successfully Completed'
AND METER_TIME >= '2026-09-25'::date AND METER_TIME < '2026-09-25'::date + INTERVAL '1 day'
GROUP BY hes_vendor_name, DATE(METER_TIME)
UNION ALL
SELECT DATE(METER_TIME) AS D, hes_vendor_name, 'ED' AS table_name, COUNT(DISTINCT(METER_NUMBER)) AS daily_success_count
FROM MDMS.MDMS_CSV_ED WHERE STATUS = 'Success' AND STATUS_MESSAGE = 'Successfully Completed'
AND METER_TIME >= '2026-09-25'::date AND METER_TIME < '2026-09-25'::date + INTERVAL '1 day'
GROUP BY hes_vendor_name, DATE(METER_TIME) ORDER BY hes_vendor_name, D;


------  NCC MDMS ALARMS  ------
select hvm.vendor_name, count(distinct meter_id) mtr_count, count(0) alarm_count
from mdms.mdm_alarm_details mad
inner join cdb.meter_master mm on mad.meter_id = mm.mtr_number and mm.record_status = 1
inner join cdb.hes_vendor_m hvm on mm.mtr_entry_type = hvm.id and hvm.record_status = 1
where alarm_date between '2026-09-25 00:00:00'::timestamp and '2026-09-25 23:59:59'::timestamp
group by hvm.vendor_name;

--select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_lp Where record_status=1 order by create_date asc


--spm billing 
WITH daily_energy AS (
    SELECT 
        (ENC.BILL_DATE - INTERVAL '1 day')::DATE AS dt,
        COUNT(DISTINCT ENC.mtr_number) AS ed_cnt,
        COUNT(DISTINCT bill.meter_number) AS billing_cnt
    FROM SPM.PREPAID_CONSDETAILS_T A
    JOIN SPM.MDM_ENERGY_DATA_CLONE ENC 
         ON A.meter_number = ENC.mtr_number
        AND ENC.record_status = 1
    LEFT JOIN SPM.SPM_BILL_DETAILS_T bill
         ON bill.meter_number = A.meter_number
        AND bill.blissue_dt = (ENC.BILL_DATE - INTERVAL '1 day')
        AND bill.record_status = 1
    WHERE A.record_status = 1
      AND A.cons_type = 'PRE'
      AND A.billing_status = 'L'
      AND ENC.bill_date::date BETWEEN CURRENT_DATE - INTERVAL '6 days' AND CURRENT_DATE
    GROUP BY dt
),
date_range AS (
    SELECT generate_series(
        (SELECT MIN(dt) FROM daily_energy),
        (SELECT MAX(dt) FROM daily_energy),
        INTERVAL '1 day'
    )::DATE AS dt
),
prepaid_raw AS (
    SELECT 
        CREATE_DATE::DATE AS cd,
        COUNT(DISTINCT METER_NUMBER) FILTER (WHERE RECORD_STATUS = 1 AND CONS_TYPE = 'PRE') AS daily_total,
        COUNT(DISTINCT METER_NUMBER) FILTER (WHERE RECORD_STATUS = 1 AND CONS_TYPE = 'PRE' AND BILLING_STATUS = 'BS') AS daily_bs
    FROM SPM.PREPAID_CONSDETAILS_T
    WHERE CREATE_DATE::DATE <= CURRENT_DATE  
    GROUP BY CREATE_DATE::DATE
),
prepaid_running AS (
    SELECT 
        cd,
        SUM(daily_total) OVER (ORDER BY cd) AS total_prepaid,
        SUM(daily_bs) OVER (ORDER BY cd) AS bs,
        SUM(daily_total) OVER (ORDER BY cd) - SUM(daily_bs) OVER (ORDER BY cd) AS live_meters
    FROM prepaid_raw
)
SELECT 
    d.dt, 
    COALESCE(
        pr.total_prepaid,
        (SELECT total_prepaid FROM prepaid_running WHERE cd <= d.dt ORDER BY cd DESC LIMIT 1),
        0
    ) AS total_prepaid,
    COALESCE(
        pr.bs,
        (SELECT bs FROM prepaid_running WHERE cd <= d.dt ORDER BY cd DESC LIMIT 1),
        0
    ) AS bill_stopped,
    COALESCE(
        pr.live_meters,
        (SELECT live_meters FROM prepaid_running WHERE cd <= d.dt ORDER BY cd DESC LIMIT 1),
        0
    ) AS live_meters,
    de.ed_cnt,
    de.billing_cnt,
    (de.ed_cnt - de.billing_cnt) AS un_billed_cnt
FROM date_range d
LEFT JOIN daily_energy de ON d.dt = de.dt
LEFT JOIN prepaid_running pr ON d.dt = pr.cd
ORDER BY d.dt;

