insert into fuel.ext_req_trans_old
select * from fuel.ext_req_trans 
where req_time<date_trunc('day', now() - interval '10 days');

delete from fuel.ext_req_trans 
where req_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.ext_req_trans;
vacuum analyze fuel.ext_req_trans_old;



insert into fuel.ext_res_trans_old
select * from fuel.ext_res_trans 
where res_time<date_trunc('day', now() - interval '10 days');

delete from fuel.ext_res_trans 
where res_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.ext_res_trans;
vacuum analyze fuel.ext_res_trans_old;



insert into fuel.ext_req_status_old
select * from fuel.ext_req_status 
where status_time<date_trunc('day', now() - interval '10 days');

delete from fuel.ext_req_status 
where status_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.ext_req_status;
vacuum analyze fuel.ext_req_status_old;



insert into fuel.intr_req_trans_old
select * from fuel.intr_req_trans 
where req_time<date_trunc('day', now() - interval '10 days');

delete from fuel.intr_req_trans 
where req_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.intr_req_trans;
vacuum analyze fuel.intr_req_trans_old;


insert into fuel.intr_res_trans_old
select * from fuel.intr_res_trans 
where res_time<date_trunc('day', now() - interval '10 days');

delete from fuel.intr_res_trans 
where res_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.intr_res_trans;
vacuum analyze fuel.intr_res_trans_old;




insert into fuel.notification_info_old
select * from fuel.notification_info 
where notify_time<date_trunc('day', now() - interval '10 days');

delete from fuel.notification_info 
where notify_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.notification_info;
vacuum analyze fuel.notification_info_old;



insert into fuel.notification_status_old
select * from fuel.notification_status 
where dispatch_time<date_trunc('day', now() - interval '10 days');

delete from fuel.notification_status 
where dispatch_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.notification_status;
vacuum analyze fuel.notification_status_old;



insert into fuel.ext_res_status_old
select * from fuel.ext_res_status 
where status_time<date_trunc('day', now() - interval '10 days');

delete from fuel.ext_res_status 
where status_time<date_trunc('day', now() - interval '10 days');

vacuum analyze fuel.ext_res_status;
vacuum analyze fuel.ext_res_status_old;
