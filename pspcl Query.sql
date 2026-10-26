--all meter request
Select count(distinct(METER_NUMBER)) from fep.fep_csv_ed  where record_status=1 and READING_TYPE='S'
and CREATE_DATE between '2024-03-30 00:00:00' and '2024-03-30 23:59:59'

--servers 

SELECT * FROM (
SELECT
METER_NUMBER,STATUS_MESSAGE,STATUS,METER_TIME,ROW_NUMBER() OVER(PARTITION BY METER_NUMBER ORDER  BY METER_TIME DESC)RN
from fep.fep_csv_ed fed,cdb.METER_MASTER mm
where fed.METER_NUMBER=mm.MTR_NUMBER 
and fed.record_status=1 
and mm.RECORD_STATUS=1 
and fed.READING_TYPE='S'
and fed.METER_TIME between '2024-03-30 00:00:00' and '2024-03-30 23:59:59'
--and mm.MTR_SEQ1 between '0001' and '100000'
--and mm.MTR_SEQ1 between '100001' and '200000' 
and mm.MTR_SEQ1 between '200001' and '300000' 
AND fed.STATUS='Success'
) QQ  WHERE RN=1
--ORDER by mm.MTR_SEQ


select * from fep.fep_csv_ed where METER_TIME between '2024-03-28 00:00:00' and '2024-03-28 23:59:59'
