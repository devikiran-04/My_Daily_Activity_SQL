SELECT
    hes_vendor_name,
    DATE(METER_TIME) AS D,
    COUNT(1) AS daily_success_count
FROM                                                              
    MDMS.MDMS_CSV_LP                                                                   ----- chang to ED if ED required---
WHERE
    STATUS = 'Success'
    AND STATUS_MESSAGE = 'Successfully Completed'
    AND METER_TIME >= '2025-09-08'::date
    AND METER_TIME < '2025-09-08'::date + INTERVAL '1 day'
GROUP BY                                                                                -- triliant--->40L ` kimbal----->1.25 cr above
    hes_vendor_name,
    DATE(METER_TIME)
ORDER BY
    hes_vendor_name, DATE(METER_TIME);