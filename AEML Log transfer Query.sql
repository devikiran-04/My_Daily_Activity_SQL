--LogTransfer status:
----------------------
SELECT TO_CHAR(TIMEID,'DD/MM/YYYY') AS DATE,profilename,
sum(case when status  like '%{status=success}%' then 1 else 0 end ) as Successcnt,
sum(case when status  not like '%{status=success}%' then 1 else 0 end ) as Failurecount
FROM  DWH.XML_AUDIT
where to_char(timeid,'dd/mm/yyyy')='05/05/2025'
--and profilename='INSTDPUSH'
--and status  like '%Success%'
group by profilename,TO_CHAR(TIMEID,'DD/MM/YYYY')

--HES COUNTS CHECKING
----------------------
SELECT '08-07-2025' dt,'LP', COUNT(DISTINCT(METER_NUMBER)) FROm fep.fep_csv_LP
where meter_time between'2025-07-08 00:00:00' and '2025-07-08 23:59:59' and status='Success' and record_status=1
union all
SELECT '08-07-2025' dt,'ED', COUNT(DISTINCT(METER_NUMBER)) FROm fep.fep_csv_ed
where meter_time between '2025-07-08 00:00:00' and '2025-07-08 23:59:59' and status='Success' and record_status=1
union all
SELECT '08-07-2025' dt,'EOB', COUNT(DISTINCT(METER_NUMBER)) FROm fep.fep_csv_eob_ed
where meter_time between '2025-07-08 00:00:00' and '2025-07-31 23:59:59' and status='Success' and record_status=1

--MDMS COUNTS CHECKING
-------------------------
SELECT COUNT( DISTINCT MTR_NUMBER) FROM MDMS.mdm_loadprofile_data WHERE lp_date='20250415' AND is_record_edited=0 AND record_status=1
union all
SELECT COUNT( DISTINCT MTR_NUMBER) FROM MDMS.mdm_energy_data WHERE bill_date='20250415' AND d_type=1 AND is_record_estimated=0 AND record_status=1

--MDMS EOB
---------
SELECT COUNT(DISTINCT(METER_NUMBER)) FROM MDMS.mdm_monthly_billing_view where lp_date=20250301 and est_flag='ACTUAL'
