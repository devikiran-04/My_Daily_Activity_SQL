SELECT 'HES',COUNT(DISTINCT(METER_NUMBER)) FROm fep.fep_csv_eob_ed
where meter_time='2025-08-01 00:00:00' 
and status='Success' and record_status=1
union all
SELECT 'MDMS',COUNT(DISTINCT(METER_NUMBER))  FROM MDMS.mdm_monthly_billing_view  where lp_date=20260201 and est_flag='ACTUAL'

