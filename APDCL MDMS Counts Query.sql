-- EOB 
SELECT 'HES', COUNT(DISTINCT(METER_NUMBER)) FROM fep.fep_csv_eob_ed
where meter_time = '2025-12-01 00:00:00' 
and status='Success' and record_status=1
union all
SELECT 'MDMS',count(distinct meter_number) FROM MDMS.mdm_monthly_billing_view  where lp_date='20251201' and est_flag='ACTUAL'
 

SELECT '20251201' AS dt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_loadprofile_data
WHERE lp_date = '20251201' AND is_record_edited = 0 AND record_status = 1) AS mdm_lp_cnt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_energy_data
WHERE bill_date = '20251201' AND d_type = 1 AND is_record_estimated = 0 AND record_status = 1) AS mdm_ed_cnt,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM MDMS.mdm_loadprofile_data_INVALID
WHERE lp_date = '20251201' AND is_record_edited = 0 AND record_status = 1) AS mdm_lp_invalid,
(SELECT COUNT(DISTINCT METER_NUMBER) FROM MDMS.mdm_energy_data_INVALID
WHERE bill_date = '20251201' AND d_type = 1 AND record_status = 1) AS mdm_ed_invalid,
(SELECT COUNT(DISTINCT METER_NUMBER) FROM fep.fep_csv_lp
WHERE meter_time BETWEEN '2025-12-01 00:00:00' AND '2025-12-01 23:59:59' AND status = 'Success' AND record_status = 1) AS hes_lp,
(SELECT COUNT(DISTINCT METER_NUMBER) FROM fep.fep_csv_ed
WHERE meter_time BETWEEN '2025-12-01 00:00:00' AND '2025-12-01 23:59:59' AND status = 'Success' AND record_status = 1) AS hes_ed,
(SELECT COUNT(DISTINCT MTR_NUMBER) FROM spm.mdm_energy_data_clone
WHERE bill_date = '2025-12-01 00:00:00' AND d_type = 1 AND created_by <> 'SURVEY') AS spm_ed_clone;
