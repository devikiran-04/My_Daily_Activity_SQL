
--table 1:- spm.spm_bill_details_t

DO $$
DECLARE
v_rows INT;
BEGIN
LOOP
DELETE FROM spm.spm_bill_details_t e
USING (
SELECT p.meter_number,b.max_billdate - INTERVAL '180 days' AS cutoff_date
FROM spm.spm_availablebalance b
inner join spm.prepaid_consdetails_t p on p.meter_number=b.meter_number
WHERE p.record_status = 1 and p.thread_grp_id=1
AND b.record_status = 1
) x
WHERE e.meter_number = x.meter_number
AND e.blissue_dt <= x.cutoff_date;
GET DIAGNOSTICS v_rows = ROW_COUNT;
EXIT WHEN v_rows = 0;
COMMIT;
PERFORM pg_sleep(0.2);
END LOOP;
END $$;

 

--Table 2:- spm.spm_online_ledger_t

--Step 1
insert into kettle.max_online_dt
SELECT
p.account_no,MAX(b.transaction_date) - INTERVAL '3 days' AS cutoff_date
FROM spm.spm_online_ledger_t b
JOIN spm.prepaid_consdetails_t p ON p.account_no = b.account_no
WHERE p.record_status = 1
and p.thread_grp_id = 3
AND b.record_status = 1
GROUP BY p.account_no;
 
--step 2
DO $$
DECLARE
v_rows INT;
BEGIN
LOOP
DELETE FROM spm.spm_online_ledger_t e
USING (
SELECT p.account_no, b.cutoff_date
FROM   kettle.max_online_dt b 
inner join spm.prepaid_consdetails_t p on p.account_no=b.account_no 
WHERE p.record_status = 1  and p.thread_grp_id=1) x
WHERE e.account_no = x.account_no
AND e.transaction_date < x.cutoff_date;
GET DIAGNOSTICS v_rows = ROW_COUNT;
EXIT WHEN v_rows = 0;
COMMIT;
PERFORM pg_sleep(0.2);
END LOOP;
END $$;


--Table 3:- spm.spm_rcdc_response

DO $$
DECLARE
v_rows INT;
BEGIN
LOOP
DELETE FROM spm.spm_rcdc_response r
USING (
SELECT p.account_no,p.meter_number,MAX(s.response_date) - INTERVAL '1 month' AS cutoff_date
FROM spm.spm_rcdc_response s
JOIN spm.prepaid_consdetails_t p
ON p.meter_number = s.meter_number
WHERE p.record_status = 1 AND s.record_status = 1 and p.thread_grp_id=1
GROUP BY p.account_no, p.meter_number
) x
WHERE r.meter_number = x.meter_number
AND r.response_date < x.cutoff_date;
GET DIAGNOSTICS v_rows = ROW_COUNT;
EXIT WHEN v_rows = 0;
COMMIT;
PERFORM pg_sleep(0.2);
END LOOP;
END $$;


--table 4:- spm.eligible_dc_list

DO $$
DECLARE
v_rows INT;
BEGIN
LOOP
DELETE FROM spm.eligible_dc_list e
USING (
SELECT p.account_no,MAX(b.create_date) - INTERVAL '3 days' AS cutoff_date
FROM  spm.eligible_dc_list b 
inner join spm.prepaid_consdetails_t p on p.account_no=b.account_no 
WHERE p.record_status = 1  and p.thread_grp_id=1
AND b.record_status = 1
GROUP BY p.account_no) x
WHERE e.account_no = x.account_no
AND e.create_date < x.cutoff_date;
GET DIAGNOSTICS v_rows = ROW_COUNT;
EXIT WHEN v_rows = 0;
COMMIT;
PERFORM pg_sleep(0.2);
END LOOP;
END $$;


-- table 5:- spm.mdm_energy_data_clone 

DO $$
DECLARE
v_rows INT;
BEGIN
LOOP
DELETE FROM spm.mdm_energy_data_clone e
USING (
SELECT p.meter_number,MAX(b.max_billdate) - INTERVAL '5 days' AS cutoff_date
FROM  spm.spm_availablebalance b 
inner join spm.prepaid_consdetails_t p on p.meter_number=b.meter_number 
WHERE p.record_status = 1  and p.thread_grp_id=2
AND b.record_status = 1
GROUP BY p.meter_number) x
WHERE e.mtr_number = x.meter_number
AND e.bill_date <= x.cutoff_date;
GET DIAGNOSTICS v_rows = ROW_COUNT;
EXIT WHEN v_rows = 0;
COMMIT;
PERFORM pg_sleep(0.2);
END LOOP;
END $$;
 
