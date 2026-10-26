
--******LP******
select hvm.vendor_name, mld.lp_date, count(distinct mld.id)
from mdms.mdm_loadprofile_data mld
join cdb.meter_master mm on mld.mtr_number = mm.mtr_number
join cdb.hes_vendor_m hvm on hvm.id = mm.mtr_entry_type
join mdms.mdm_network_hierarchy mnh on mnh.meter_number = mm.mtr_number
Where mld.lp_date between '20250901' and '20250902'
--and hvm.vendor_name = 'FGHES'
group by hvm.vendor_name, mld.lp_date order by hvm.vendor_name, mld.lp_date desc;

--**** DLP ***
select hvm.vendor_name, mdbv.meter_time, count(distinct mdbv.meter_number)
from mdms.mdm_daily_billing_view mdbv
join cdb.meter_master mm on mdbv.meter_number = mm.mtr_number
join cdb.hes_vendor_m hvm on hvm.id = mm.mtr_entry_type
join mdms.mdm_network_hierarchy mnh on mnh.meter_number = mm.mtr_number
where mdbv.meter_time between '20250619' and '20250621'
group by hvm.vendor_name, mdbv.meter_time 
order by hvm.vendor_name, mdbv.meter_time desc;



--LAST_RECEIVEDTIME of profiles
select HES_VENDOR,DATA_PROFILE_NAME,MAX(received_time)  AS LAST_RECEIVEDTIME 
FROM MDMS.vee_trans_log 
WHERE received_time>='2025-05-05 00:00:00.000' GROUP BY HES_vENDOR,DATA_PROFILE_NAME


