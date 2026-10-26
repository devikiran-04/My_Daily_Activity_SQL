INSERT INTO DWH.MDM_COMMUNICATION_COUNT (meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id)
select meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id from (
select net.meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, cd.id, cd.office_id,
row_number() over(partition by net.meter_number) rn
from dwh.mdms_communication_count cd
inner join mdms.mdm_network_hierarchy net on net.meter_number=cd.meter_number and net.record_status =1
where lp_date = to_char(now() - interval '0d','yyyymmdd')::bigint
) B where rn =1
ON CONFLICT(METER_NUMBER,LP_DATE)
DO UPDATE
SET LP_CNT=EXCLUDED.LP_CNT,LAST_COMM=COALESCE(EXCLUDED.LAST_COMM,DWH.MDM_COMMUNICATION_COUNT.LAST_COMM);

INSERT INTO DWH.MDM_COMMUNICATION_COUNT (meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id)
select meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id from (
select net.meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, cd.id, cd.office_id,
row_number() over(partition by net.meter_number) rn
from dwh.mdms_communication_count cd
inner join mdms.mdm_network_hierarchy net on net.meter_number=cd.meter_number and net.record_status =1
where lp_date = to_char(now() - interval '0d','yyyymmdd')::bigint
) B where rn =1
ON CONFLICT(METER_NUMBER,LP_DATE)
DO UPDATE
SET energy_CNT=EXCLUDED.energy_CNT,LAST_COMM=COALESCE(EXCLUDED.LAST_COMM,DWH.MDM_COMMUNICATION_COUNT.LAST_COMM);
 
INSERT INTO DWH.MDM_COMMUNICATION_COUNT (meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id)
select meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id from (
select net.meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, cd.id, cd.office_id,
row_number() over(partition by net.meter_number) rn
from dwh.mdms_communication_count cd
inner join mdms.mdm_network_hierarchy net on net.meter_number=cd.meter_number and net.record_status =1
where lp_date = to_char(now() - interval '0d','yyyymmdd')::bigint
) B where rn =1
ON CONFLICT(METER_NUMBER,LP_DATE)
DO UPDATE
SET eob_ed_CNT=EXCLUDED.eob_ed_cnt,LAST_COMM=COALESCE(EXCLUDED.LAST_COMM,DWH.MDM_COMMUNICATION_COUNT.LAST_COMM);
 
INSERT INTO DWH.MDM_COMMUNICATION_COUNT (meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id)
select meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, id, office_id from (
select net.meter_number, lp_date, lp_cnt, inst_cnt, energy_cnt, eob_ed_cnt, event_cnt, last_comm, cd.id, cd.office_id,
row_number() over(partition by net.meter_number) rn
from dwh.mdms_communication_count cd
inner join mdms.mdm_network_hierarchy net on net.meter_number=cd.meter_number and net.record_status =1
where lp_date = to_char(now() - interval '0d','yyyymmdd')::bigint
) B where rn =1
ON CONFLICT(METER_NUMBER,LP_DATE)
DO UPDATE
SET inst_CNT=EXCLUDED.inst_cnt,LAST_COMM=COALESCE(EXCLUDED.LAST_COMM,DWH.MDM_COMMUNICATION_COUNT.LAST_COMM);
 