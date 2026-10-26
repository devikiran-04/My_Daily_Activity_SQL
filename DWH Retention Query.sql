
create table  dwh.mdm_communication_count_backup_202607 as 
SELECT * 
FROM dwh.mdm_communication_count where 1=0

INSERT INTO dwh.mdm_communication_count_backup_202607
SELECT  *
FROM dwh.mdm_communication_count where lp_date BETWEEN '20260701' and '20260731';


DELETE FROM dwh.mdm_communication_count where lp_date BETWEEN '20260701' and '20260731';


Select lp_date,count(*) FROM dwh.communication_count group by lp_date;     
Select lp_date,count(*) FROM dwh.communication_count_data group by lp_date;
Select lp_date,count(*) FROM dwh.mdms_communication_count group by lp_date;
Select lp_date,count(*) FROM dwh.mdms_communication_count_data group by lp_date;
Select lp_date,count(*) FROM dwh.mdm_communication_count group by lp_date;
Select lp_date,count(*) FROM dwh.mdm_communication_count_data group by lp_date;


-- Generate all individual statements (for copy-paste or file generation)
SELECT 
    'CREATE TABLE dwh.communication_count_backup_' || 
    TO_CHAR(dt, 'YYYYMM') || ' AS SELECT * FROM dwh.communication_count WHERE 1=0;' AS create_stmt,
    'INSERT INTO dwh.communication_count_backup_' || 
    TO_CHAR(dt, 'YYYYMM') || ' SELECT * FROM dwh.communication_count WHERE lp_date BETWEEN ''' || 
    TO_CHAR(dt, 'YYYYMMDD') || ''' AND ''' || 
    TO_CHAR((dt + INTERVAL '1 month')::DATE - 1, 'YYYYMMDD') || ''';' AS insert_stmt,
    'DELETE FROM dwh.communication_count WHERE lp_date BETWEEN ''' || 
    TO_CHAR(dt, 'YYYYMMDD') || ''' AND ''' || 
    TO_CHAR((dt + INTERVAL '1 month')::DATE - 1, 'YYYYMMDD') || ''';' AS delete_stmt
FROM generate_series(
    '20260601'::DATE,
    '20260601'::DATE,
    '1 month'::INTERVAL
) AS dt;

