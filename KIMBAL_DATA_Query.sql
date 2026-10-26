with k as (
select a.mtr_number mtr_number,h.vendor_code  vendor_name from cdb.meter_master a
inner join cdb.hes_vendor_m h on h.id=a.mtr_entry_type
inner join cdb.consumer_meter_relation c on c.meter_id =a.id and c.record_status =1
INNER JOIN mdms.mdm_network_hierarchy n ON n.meter_number=a.mtr_number AND n.record_status=1
--where sat_sTATUS IN ('NON-SAT','Pending')
and h.vendor_code ='KIMBAL HES' 
and c.mtr_installed_date <'2025-07-01 00:00:00'
)
,lp as (
select t.mtr_number, t.lp_date, t.lp_time 
from k 
inner join mdms.mdm_loadprofile_data t on t.mtr_number =k.mtr_number
and t.lp_date BETWEEN 20250701 AND 20250731 
--and t.lp_time in (select lt.lp_time lp_time from bkp.lp_time lt)
union all
select t1.mtr_number,t1.lp_date, t1.lp_time 
from k
inner join mdms.mdm_loadprofile_data_invalid t1 on t1.mtr_number =k.mtr_number 
and t1.lp_date BETWEEN 20250701 AND 20250731 and t1.update_by='MIC'
--and t1.lp_time in (select lt.lp_time lp_time from bkp.lp_time lt)
)
select k.mtr_number,vendor_name,
count(distinct case when t.lp_date=20250701 then t.lp_time else null end) as july01,
count(distinct case when t.lp_date=20250702 then t.lp_time else null end) as july02,
count(distinct case when t.lp_date=20250703 then t.lp_time else null end) as july03,
count(distinct case when t.lp_date=20250704 then t.lp_time else null end) as july04,
count(distinct case when t.lp_date=20250705 then t.lp_time else null end) as july05,
count(distinct case when t.lp_date=20250706 then t.lp_time else null end) as july06,
count(distinct case when t.lp_date=20250707 then t.lp_time else null end) as july07,
count(distinct case when t.lp_date=20250708 then t.lp_time else null end) as july08,
count(distinct case when t.lp_date=20250709 then t.lp_time else null end) as july09,
count(distinct case when t.lp_date=20250710 then t.lp_time else null end) as july10,
count(distinct case when t.lp_date=20250711 then t.lp_time else null end) as july11,
count(distinct case when t.lp_date=20250712 then t.lp_time else null end) as july12,
count(distinct case when t.lp_date=20250713 then t.lp_time else null end) as july13,
count(distinct case when t.lp_date=20250714 then t.lp_time else null end) as july14,
count(distinct case when t.lp_date=20250715 then t.lp_time else null end) as july15,
count(distinct case when t.lp_date=20250716 then t.lp_time else null end) as july16,
count(distinct case when t.lp_date=20250717 then t.lp_time else null end) as july17,
count(distinct case when t.lp_date=20250718 then t.lp_time else null end) as july18,
count(distinct case when t.lp_date=20250719 then t.lp_time else null end) as july19,
count(distinct case when t.lp_date=20250720 then t.lp_time else null end) as july20,
count(distinct case when t.lp_date=20250721 then t.lp_time else null end) as july21,
count(distinct case when t.lp_date=20250722 then t.lp_time else null end) as july22,
count(distinct case when t.lp_date=20250723 then t.lp_time else null end) as july23,
count(distinct case when t.lp_date=20250724 then t.lp_time else null end) as july24,
count(distinct case when t.lp_date=20250725 then t.lp_time else null end) as july25,
count(distinct case when t.lp_date=20250726 then t.lp_time else null end) as july26,
count(distinct case when t.lp_date=20250727 then t.lp_time else null end) as july27,
count(distinct case when t.lp_date=20250728 then t.lp_time else null end) as july28,
count(distinct case when t.lp_date=20250729 then t.lp_time else null end) as july29,
count(distinct case when t.lp_date=20250730 then t.lp_time else null end) as july30,
count(distinct case when t.lp_date=20250731 then t.lp_time else null end) as july31
--count(distinct case when t.lp_date=20250631 then t.lp_time else null end) as may21
from k  
left join lp t on k.mtr_number=t.mtr_number 
group by k.mtr_number,vendor_name