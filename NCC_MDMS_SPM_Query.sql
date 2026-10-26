------ DLP ----------- 
WITH RankedData AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY MNO ORDER BY TBL, RT) AS rnk
FROM (SELECT mtr_number AS MNO,hes_vendor, bill_date, file_name, LEFT(file_name, 3) 
as HES,update_by, response_time AS RT,create_date CT, 1 AS TBL FROM mdms.mdm_energy_data 
a inner join sla_t.group_meter_sat  b on a.mtr_number=b.meter_number WHERE bill_date = '20251011'
AND d_type = 1 AND record_status = 1
UNION
SELECT a.meter_number AS MNO,hes_vendor, bill_date, file_name, LEFT(file_name, 3) 
as HES,update_by, create_date AS RT,create_date CT, 2 AS TBL FROM mdms.mdm_energy_data_invalid 
a inner join sla_t.group_meter_sat  b on a.meter_number=b.meter_number WHERE bill_date = '20251011'
AND d_type = 1 AND record_status = 1 ) a )
SELECT r.bill_date,hes_vendor,count(distinct r.MNO) Total_reads, 
count (case when r.tbl=1 then r.tbl else null end) as Valid_Reads,
count (case when r.tbl=2 then r.tbl else null end) as Invalid_Reads, 
count (case when r.tbl is null then 1 else null end) as Not_Available
FROM RankedData r WHERE (r.rnk = 1) group by r.bill_date,hes_vendor;



---------------  BLP ---------------
WITH RankedData AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY MNO, lp_time ORDER BY TBL, RT) AS rnk
FROM (SELECT mtr_number AS MNO,hes_vendor, lp_date, lp_time,file_name, LEFT(file_name, 3) as 
HES,update_by, response_time AS RT,create_date CT, 1 AS TBL FROM mdms.mdm_loadprofile_data  
a inner join sla_t.group_meter_sat  b on a.mtr_number=b.meter_number WHERE lp_date = '20251011'
AND record_status = 1 
UNION
SELECT mtr_number AS MNO,hes_vendor, lp_date, lp_time,file_name, LEFT(file_name, 3) 
as HES,update_by, create_time AS RT,create_date CT, 2 AS TBL FROM mdms.mdm_loadprofile_data_invalid 
a inner join sla_t.group_meter_sat  b on a.mtr_number=b.meter_number WHERE lp_date ='20251011'
  ) a
)
SELECT r.LP_Date,hes_vendor, count(distinct r.MNO) No_of_Meters,
count (case when r.tbl=1 then r.tbl else null end) as Valid_Blocks,
count (case when r.tbl=2 then r.tbl else null end) as Invalid_Blocks, count (case when r.tbl is null then 1 else null end) as No_Block_Meter_Count
FROM RankedData r
WHERE (r.rnk = 1) --and r.MNO = 'AIK159667'
group by r.LP_Date,hes_vendor;



select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_ED Where record_status=1

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_LP Where record_status=1

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EVENTS Where record_status=1


--NCC BIHAR SPM BILLING--
SELECT 
DT,TOTAL_PREPAID, BS AS BILL_STOPPED, (TOTAL_PREPAID - BS) AS LIVE_METERS, ED_CNT, BILLING_CNT, UN_BILLED_CNT
FROM(SELECT DT, (SELECT COUNT(DISTINCT A.METER_NUMBER) FROM SPM.PREPAID_CONSDETAILS_T A 
WHERE A.RECORD_STATUS = 1 AND A.CONS_TYPE = 'PRE' 
AND A.CREATE_DATE::DATE <= DT) AS TOTAL_PREPAID, (SELECT COUNT(DISTINCT A.METER_NUMBER) 
FROM SPM.PREPAID_CONSDETAILS_T A  
WHERE A.RECORD_STATUS = 1  AND A.CONS_TYPE = 'PRE' 
AND A.BILLING_STATUS = 'BS' AND A.CREATE_DATE::DATE <= DT) AS BS, ED_CNT, BILLING_CNT, UN_BILLED_CNT
FROM (SELECT DT, ED_CNT, BILLING_CNT, (ED_CNT - BILLING_CNT) AS UN_BILLED_CNT
FROM (SELECT (ENC.BILL_DATE - INTERVAL '1 day')::DATE AS DT, COUNT(DISTINCT ENC.MTR_NUMBER) AS ED_CNT,
COUNT(DISTINCT BILL.METER_NUMBER) AS BILLING_CNT FROM SPM.PREPAID_CONSDETAILS_T A       
INNER JOIN SPM.MDM_ENERGY_DATA_CLONE ENC 
ON A.METER_NUMBER = ENC.MTR_NUMBER AND A.RECORD_STATUS = 1 AND A.CONS_TYPE = 'PRE' AND A.BILLING_STATUS = 'L'
AND ENC.RECORD_STATUS = 1  LEFT JOIN SPM.SPM_BILL_DETAILS_T BILL ON A.METER_NUMBER = BILL.METER_NUMBER 
AND BILL.RECORD_STATUS = 1 AND (BILL.BLISSUE_DT + INTERVAL '1 day') = ENC.BILL_DATE
WHERE ENC.BILL_DATE::DATE BETWEEN CURRENT_DATE - INTERVAL '6 days' AND 
CURRENT_DATE GROUP BY (ENC.BILL_DATE - INTERVAL '1 day')::DATE) H ) Z ) A ORDER BY DT ASC;
 


