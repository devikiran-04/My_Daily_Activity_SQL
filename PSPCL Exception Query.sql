select meter_number,meter_time,status_message from (
select 
row_number() over(partition by meter_number,to_char(dcu_time,'yyyy-mm-dd') order by dcu_time desc) rn,
* from fep.fep_csv_ed where meter_time between '2024-03-03 00:00:00'
and '2024-02-03 23:59:59' and 
status<>'Success' 
	)j where rn=1;
