--Schedule Job Report- KESCo & NDMC
--*****************************
SELECT JOB_GROUP_NAME,START_TIME,END_TIME,TOTAL_CNT,SUCCESS,FAILURE,*
FROM FEP.FEP_JOB_SCHEDULE_LOG WHERE RECORD_STATUS=1
AND CONVERT(VARCHAR(10),CREATE_DATE,120)='2023-10-02'
ORDER BY CREATE_DATE DESC

--Data Availability Report- NDMC & KESCo
--***************************
SELECT left(convert(varchar, CAST(CONVERT(VARCHAR,LP_DATE,112) AS DATETIME), 106),2)+'-'+substring(convert(varchar, CAST(CONVERT(VARCHAR,LP_DATE,112) AS DATETIME), 106),4,3) +'-'+
right(convert(varchar, CAST(CONVERT(VARCHAR,LP_DATE,112) AS DATETIME), 106),4) LPDATE,COUNT(DISTINCT METER_NUMBER) TOT_CNT, (select count(distinct meter_number)
from DWH.COMMUNICATION_COUNT_DATA(nolock) dlp where dlp.lp_date = dwh.lp_date and dlp.ENERGY_CNT > 0) DLP, (select count(distinct meter_number)
from DWH.COMMUNICATION_COUNT_DATA(nolock) blp where blp.lp_date = dwh.lp_date and blp.LP_CNT > 0) BLP, (select count(distinct meter_number) from DWH.COMMUNICATION_COUNT_DATA(nolock) eob
where eob.lp_date between 20231001 and dwh.lp_date and eob.EOB_ED_CNT > 0) EOB FROM DWH.COMMUNICATION_COUNT (NOLOCK) DWH WHERE LP_DATE BETWEEN 20231001 AND 20231002
GROUP BY LP_DATE ORDER BY LP_DATE
