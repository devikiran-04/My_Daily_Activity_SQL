WITH RES AS (
    SELECT 
        unnest(string_to_array(list_of_meters, ',')) AS meters
    FROM mdms.Ext_UtilRes_bill_readings res
    WHERE transid = 2009779::varchar
),

REQ AS (
    SELECT 
        req.transid,
        req.billmonth,
        to_char(date_trunc('month', schmrdate::timestamp), 'yyyymmdd')::int AS schmrdate,
        exedate::int AS exedate,
        req.cycle,
        list_meter,
        mtrrdgtype,
        group_transid
    FROM mdms.Ext_UtilReq_bill_readings req
    WHERE schmrdate <= exedate
      AND group_transid = 2009779::varchar
      AND req.resp_status = 'Success'
),

METERS AS (
    SELECT 
        transid,
        billmonth,
        schmrdate,
        exedate,
        mtrrdgtype,
        cycle,
        unnest(string_to_array(list_meter, ',')) AS meters
    FROM REQ
),

NET AS (
    SELECT 
        req.transid,
        req.billmonth,
        cnm.cons_bill_grp AS cycle,
        vi.customer_account_no,
        vi.meter_number AS meterno,
        m.metering_mode AS mtrreadingtype,
        schmrdate::int,
        exedate::int,
        mtrrdgtype
    FROM mdms.MDM_NETWORK_HIERARCHY vi
    INNER JOIN cdb.METER_MASTER m 
        ON vi.meter_number = m.mtr_number AND m.record_status = 1
    INNER JOIN cdb.consumer_network_mapping cnm 
        ON vi.meter_number = cnm.mtr_number AND cnm.record_status = 1
    INNER JOIN METERS req 
        ON req.meters = vi.meter_number
    WHERE vi.record_status = 1
      AND (UPPER(metering_mode) IN ('NORMAL','NET'))
      AND vi.meter_number NOT IN (SELECT meters FROM RES)
),

ENE AS (
    SELECT 
        vi.meter_number,
        source_type,
        lp_date AS meter_time,
        kw_imp, kw_exp,
        kwh_tou1, e_kwh_tou1, kwh_tou2, e_kwh_tou2, kwh_tou3, e_kwh_tou3,
        kwh_tou4, e_kwh_tou4, kwh_tou5, e_kwh_tou5,
        kva_imp, kva_exp,
        kva_tou1, e_kvah_tou1, kva_tou2, e_kvah_tou2, kva_tou3, e_kvah_tou3,
        kva_tou4, e_kvah_tou4, kva_tou5, e_kvah_tou5,
        i_kvarh_lag, kvarh_e_lag,
        i_kvarhlag_tod1, e_kvarhlag_tod1, i_kvarhlag_tod2, e_kvarhlag_tod2,
        i_kvarhlag_tod3, e_kvarhlag_tod3, i_kvarhlag_tod4, e_kvarhlag_tod4,
        i_kvarhlag_tod5, e_kvarhlag_tod5,
        i_kvarh_lead, kvarh_e_lead,
        i_kvarhlead_tod1, e_kvarhlead_tod1, i_kvarhlead_tod2, e_kvarhlead_tod2,
        i_kvarhlead_tod3, e_kvarhlead_tod3, i_kvarhlead_tod4, e_kvarhlead_tod4,
        i_kvarhlead_tod5, e_kvarhlead_tod5,
        i_kva_tou1, e_kva_tou1, i_kva_tou2, e_kva_tou2, i_kva_tou3, e_kva_tou3,
        i_kva_tou4, e_kva_tou4, i_kva_tou5, e_kva_tou5,
        i_kva_tou1_dt, i_kw_tou1_dt,
        i_kva_tou2_dt, i_kw_tou2_dt,
        i_kva_tou3_dt, i_kw_tou3_dt,
        i_kva_tou4_dt, i_kw_tou4_dt,
        i_kva_tou5_dt, i_kw_tou5_dt,
        e_kva_tou1_dt, e_kva_tou2_dt, e_kva_tou3_dt, e_kva_tou4_dt, e_kva_tou5_dt,
        CASE WHEN source_type IN ('SCHEDULAR','ONDEMAND','S','O') THEN '0'
             WHEN source_type IN ('M','MRI') THEN '1' END AS ismanual,
        ROW_NUMBER() OVER (PARTITION BY vi.meter_number ORDER BY lp_date) AS rn
    FROM mdms.MDM_MONTHLY_BILLING_VIEW vi
    WHERE lp_date >= (SELECT schmrdate FROM REQ)
      AND lp_date <= (SELECT exedate FROM REQ)
),

X AS (
    SELECT 
        net.transid,
        net.billmonth,
        net.cycle,
        net.customer_account_no,
        net.meterno,
        net.mtrreadingtype,
        net.mtrrdgtype,
        ene.meter_time AS actual_read_date,
        ene.*
    FROM NET
    INNER JOIN ENE ON net.meterno = ene.meter_number
    WHERE rn = 1
)

SELECT 
    transid,
    billmonth,
    cycle,
    customer_account_no,
    meterno,
    mtrreadingtype,
    actual_read_date,
    COALESCE(reg01::varchar,'0') reg01,
    COALESCE(reg02::varchar,'0') reg02,
    COALESCE(reg03::varchar,'0') reg03,
    COALESCE(reg04::varchar,'0') reg04,
    COALESCE(reg05::varchar,'0') reg05,
    COALESCE(reg06::varchar,'0') reg06,
    COALESCE(reg07::varchar,'0') reg07,
    COALESCE(reg08::varchar,'0') reg08,
    COALESCE(reg09::varchar,'0') reg09,
    COALESCE(reg10::varchar,'0') reg10,
    COALESCE(reg11::varchar,'0') reg11,
    COALESCE(reg12::varchar,'0') reg12,
    COALESCE(reg13::varchar,'0') reg13,
    COALESCE(reg14::varchar,'0') reg14,
    COALESCE(reg15::varchar,'0') reg15,
    COALESCE(reg16::varchar,'0') reg16,
    COALESCE(reg17::varchar,'0') reg17,
    COALESCE(reg18::varchar,'0') reg18,
    COALESCE(reg19::varchar,'0') reg19,
    COALESCE(reg20::varchar,'0') reg20,
    COALESCE(reg21::varchar,'0') reg21,
    COALESCE(reg22::varchar,'0') reg22,
    COALESCE(reg23::varchar,'0') reg23,
    COALESCE(reg24::varchar,'0') reg24,
    COALESCE(reg25::varchar,'0') reg25,
    COALESCE(reg26::varchar,'0') reg26,
    COALESCE(reg27::varchar,'0') reg27,
    COALESCE(reg28::varchar,'0') reg28,
    COALESCE(reg29::varchar,'0') reg29,
    tod1md_time,
    tod2md_time,
    tod3md_time,
    tod4md_time,
    tod5md_time,
    ismanual,
    CASE WHEN ismanual='0' THEN 'No'
         WHEN ismanual='1' THEN 'MRI' END AS lastreadremark
FROM (
    SELECT 
        transid,billmonth,cycle,customer_account_no,meterno,
        CASE WHEN (mtrrdgtype IN ('N','G')) THEN 'I' ELSE 'O' END AS mtrreadingtype,
        actual_read_date,
        kw_imp AS reg01, i_kvarh_lag AS reg02, i_kva_tou1 AS reg03,
        kwh_tou1 AS reg04, kwh_tou2 AS reg05, kwh_tou3 AS reg06, kwh_tou4 AS reg07,
        i_kva_tou2 AS reg08, i_kva_tou3 AS reg09, i_kva_tou4 AS reg10,
        i_kvarh_lead AS reg11, kva_imp AS reg12, kva_tou1 AS reg13, kva_tou2 AS reg14,
        kva_tou3 AS reg15, kva_tou4 AS reg16,
        i_kvarhlag_tod1 AS reg17, i_kvarhlag_tod2 AS reg18,
        i_kvarhlag_tod3 AS reg19, i_kvarhlag_tod4 AS reg20,
        i_kvarhlead_tod1 AS reg21, i_kvarhlead_tod2 AS reg22,
        i_kvarhlead_tod3 AS reg23, i_kvarhlead_tod4 AS reg24,
        kwh_tou5 AS reg25, kva_tou5 AS reg26,
        i_kvarhlag_tod5 AS reg27, i_kvarhlead_tod5 AS reg28, i_kva_tou5 AS reg29,
        i_kva_tou1_dt AS tod1md_time, i_kva_tou2_dt AS tod2md_time,
        i_kva_tou3_dt AS tod3md_time, i_kva_tou4_dt AS tod4md_time,
        i_kva_tou5_dt AS tod5md_time,
        ismanual
    FROM X
    
    UNION ALL
    
    SELECT 
        transid,billmonth,cycle,customer_account_no,meterno,'E',
        actual_read_date,
        kw_exp AS reg01, kvarh_e_lag AS reg02, e_kva_tou1 AS reg03,
        e_kwh_tou1 AS reg04, e_kwh_tou2 AS reg05, e_kwh_tou3 AS reg06, e_kwh_tou4 AS reg07,
        e_kva_tou2 AS reg08, e_kva_tou3 AS reg09, e_kva_tou4 AS reg10,
        kvarh_e_lead AS reg11, kva_exp AS reg12, e_kvah_tou1 AS reg13,
        e_kvah_tou2 AS reg14, e_kvah_tou3 AS reg15, e_kvah_tou4 AS reg16,
        e_kvarhlag_tod1 AS reg17, e_kvarhlag_tod2 AS reg18,
        e_kvarhlag_tod3 AS reg19, e_kvarhlag_tod4 AS reg20,
        e_kvarhlead_tod1 AS reg21, e_kvarhlead_tod2 AS reg22,
        e_kvarhlead_tod3 AS reg23, e_kvarhlead_tod4 AS reg24,
        e_kwh_tou5 AS reg25, e_kvah_tou5 AS reg26,
        e_kvarhlag_tod5 AS reg27, e_kvarhlead_tod5 AS reg28, e_kva_tou5 AS reg29,
        e_kva_tou1_dt AS tod1md_time, e_kva_tou2_dt AS tod2md_time,
        e_kva_tou3_dt AS tod3md_time, e_kva_tou4_dt AS tod4md_time,
        e_kva_tou5_dt AS tod5md_time,
        ismanual
    FROM X
    WHERE mtrrdgtype IN ('N','G')
) X;
