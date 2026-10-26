
---SAT METERS 

WITH k AS (
SELECT meter_number mtr_number, hes_vendor vendor_name
    FROM sla_t.group_meter_sat s
    WHERE s.sat_seq IN ('SAT-1','SAT-2','SAT-3','SAT-4','SAT-5','SAT-6','SAT-7','SAT-8','SAT-9','SAT-10','SAT-11','SAT-12','SAT-13','SAT-14')
    AND hes_vendor ='FGHES' 
)
SELECT 
    t.meter_number,
    m.vendor_name,

MAX(CASE WHEN sla_date = '20260401' THEN t.mdm_12_hours ELSE 0 END) AS apr01,
MAX(CASE WHEN sla_date = '20260402' THEN t.mdm_12_hours ELSE 0 END) AS apr02,
MAX(CASE WHEN sla_date = '20260403' THEN t.mdm_12_hours ELSE 0 END) AS apr03,
MAX(CASE WHEN sla_date = '20260404' THEN t.mdm_12_hours ELSE 0 END) AS apr04,
MAX(CASE WHEN sla_date = '20260405' THEN t.mdm_12_hours ELSE 0 END) AS apr05,
MAX(CASE WHEN sla_date = '20260406' THEN t.mdm_12_hours ELSE 0 END) AS apr06,
MAX(CASE WHEN sla_date = '20260407' THEN t.mdm_12_hours ELSE 0 END) AS apr07,
MAX(CASE WHEN sla_date = '20260408' THEN t.mdm_12_hours ELSE 0 END) AS apr08,
MAX(CASE WHEN sla_date = '20260409' THEN t.mdm_12_hours ELSE 0 END) AS apr09,
MAX(CASE WHEN sla_date = '20260410' THEN t.mdm_12_hours ELSE 0 END) AS apr10,
MAX(CASE WHEN sla_date = '20260411' THEN t.mdm_12_hours ELSE 0 END) AS apr11,
MAX(CASE WHEN sla_date = '20260412' THEN t.mdm_12_hours ELSE 0 END) AS apr12,
MAX(CASE WHEN sla_date = '20260413' THEN t.mdm_12_hours ELSE 0 END) AS apr13,
MAX(CASE WHEN sla_date = '20260414' THEN t.mdm_12_hours ELSE 0 END) AS apr14,
MAX(CASE WHEN sla_date = '20260415' THEN t.mdm_12_hours ELSE 0 END) AS apr15,
MAX(CASE WHEN sla_date = '20260416' THEN t.mdm_12_hours ELSE 0 END) AS apr16,
MAX(CASE WHEN sla_date = '20260417' THEN t.mdm_12_hours ELSE 0 END) AS apr17,
MAX(CASE WHEN sla_date = '20260418' THEN t.mdm_12_hours ELSE 0 END) AS apr18,
MAX(CASE WHEN sla_date = '20260419' THEN t.mdm_12_hours ELSE 0 END) AS apr19,
MAX(CASE WHEN sla_date = '20260420' THEN t.mdm_12_hours ELSE 0 END) AS apr20,
MAX(CASE WHEN sla_date = '20260421' THEN t.mdm_12_hours ELSE 0 END) AS apr21,
MAX(CASE WHEN sla_date = '20260422' THEN t.mdm_12_hours ELSE 0 END) AS apr22,
MAX(CASE WHEN sla_date = '20260423' THEN t.mdm_12_hours ELSE 0 END) AS apr23,
MAX(CASE WHEN sla_date = '20260424' THEN t.mdm_12_hours ELSE 0 END) AS apr24,
MAX(CASE WHEN sla_date = '20260425' THEN t.mdm_12_hours ELSE 0 END) AS apr25,
MAX(CASE WHEN sla_date = '20260426' THEN t.mdm_12_hours ELSE 0 END) AS apr26,
MAX(CASE WHEN sla_date = '20260427' THEN t.mdm_12_hours ELSE 0 END) AS apr27,
MAX(CASE WHEN sla_date = '20260428' THEN t.mdm_12_hours ELSE 0 END) AS apr28,
MAX(CASE WHEN sla_date = '20260429' THEN t.mdm_12_hours ELSE 0 END) AS apr29,
MAX(CASE WHEN sla_date = '20260430' THEN t.mdm_12_hours ELSE 0 END) AS apr30

FROM SLA_T.MDM_blp_sla_report T
INNER JOIN k M 
    ON M.mtr_number = T.meter_number 
WHERE sla_date BETWEEN '20260401' AND '20260430'
GROUP BY t.meter_number, m.vendor_name;
