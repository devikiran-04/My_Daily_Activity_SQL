--For checking the last request sent . 

SELECT ert.res_time SENT_AT, res_msg::json->>'ConsumerId' CONS_NOTIFY, res_msg::json->>'ResultCodeDescription' res_msg
from fuel.ext_res_trans ert 
where req_id in(select id from fuel.ext_req_trans ert3 
where req_type ='NotifySmartMeterInstallatioRequest') 
and ert.res_time>'2025-04-11 23:00:00' 
order by ert.res_time desc limit 1 

--To validate the missing consumers

WITH TOT_CONS AS ( SELECT jrc.job_id,mj.job_status,JRM.remarks, JRC.ATTRIB_VALUE::JSON->>'Consumer Number'
AS CONS_NUMBER, JRM.ATTRIBUTE_VALUE::JSON->>'Meter Installation Date'  AS INST_DATE FROM WFMS.mwm_job_response JRM inner join wfms.mwm_job_DETAILS JRC ON
JRC.JOB_ID=JRM.JOB_ID inner join wfms.mwm_job mj on mj.job_id=jrm.job_id WHERE
JOB_STATUS IN ('ST004')-- ,'ST011','ST0111')
and JRM.attirb_name='New Meter Details' AND JRC.attRIB_name='Consumer Details' 
and JRM.remarks is null and is_json(ATTRIBUTE_VALUE)='1' and is_json(ATTRIB_VALUE)='1' ) ,NOTIFY_D AS ( SELECT ert.res_time SENT_AT, res_msg::json->>'ConsumerId'
CONS_NOTIFY, res_msg::json->>'ResultCodeDescription' res_msg from fuel.ext_res_trans ert where req_id in(select id from fuel.ext_req_trans ert3
where req_type ='NotifySmartMeterInstallatioRequest') and ert.res_time>'2024-08-23 21:00:00' and is_json(res_msg)='1' ) SELECT job_id,job_status,remarks, 
CONS_NUMBER,INST_DATE AS INSTALLATION_DATE,SENT_AT AS NOTFIED_DT,RES_MSG FROM TOT_CONS T LEFT OUTER JOIN NOTIFY_D N ON T.CONS_NUMBER=N.CONS_NOTIFY



SELECT * FROM WFMS.anonymous_job where job_status='ST007'  AND STATUS IS NULL
and job_type='ASSET DTR SURVEY'
and (now() - create_Date) > interval '15 minutes'; 