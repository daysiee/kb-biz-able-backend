			
select 			
	( SELECT SUBSTR(scode_nm, 5) FROM ROOT.EZ_SCODE WHERE SUBSTR(scode_nm, 1, 3) = u.data_center_code ) AS data_center
	,u.data_center_code		
	,u.active_net_name		
	,SUM(CASE WHEN STATE_RESULT='dual' THEN 0 ELSE 1 END) AS total_count		
	,SUM(CASE WHEN STATE_RESULT='Wait User' THEN 1 ELSE 0 END) AS wait_user		
	,SUM(CASE WHEN STATE_RESULT='Wait Time' THEN 1 ELSE 0 END) AS wait_time		
	,SUM(CASE WHEN STATE_RESULT='Wait Condition' THEN 1 ELSE 0 END) AS wait_condition		
	,SUM(CASE WHEN STATE_RESULT='Wait Host' THEN 1 ELSE 0 END) AS wait_host		
	,SUM(CASE WHEN STATE_RESULT='Wait Resource' THEN 1 ELSE 0 END) AS wait_resource		
	 		
	,SUM(CASE WHEN STATE_RESULT='Executing' THEN 1 ELSE 0 END) AS executing		
	,SUM(CASE WHEN STATE_RESULT='Ended OK' THEN 1 ELSE 0 END) AS ended_ok		
	,SUM(CASE WHEN STATE_RESULT='Ended Not OK' THEN 1 ELSE 0 END) AS ended_not_ok		
	,SUM(CASE WHEN STATE_RESULT='Unknown' THEN 1 ELSE 0 END) AS unknown		
	,SUM(CASE WHEN STATE_RESULT='Deleted' THEN 1 ELSE 0 END) AS deleted		
	,SUM(CASE WHEN STATE_RESULT='Not in AJF' THEN 1 ELSE 0 END) AS etc		
from (			
	select * from(		
		SELECT 	
			'oractm90' AS data_center
			,'001' AS data_center_code
			,'A200813001_A' AS active_net_name
			,case when DELETE_FLAG='1' then 'Deleted'
	               else STATUS end AS state_result		
		FROM ROOT.EZ_HISTORY
		where 1 = 1	
		and odate = REPLACE(SUBSTR('2020/08/13', 3, 8), '/', '')	
		UNION ALL	
		SELECT 	
			'oractm90' AS data_center
			,'001' AS data_center_code
			,'A200813001_A' AS active_net_name
			,case when DELETE_FLAG='1' then 'Deleted'
	               else STATUS end AS state_result		
		FROM ROOT.EZ_HISTORY
		WHERE ORDER_ID NOT IN (select s.order_id from ROOT.EZ_HISTORY where s.odate = REPLACE(SUBSTR('2020/08/13', 3, 8), '/', '') )
			
		and odate = REPLACE(SUBSTR('2020/08/13', 3, 8), '/', '')	
	) tb1		
	where 1=1		
	UNION ALL		
	SELECT 		
		'oractm90' AS data_center	
		,'001' AS data_center_code	
		,'A200813001_A' AS active_net_name	
		,'dual'	
	FROM dual		
) u			
where 1=1			
group by u.data_center,u.data_center_code,u.active_net_name			
order by u.data_center_code
