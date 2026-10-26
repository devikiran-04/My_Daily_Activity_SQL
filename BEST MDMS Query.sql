
SELECT '20260925' AS dt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_loadprofile_data
WHERE lp_date = '20260925'AND is_record_edited = 0 AND record_status = 1) AS mdm_lp_cnt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_energy_data
WHERE bill_date = '20260925' AND d_type = 1 AND is_record_estimated = 0 AND record_status = 1) AS mdm_ed_cnt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_loadprofile_data_INVALID
WHERE lp_date = '20260925' AND is_record_edited = 0 AND record_status = 1) AS mdm_lp_invalid,
(SELECT COUNT(DISTINCT METER_NUMBER) FROM MDMS.mdm_energy_data_INVALID
WHERE bill_date = '20260925' AND d_type = 1 AND record_status = 1) AS mdm_ed_invalid,
(SELECT COUNT(DISTINCT meter_number) FROM MDMS.mdm_monthly_billing_view_current
WHERE LP_date = '20260925') AS mdm_eob_cnt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM spm.mdm_energy_data_clone
WHERE bill_date = '2026-09-25 00:00:00' AND d_type = 1 AND created_by <> 'SURVEY') AS spm_ed_clone;


---STAGE TABLE COUNTS---
SELECT DATE(METER_TIME) AS D, hes_vendor_name, 'EOB' AS table_name, COUNT(DISTINCT(METER_NUMBER)) AS daily_success_count
FROM MDMS.MDMS_CSV_EOB_ED WHERE STATUS = 'Success' AND STATUS_MESSAGE = 'Successfully Completed'
AND METER_TIME >= '2026-07-26'::date AND METER_TIME < '2026-07-26'::date + INTERVAL '1 day'
GROUP BY hes_vendor_name, DATE(METER_TIME)
union all
---STAGE TABLE COUNTS---
SELECT DATE(METER_TIME) AS D, hes_vendor_name, 'LP' AS table_name, COUNT(DISTINCT(METER_NUMBER)) AS daily_success_count
FROM MDMS.MDMS_CSV_LP WHERE STATUS = 'Success' AND STATUS_MESSAGE = 'Successfully Completed'
AND METER_TIME >= '2026-07-26'::date AND METER_TIME < '2026-07-26'::date + INTERVAL '1 day'
GROUP BY hes_vendor_name, DATE(METER_TIME)
UNION ALL
SELECT DATE(METER_TIME) AS D, hes_vendor_name, 'ED' AS table_name, COUNT(DISTINCT(METER_NUMBER)) AS daily_success_count
FROM MDMS.MDMS_CSV_ED WHERE STATUS = 'Success' AND STATUS_MESSAGE = 'Successfully Completed'
AND METER_TIME >= '2026-07-26'::date AND METER_TIME < '2026-07-26'::date + INTERVAL '1 day'
GROUP BY hes_vendor_name, DATE(METER_TIME) ORDER BY hes_vendor_name, D;
 
 




--VEE Kettle Job--
--LP--
select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_LP Where record_status=1 order by create_date asc

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_LP Where record_status=0 order by create_date desc limit 2000

--ED--
select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_ED Where record_status=1 order by create_date asc

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_ED Where record_status=0 order by create_date desc limit 2000

--EOB--
select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EOB Where record_status=1 order by create_date asc

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EOB Where record_status=0 order by create_date desc

--update MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EOB set record_status = 1 where record_status=1 and table_name in ('kettle.MDM_STG_ED_20260728015021974_3805091_112236',
'kettle.MDM_STG_ED_20260728022515367_3805091_112432')
create_date between '2026-07-28 00:00:00' and '2026-07-28 23:45:45'

select * from pg_tables 


--update MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EOB set record_status = 1 where record_status=1

select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EVENTS Where record_status=1 order by create_date asc


select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_INSTANT Where record_status=1 order by create_date asc


select * from MDMS.MDMS_VEE_KETTLE_JOB_INTEG_PF Where record_status=1 order by create_date asc


SELECT * FROM FEP.fep_monthly_billing_ot_view
order by eob_mtr_time --between '06/04/2026' and 
limit 10000



select * from pg_tables where tablename like '%event%' and schemaname='mdms'  


select count(*) from mdms.mdm_event_details
where event_date = '20260415'


select count(*) from mdms.mdms_csv_events
where meter_time between '2026-04-15 00:00:00' and '2026-04-15 23:59:59'


select * from mdms.mdms_vee_kettle_job_integ_events Where record_status=1 order by create_date asc




select count(*) from mdms.mdm_event_vee
group by event_date
order by event_date



update MDMS.MDMS_VEE_KETTLE_JOB_INTEG_EOB set record_status = 1 where record_status=-1 and create_date::date='2026-10-02'
