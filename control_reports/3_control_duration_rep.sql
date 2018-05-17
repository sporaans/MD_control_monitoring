--Long running main controls
select l.control_id,l.log_date,c.category,c.priority, c.frequency, c.description
	, trunc(l.control_duration/60)||' min '||mod(l.control_duration,60)||' s' duration
from data_control_log l, data_control c
where l.control_id = C.control_id
and   l.log_date between to_date(:START_DATE,'DD-MON-YYYY') and to_date(:END_DATE,'DD-MON-YYYY')
and   l.control_duration >= 60* :MIN_DURATION;

--Long running detail controls
select l.control_id,l.log_date,c.category,c.priority, c.frequency, c.description
	, trunc(l.detail_duration/60)||' min '||mod(l.detail_duration,60)||' s' duration
from data_control_log l, data_control c
where l.control_id = c.control_id
and   l.log_date between to_date(:START_DATE,'DD-MON-YYYY') and to_date(:END_DATE,'DD-MON-YYYY')
and   l.detail_duration >= 60* :MIN_DURATION;

