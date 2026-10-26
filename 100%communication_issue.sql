--AEML dashboard 100% issue
--*****************************
insert into dwh.communication_count
select meter_number,lp_date,lp_cnt,inst_cnt,energy_cnt,eob_ed_cnt,event_cnt,last_comm,inst_push_cnt from(
select * from (select mtr_number as meter_number,'20260925'::bigint lp_date,'0'::bigint lp_cnt,'0'::bigint inst_cnt,'0'::bigint energy_cnt,'0'::bigint eob_ed_cnt,'0'::bigint event_cnt
,greatest(v.lp_max_time,v.ed_max_time,v.eob_max_time,v.instd_max_time) last_comm,'0'::bigint inst_push_cnt 
,row_number() over(partition by mtr_number)rn
from cdb.meter_master mm 
inner join cdb.meter_feild_device_relation fdr on fdr.meter_id=mm.id and mm.record_status=1 and fdr.record_status=1 and mm.mtr_installed_date is not null 
inner join dwh.max_mtr_view  v on v.meter_number=mm.mtr_number 
--and mm.id not in('72a30444-d58d-4864-856c-4a61a0218a75','3d0fb6df-c8c6-4e23-bdd0-2e50b777f043','adf6eb5c-fe1b-4ca8-910b-6be9b49f0a31')
)k where rn=1
and not exists (select 1 from dwh.communication_count cc where cc.meter_number=k.meter_number and cc.lp_date='20260925')
)j