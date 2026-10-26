
select *  into bkp.mwm_job_2025122_61604 from wfms.mwm_job
where job_id = '4e1c407b-45ed-4716-b529-d4bfd91e38a1'

update wfms.mwm_job set job_status='ST000',assigned_to=null
where job_id = '4e1c407b-45ed-4716-b529-d4bfd91e38a1'

select * from fep.fep_meter_groupconfig
limit 10 

select * from wfms.mwm_job_response_intr
where job_id = '4e1c407b-45ed-4716-b529-d4bfd91e38a1'



select count(*) from mdms.mdm_time_dimension

