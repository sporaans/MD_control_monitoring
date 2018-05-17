select l.control_id,c.category,c.priority, c.description
	,sum(decode(resut_status,'F',1,0)) failed ,count(*) runned
	,round((sum(decode(l.resut_status,'F',1,0)) / count(*)),3) breach_frequency
from data_control_log l, data_control c
where log_date between to_date(:START_DATE) and to_date(:END_DATE)
and l.control_id = c.control_id
group by l.control_id,c.category,c.priority, c.description
having count(*)>:MIN_COUNT
order by breach_frequency desc,runned desc;
