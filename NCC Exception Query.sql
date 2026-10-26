--LP EXCEPTION
---------------

SELECT status_message,count(*) FROM (SELECT
ROW_NUMBER() OVER (PARTITION BY meter_number, TO_CHAR(dcu_time, 'yyyy-mm-dd') ORDER BY dcu_time DESC) rn,*
FROM fep.fep_csv_lp lp WHERE meter_time BETWEEN '2026-09-17 00:00:00' AND '2026-09-17 23:59:59'AND meter_number IN (
SELECT meter_number FROM dwh.communication_count WHERE lp_date = '20260917' AND (lp_cnt) = 0 AND meter_number IN (SELECT mtr_number
FROM cdb.meter_master WHERE record_status = 1 AND mtr_installed_date IS NOT NULL))AND status <> 'Success') j WHERE rn = 1
group by status_message;


--ED EXCEPTION
---------------

SELECT status_message,count(*) FROM (SELECT
ROW_NUMBER() OVER (PARTITION BY meter_number, TO_CHAR(dcu_time, 'yyyy-mm-dd') ORDER BY dcu_time DESC) rn,*
FROM fep.fep_csv_ed ed WHERE meter_time BETWEEN '2026-09-17 00:00:00' AND '2026-09-17 23:59:59'AND meter_number IN (
SELECT meter_number FROM dwh.communication_count WHERE lp_date = '20260917' AND (energy_cnt) = 0 AND meter_number IN (SELECT mtr_number
FROM cdb.meter_master WHERE record_status = 1 AND mtr_installed_date IS NOT NULL))AND status <> 'Success') j WHERE rn = 1
group by status_message;


select count(distinct mtr_number) from cdb.meter_master
where record_status = 1 
limit 10







SELECT 
    'Communication Established' as status,
    COUNT(*) as success_count
FROM (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY meter_number, TO_CHAR(dcu_time, 'yyyy-mm-dd') 
                          ORDER BY dcu_time DESC) rn
    FROM fep.fep_csv_lp lp 
    WHERE meter_time BETWEEN '2026-09-17 00:00:00' AND '2026-09-17 23:59:59'
    AND meter_number IN (
        SELECT meter_number 
        FROM dwh.communication_count 
        WHERE lp_date = '20260917' 
        AND lp_cnt = 0 
        AND meter_number IN (
            SELECT mtr_number
            FROM cdb.meter_master 
            WHERE record_status = 1 
            AND mtr_installed_date IS NOT NULL
        )
    )
    AND status = 'Success'
) j 
WHERE rn = 1;