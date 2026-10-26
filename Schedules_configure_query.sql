update public.sch_job_def set orgid = 'b1d71e63-8188-4d39-99ba-233159309caf'
where state = 'ENABLED'

select * from cdb.office_master
where parentoffice_id = '100-0'
'b1d71e63-8188-4d39-99ba-233159309caf'
--id = 'b1d71e63-8188-4d39-99ba-233159309caf'

select * from public.dir_user_role
where userid = 'srinivasm'

create table public.sch_job_def_backup as 
select * from 
public.sch_job_def
where state = 'ENABLED'

--truncate table public.sch_job_def
