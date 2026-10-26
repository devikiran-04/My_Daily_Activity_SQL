DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 462500..465000 LOOP
with S as
(
select elem->>'OC' OC, elem->>'V' V,meter_number,DCU_TIME,record_status,created_by,create_date,update_by,update_date,server_ip,meter_time
FROM FEP.FEP_CSV_LP inner join bkp.meter_number 
t on t.mtr_number=meter_number ,jsonb_array_elements(meter_parameters::jsonb) elem 
where rn=i and meter_time BETWEEN '2025-06-27 00:00:00' AND '2025-06-30 23:59:59' and status='Success'
and status_message='Successfully Completed'
)
INSERT INTO MDMS.MDM_LOADPROFILE_DATA 
(
id, network_id, administrative_id, customer_id, record_id, lp_date, lp_time, lp_interval, kw_imp, kvar_imp, kva_imp, avg_pf, avg_voltage, avg_current, lp_status, is_record_edited, 
record_status, created_by, create_date, update_by, update_date, server_ip, mtr_number, ir_current, iy_current, ib_current, vrn_voltage, vyn_voltage, vbn_voltage, kw_exp, kva_exp, 
neutral_current, status_bye, average_signal_strength, meter_master_id, varh_q1, varh_q2, varh_q3, varh_q4, new_com_id, request_time, response_time, file_name, source_type, 
avg_temperature, signed_avg_pf, act_power, app_power, rea_power_lag, rea_power_lead, kvarh_exp
)
select id, network_id, administrative_id, customer_id, record_id, lp_date, lp_time, lp_interval, kw_imp, kvar_imp, kva_imp, avg_pf, avg_voltage, avg_current, lp_status, is_record_edited, 
record_status, created_by, create_date, update_by, update_date, server_ip, mtr_number, ir_current, iy_current, ib_current, vrn_voltage, vyn_voltage, vbn_voltage, kw_exp, kva_exp, 
neutral_current, status_bye, average_signal_strength, meter_master_id, varh_q1, varh_q2, varh_q3, varh_q4, new_com_id, request_time, response_time, file_name, source_type, 
avg_temperature, signed_avg_pf, act_power, app_power, rea_power_lag, rea_power_lead, kvarh_exp
from (
select gen_random_uuid() id,NET.id NETWORK_ID,NET.administrative_id,NET.customer_id,gen_random_uuid() record_id,
CASE WHEN cast(to_char((METER_TIME)::TIME,'HH24MISS') as BigInt)=0 
THEN cast(to_char(METER_TIME::DATE-INTERVAL '1 day','YYYYMMDD') as BigInt) ELSE cast(to_char((METER_TIME)::DATE,'YYYYMMDD') as BigInt) END LP_DATE,
case when cast(to_char((METER_TIME)::TIME,'HH24MISS') as BigInt)=0 THEN 240000 ELSE cast(to_char((METER_TIME)::TIME,'HH24MISS') as BigInt) end as LP_TIME,
NET.lp_interval,
(MAX(CASE WHEN OC='1.0.1.29.0.255' THEN V ELSE NULL END)::dECIMAL(24,2)/1000)::dECIMAL(24,3) kw_imp,NULL::NUMERIC(15,5) kvar_imp,
(MAX(CASE WHEN OC='1.0.9.29.0.255' THEN V ELSE NULL END)::DECIMAL(24,2)/1000)::DECIMAL(24,3) kva_imp,
MAX(CASE WHEN OC='1.0.13.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) avg_pf,
MAX(CASE WHEN OC='1.0.12.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) avg_voltage,
MAX(CASE WHEN OC='1.0.11.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) avg_current,
MAX(CASE WHEN OC='1.0.31.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) ir_current,
MAX(CASE WHEN OC='1.0.51.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) iy_current,
MAX(CASE WHEN OC='1.0.71.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) ib_current,
MAX(CASE WHEN OC='1.0.32.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) vrn_voltage,
MAX(CASE WHEN OC='1.0.52.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) vyn_voltage,
MAX(CASE WHEN OC='1.0.72.27.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) vbn_voltage,
(MAX(CASE WHEN OC='1.0.2.29.0.255' THEN V ELSE NULL END)::dECIMAL(24,2)/1000)::dECIMAL(24,3)kw_exp,
(MAX(CASE WHEN OC='1.0.10.29.0.255' THEN V ELSE NULL END)::dECIMAL(24,2)/1000)::dECIMAL(24,3) kva_exp,
MAX(CASE WHEN OC='1.0.128.7.94.255' THEN V ELSE NULL END)::NUMERIC(15,5) neutral_current,
MAX(CASE WHEN OC='0.1.96.12.5.255' THEN V ELSE NULL END)::NUMERIC(15,5) average_signal_strength,
MAX(CASE WHEN OC='1.0.5.29.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) varh_q1,
MAX(CASE WHEN OC='1.0.6.29.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) varh_q2,
MAX(CASE WHEN OC='1.0.7.29.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) varh_q3,
MAX(CASE WHEN OC='1.0.8.29.0.255' THEN V ELSE NULL END)::NUMERIC(15,5) varh_q4,
MAX(CASE WHEN OC='1.0.128.8.98.255' THEN V ELSE NULL END)::NUMERIC(15,5) avg_temperature,
NULL lp_status,0 is_record_edited,1 record_status,'1000-1' created_by,NOW() create_date,NET.new_com_id,meter_time request_time,
DCU_TIME response_time,NULL file_name,'B' source_type,'ETL' update_by,NOW() update_date,'ETL' server_ip,S.meter_number mtr_number,NULL meter_master_id,NULL status_bye,
NULL::NUMERIC(15,5) signed_avg_pf,NULL::NUMERIC(15,5) act_power,NULL::NUMERIC(15,5) app_power,NULL::NUMERIC(15,5) rea_power_lag,NULL::NUMERIC(15,5) rea_power_lead,
NULL::NUMERIC(15,5) kvarh_exp,ROW_NUMBER() OVER (PARTITION BY NET.meter_number,Meter_time ORDER BY NET.meter_number,Meter_time,NET.create_date ) RN
FROM S INNER JOIN mdms.mdm_network_hierarchy NET on NET.meter_number=S.meter_number AND NET.RECORD_STATUS=1
GROUP BY S.meter_number,DCU_TIME,meter_time,NET.id,NET.administrative_id,NET.customer_id,
NET.new_com_id
) H where RN=1 AND NOT EXISTS
( select 1 from mdms.mdm_loadprofile_data lp where lp.mtr_number=H.mtr_number AND lp.lp_date=H.lp_date AND lp.lp_time=H.Lp_time);
-- delete from mdms.mdm_loadprofile_data s using (
-- select lp.mtr_number,lp_Date,lp_Time,min(lp.ctid) min_Ctid 
-- from
-- mdms.mdm_loadprofile_Data lp inner join bkp.meter_number s on s.mtr_number=lp.mtr_number and s.rn=i
-- where
-- lp_Date between 20250101 and 20250228
-- group by lp.mtr_number,lp_Date,lp_Time
-- ) d where s.ctid<>d.min_ctid and s.mtr_number=d.mtr_number and s.lp_Date=d.lp_date and s.lp_Time=d.lp_time;
COMMIT;
        RAISE NOTICE '%', i;
    END LOOP;
END $$;