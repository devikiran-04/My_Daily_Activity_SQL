BLP 08:00:00
****************
select * from dwh.uhes_sla_sat where request_date between '20250502' and '20250601' and profile_name='BLP' and sla_time='08:00:00'
 
BLP 12:00:00
****************
select * from dwh.uhes_sla_sat where request_date between '20250502' and '20250601' and profile_name='BLP' and sla_time='12:00:00'
 
BLP 24:00:00
****************
select * from dwh.uhes_sla_sat where request_date between '20250502' and '20250601' and profile_name='BLP' and sla_time='24:00:00'
 
DLP 24:00:00
****************
select * from dwh.uhes_sla_sat where request_date between '20250502' and '20250601' and profile_name='DLP' and sla_time='24:00:00'
 
EOB 12
******
select * from dwh.uhes_sla_sat where request_date between '20250502' and '20250601' and profile_name='EOB' and sla_time='12:00:00'
 
EOB 72
******
select * from dwh.uhes_sla_sat where request_date='20250604'  and profile_name='EOB' and sla_time='72:00:00'
