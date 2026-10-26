
WITH x AS (
    SELECT BILL_daTE,MTR_NUMBER,COUNT(*),
           MIN(ctid) AS min_ctid
    FROM SPM.MDM_ENERGY_DATA_CLONE  WHERE 
    D_TYPE=1 AND IS_RECORD_ESTIMATED=0 AND RECORD_STATUS=1 

    GROUP BY BILL_dATE,MTR_NUMBER HAVING COUNT(*)>1
)
DELETE FROM SPM.MDM_ENERGY_DATA_CLONE b
USING x
WHERE x.MTR_NUMBER = b.MTR_NUMBER
AND X.BILL_daTE=B.BILL_daTE
  AND x.min_ctid <> b.ctid


WITH x AS
(
    SELECT
        bill_date,
        mtr_number,
        COUNT(*) AS cnt,
        MIN(ctid) AS min_ctid
    FROM spm.mdm_energy_data_clone
    WHERE d_type = 1
      AND is_record_estimated = 0
      AND record_status = 1
    GROUP BY bill_date, mtr_number
    HAVING COUNT(*) > 1
)
SELECT COUNT(*) AS records_to_delete
FROM spm.mdm_energy_data_clone b
JOIN x
  ON x.mtr_number = b.mtr_number
 AND x.bill_date = b.bill_date
WHERE x.min_ctid <> b.ctid;

create table SPM.MDM_ENERGY_DATA_CLONE_BACKUP_20261006 as 
select * from SPM.MDM_ENERGY_DATA_CLONE   

--spm clone duplicates deleteion
--****************
DELETE FROM SPM.mdm_energy_data_clone S USING
(
SELECT MTR_NUMBER,bill_date,D_TYPE,time_id,MIN(CTID) MIN_CTID 
FROM SPM.mdm_energy_data_clone
GROUP BY MTR_NUMBER,bill_date,D_TYPE,time_id
) M
WHERE S.CTID<>M.MIN_CTID AND S.MTR_NUMBER=M.MTR_NUMBER AND S.bill_date=M.bill_date AND S.D_TYPE=M.D_TYPE and S.time_id=M.time_id


SELECT COUNT(*)
FROM SPM.mdm_energy_data_clone S
JOIN (
  SELECT 
    MTR_NUMBER, bill_date, D_TYPE, time_id, MIN(CTID) AS MIN_CTID
  FROM SPM.mdm_energy_data_clone
  GROUP BY MTR_NUMBER, bill_date, D_TYPE, time_id
) M
ON S.MTR_NUMBER = M.MTR_NUMBER
  AND S.bill_date = M.bill_date
  AND S.D_TYPE = M.D_TYPE
  AND S.time_id = M.time_id
WHERE S.CTID <> M.MIN_CTID;
