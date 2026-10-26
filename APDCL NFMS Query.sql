select mtr_number, count (1) from mdms.mdm_loadprofile_data where lp_date='20250204'  group by  mtr_number having count (1)>= 24
 
select  distinct (meter_number) from nfms.daily_loadprofile_data where meter_number  in (select meter_number from mdms.mdm_loadprofile_data where create_date between '2025-02-04 00:00:00' and '2025-02-04 00:00:00'
and meter_number in  (
select meter_number from mdms.MDM_NETWORK_HIERARCHY where RECORD_STATUS =1 and ELEMENT_TYPE = 'F' and meter_number is not null
))and meter_number in (select meter_number from NFMS.NETWORK_GROUPS_DETAILS
where
group_name ='JB_TEST')
 
--LP:
 
with trans as(
select lp_date,count(distinct mtr_number) trans_mtr_cnt from mdms.mdm_loadprofile_Data where lp_DATE between 20260426 and 20260531
and mtr_number in (select meter_number from mdms.mdm_network_hierarchy where record_Status =1 and ELEMENT_TYPE = 'F' and METER_NUMBER is not null)
group by lp_date having count(distinct lp_time) >= 48
),nfms as(
select lp_date,count(distinct meter_number) nfms_mtr_cnt from nfms.block_loadprofile_data where lp_date between 20260426 and 20260531
group by lp_date    
),audit as(
select to_char(meter_time,'YYYYMMDD')::int lp_Date,count(distinct feeder_code) aud_fdr_Cnt from nfms.audit_log where profile_name = 'BlockLoad'
and to_char(meter_time,'YYYYMMDD')::int between 20260426 and 20260531  group by to_char(meter_time,'YYYYMMDD')::int
)
select trans.lp_date,trans.trans_mtr_cnt,nfms.nfms_mtr_cnt,audit.aud_fdr_Cnt from trans
left join nfms on trans.lp_date =nfms.lp_Date
left join audit on trans.lp_date =audit.lp_Date
order by trans.lp_date desc;
 

--ED:
 
with trans as(
select bill_date,count(distinct mtr_number) trans_mtr_cnt from mdms.mdm_Energy_Data where d_type = 1 and BILL_DATE between 20260426 and 20260531
and mtr_number in (select meter_number from mdms.mdm_network_hierarchy where record_Status =1 and ELEMENT_TYPE = 'F' and METER_NUMBER is not null)
group by bill_date
),nfms as(
select lp_date,count(distinct meter_number) nfms_mtr_cnt from nfms.daily_loadprofile_data where lp_date between 20260426 and 20260531
group by lp_date
),audit as(
select to_char(meter_time,'YYYYMMDD')::int lp_Date,count(distinct feeder_code) aud_fdr_Cnt from nfms.audit_log where profile_name = 'DailyProfile'
and to_char(meter_time,'YYYYMMDD')::int between 20260426 and 20260531 group by to_char(meter_time,'YYYYMMDD')
)
select trans.bill_date,trans.trans_mtr_cnt,nfms.nfms_mtr_cnt,audit.aud_fdr_Cnt from trans
left join nfms on trans.bill_date =nfms.lp_Date
left join audit on trans.bill_date =audit.lp_Date
order by trans.bill_date desc;
 
--Events:
 
with trans as(
select event_Date lp_date,count(distinct meter_number) trans_mtr_cnt from mdms.mdm_event_Details where event_Date between 20260426 and 20260531
and meter_number in (select meter_number from mdms.mdm_network_hierarchy where record_Status =1 and ELEMENT_TYPE = 'F' and METER_NUMBER is not null)
group by event_Date
),nfms as(
select to_char(eventdatetime,'YYYYMMDD')::int lp_date,count(distinct meter_number) nfms_mtr_cnt from nfms.EVENTS_DATA
where to_char(eventdatetime,'YYYYMMDD')::int between 20260426 and 20260531
group by to_char(eventdatetime,'YYYYMMDD')::int
),audit as(
select to_char(meter_time,'YYYYMMDD')::int lp_Date,count(distinct feeder_code) aud_fdr_Cnt from nfms.audit_log where profile_name = 'DeviceEvent'
and to_char(meter_time,'YYYYMMDD')::int between 20260426 and 20260531 group by to_char(meter_time,'YYYYMMDD')::int
)
select trans.lp_date,trans.trans_mtr_cnt,nfms.nfms_mtr_cnt,audit.aud_fdr_Cnt from trans
left join nfms on trans.lp_date =nfms.lp_Date
left join audit on trans.lp_date =audit.lp_Date
order by trans.lp_date desc;
 
--EOB:
with trans as(
select lp_date,count(distinct meter_number) trans_mtr_cnt from mdms.mdm_monthly_billing_view where lp_DATE between 20260426 and 20260531
and meter_number in (select meter_number from mdms.mdm_network_hierarchy where record_Status =1 and ELEMENT_TYPE = 'F' and METER_NUMBER is not null)
group by lp_date
),nfms as(
select lp_date,count(distinct meter_number) nfms_mtr_cnt from nfms.monthly_billing_data where lp_date between 20260426 and 20260531
group by lp_date
),audit as(
select to_char(meter_time,'YYYYMMDD')::int lp_Date,count(distinct feeder_code) aud_fdr_Cnt from nfms.audit_log where profile_name = 'BillingProfile'
and to_char(meter_time,'YYYYMMDD')::int between 20260426 and 20260531 group by to_char(meter_time,'YYYYMMDD')::int
)
select trans.lp_date,trans.trans_mtr_cnt,nfms.nfms_mtr_cnt,audit.aud_fdr_Cnt from trans
left join nfms on trans.lp_date =nfms.lp_Date
left join audit on trans.lp_date =audit.lp_Date
order by trans.lp_date desc6