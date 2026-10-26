
--EOB--
WITH office_meters AS (SELECT id FROM cdb.office_master_hierarchy WHERE parentid = '2f00f158-3c5e-458b-87f8-0ae73224f5cf'),
eob_first_week AS (SELECT DISTINCT meter_number FROM fep.fep_csv_eob_ed WHERE meter_time >= DATE_TRUNC('month', CURRENT_DATE) AND meter_time < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '7 days'
AND status = 'Success' AND LEFT(meter_number, 2) IN ('UK','UG','UH','US')),
eob_remaining AS (SELECT DISTINCT meter_number FROM fep.fep_csv_eob_ed WHERE meter_time >= DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '7 days'
AND meter_time < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' AND status = 'Success' AND LEFT(meter_number, 2) IN ('UK','UG','UH','US')),
meter_status AS (SELECT DISTINCT mm.mtr_number, CASE LEFT(mm.mtr_number, 2) WHEN 'UK' THEN 'KIMBAL' WHEN 'UG' THEN 'GENUS' WHEN 'UH' THEN 'HPL' WHEN 'US' THEN 'SEIPL' END AS oem,
CASE WHEN eob1.meter_number IS NOT NULL THEN 1 ELSE 0 END AS has_eob_first_week, CASE WHEN eob2.meter_number IS NOT NULL THEN 1 ELSE 0 END AS has_eob_remaining,
CASE WHEN eob1.meter_number IS NOT NULL OR eob2.meter_number IS NOT NULL THEN 1 ELSE 0 END AS has_eob_any,
CASE WHEN COALESCE(cc.lp_cnt,0) + COALESCE(cc.inst_cnt,0) + COALESCE(cc.energy_cnt,0) + COALESCE(cc.eob_ed_cnt,0) + COALESCE(cc.event_cnt,0) > 0 THEN 1 ELSE 0 END AS has_communication,
CASE WHEN GREATEST(c.lp_max_time, c.ed_max_time, c.eob_max_time, c.instd_max_time, c.volt_max_time, c.curr_max_time, c.pwr_max_time, c.trans_max_time, c.oe_max_time, c.nr_max_time, c.ce_max_time) IS NULL 
THEN 1 ELSE 0 END AS never_communicated, mm.relay_status FROM cdb.meter_master mm INNER JOIN cdb.meter_feild_device_relation rel ON rel.meter_id = mm.id AND rel.record_status = 1
INNER JOIN cdb.field_device_m fld ON fld.id = rel.field_device_id AND fld.record_status = 1 INNER JOIN cdb.meter_type_m mtm ON mtm.id = mm.mtr_type AND mtm.record_status = 1 INNER JOIN cdb.meter_make_m mmm 
ON mmm.id = mm.mtr_make AND mmm.record_status = 1 INNER JOIN cdb.meter_manufacturer mm2 ON mm2.id = mmm.mtr_manfacture_id AND mm2.record_status = 1 INNER JOIN dwh.max_mtr_view c ON c.meter_number = mm.mtr_number
LEFT JOIN dwh.communication_count cc ON cc.meter_number = mm.mtr_number AND cc.lp_date = TO_CHAR(CURRENT_DATE,'YYYYMMDD')::INT LEFT JOIN eob_first_week eob1 ON eob1.meter_number = mm.mtr_number
LEFT JOIN eob_remaining eob2 ON eob2.meter_number = mm.mtr_number WHERE mm.record_status = 1 AND mm.mtr_installed_date IS NOT NULL AND mm.relay_status IS NOT NULL AND rel.field_office_id IN (SELECT id FROM office_meters)
AND mm2.name IN ('GENUS','HPL','SEIPL','KIMBAL') AND LEFT(mm.mtr_number,2) IN ('UK','UG','UH','US')),
report AS (SELECT oem, COUNT(*) FILTER (WHERE has_eob_first_week = 1) AS eob_first_week, COUNT(*) FILTER (WHERE has_eob_remaining = 1) AS eob_remaining, COUNT(*) FILTER (WHERE has_eob_any = 1) AS eob_received,
COUNT(*) FILTER (WHERE has_eob_any = 0 AND has_communication = 0 AND never_communicated = 0) AS non_com, COUNT(*) FILTER (WHERE has_eob_any = 0 AND has_communication = 1) AS yet_to_receive,
COUNT(*) FILTER (WHERE never_communicated = 1) AS never_com, COUNT(*) AS total, COUNT(*) FILTER (WHERE relay_status = 1) AS connected, COUNT(*) FILTER (WHERE relay_status = 0) AS disconnected FROM meter_status
GROUP BY oem),
final_report AS ( SELECT oem, eob_first_week, eob_remaining, eob_received, non_com, yet_to_receive, never_com, total, ROUND(100.0 * eob_received / NULLIF(eob_received + yet_to_receive, 0), 1) AS eob_percent,
connected,disconnected,CASE oem WHEN 'GENUS' THEN 1 WHEN 'HPL' THEN 2 WHEN 'KIMBAL' THEN 3 WHEN 'SEIPL' THEN 4 ELSE 5 END AS sort_order FROM report
UNION ALL
SELECT 'Grand Total', SUM(eob_first_week), SUM(eob_remaining), SUM(eob_received), SUM(non_com), SUM(yet_to_receive), SUM(never_com), SUM(total),
ROUND(100.0 * SUM(eob_received) / NULLIF(SUM(eob_received) + SUM(yet_to_receive), 0), 1), SUM(connected), SUM(disconnected),5 FROM report)
SELECT oem, eob_first_week, eob_remaining, eob_received, non_com, yet_to_receive, never_com, total, eob_percent, connected, disconnected FROM final_report ORDER BY sort_order;
 