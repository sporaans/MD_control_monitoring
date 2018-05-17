with sup_tres as (select max(count(*)) total,max(count(*))*:MIN_SUPPORT min_sup from data_control_log
                 where log_date between :START_DATE and :END_DATE
                 group by control_id)
	,ctrl_sup as (select l.control_id,sum(DECODE(result_status,'F',1,0)) failed_count ,count(*) runned
				 from data_control_log l
				 where l.log_date between :START_DATE and :END_DATE
				 group by l.control_id
				 having count(*)> sum(DECODE(result_status,'F',1,0)) 
				 and sum(DECODE(result_status,'F',1,0)) >= (select min_sup from sup_tres))
select b.control_id_1||' -> '||b.control_id_2 control_id
     ,round(count(*)/c.total,2) support
     ,round((count(*)*c.total)/(b.failed_count_1*b.failed_count_2),2) lift 
from data_control_log a, sup_tres c
    ,(select a.control_id control_id_1, b.control_id control_id_2
      ,a.failed_count failed_count_1,b.failed_count failed_count_2 from ctrl_sup a,ctrl_sup b) b
where a.control_id = b.control_id_1
and a.log_date between :START_DATE and :END_DATE
and a.result_status = 'F'
and B.CONTROL_ID_1 != B.CONTROL_ID_2
and exists (select 1 from data_control_log c
            where trunc(a.log_date) = trunc(c.log_date)
            and   c.control_id = b.control_id_2
            and   c.result_status = 'F')
group by B.CONTROL_ID_1,B.CONTROL_ID_2,c.total,b.failed_count_1,b.failed_count_2
having count(*)/c.total >= :MIN_SUPPORT;
