------SPM BILLING-------
WITH daily_energy as (
    SELECT 
        (ENC.BILL_DATE - INTERVAL '1 day')::DATE AS dt,
        COUNT(DISTINCT ENC.mtr_number) AS ed_cnt,
        COUNT(DISTINCT bill.meter_number) AS billing_cnt
    FROM SPM.PREPAID_CONSDETAILS_T A
    JOIN SPM.MDM_ENERGY_DATA_CLONE ENC 
         ON A.meter_number = ENC.mtr_number
        AND ENC.record_status = 1
    LEFT JOIN SPM.SPM_BILL_DETAILS_T bill
         ON bill.meter_number = A.meter_number
        AND (bill.blissue_dt + INTERVAL '1 day') = ENC.bill_date
    WHERE A.record_status = 1
      AND A.cons_type = 'PRE'
      AND A.billing_status = 'L'
      AND ENC.bill_date::date BETWEEN CURRENT_DATE - INTERVAL '6 days' AND CURRENT_DATE
    GROUP BY dt
),
prepaid as (
    SELECT 
        A.create_date::date AS dt,
        A.billing_status,
        A.meter_number
    FROM SPM.PREPAID_CONSDETAILS_T A
    WHERE A.record_status = 1 
      AND A.cons_type = 'PRE'
),
agg_prepaid AS (
    SELECT 
        dt,
        COUNT(DISTINCT meter_number) AS total_prepaid,
        COUNT(DISTINCT meter_number) FILTER (WHERE billing_status = 'BS') AS bs
    FROM prepaid
    GROUP BY dt
),
running AS (
    SELECT 
        dt,
        SUM(total_prepaid) OVER (ORDER BY dt) AS total_prepaid,
        SUM(bs) OVER (ORDER BY dt) AS bs
    FROM agg_prepaid
)
SELECT 
    d.dt,
    r.total_prepaid,
    r.bs AS bill_stopped,
    (r.total_prepaid - r.bs) AS live_meters,
    d.ed_cnt,
    d.billing_cnt,
    (d.ed_cnt - d.billing_cnt) AS un_billed_cnt
FROM daily_energy d
JOIN running r USING(dt)
ORDER BY dt;