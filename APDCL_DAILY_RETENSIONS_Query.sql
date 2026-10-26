

delete from  MDMS.MDM_ENERGY_VEE where bill_date<= to_char(now()- interval '3 day','YYYYMMDD')::int;
vacuum analyze MDMS.MDM_ENERGY_VEE;
 

delete from  MDMS.MDM_LP_DATA_VEE where lp_date<= to_char(now()- interval '15 day','YYYYMMDD')::int;
vacuum analyze MDMS.MDM_LP_DATA_VEE;
 
delete from mdms.mdm_demand_data_vee where dm_date<= to_char(now()- interval '15 day','YYYYMMDD')::int;
vacuum analyze mdms.mdm_demand_data_vee;
 
 

delete from mdms.mdm_pf_data_vee where event_date<= to_char(now()- interval '7 day','YYYYMMDD')::int;
vacuum analyze mdms.mdm_pf_data_vee;
 

delete from mdms.mdm_instant_vee where read_date<= to_char(now()- interval '15 day','YYYYMMDD')::int;
vacuum analyze mdms.mdm_instant_vee;
 

delete from  mdms.mdm_alarm_vee where alarm_date<= now()- interval '15 day';
vacuum analyze mdms.mdm_alarm_vee;
 

delete from mdms.mdm_event_vee where event_date<= to_char(now()- interval '7 day','YYYYMMDD')::int;
vacuum analyze mdms.mdm_event_vee

