
SELECT *
FROM   (SELECT rownum as row_num,
               TTT.*
        FROM   (select 
/*+ INDEX_ASC (t, UK_ALARM_0) */
                  memname ,
                       application ,
                       group_name ,
                       message ,
                       handled ,
                       (
                                                       case
                                                         when handled = 2 then 'Handled'
                                                         when handled = 1 then 'Noticed'
                                                         else 'Not Noticed'
                                                       end ) as handled_name ,
                       job_name ,
                       severity ,
                       order_id ,
                       t.user_id ,
                       node_id ,
                       TO_CHAR(host_time, 'YYYY/MM/DD HH24:MI:SS') AS host_time ,
                       changed_by ,
                       TO_CHAR(upd_time, 'YYYY/MM/DD HH24:MI:SS') AS upd_time ,
                       notes ,
                       t.data_center ,
                       serial ,
                       type ,
                       closed_from_em ,
                       ticket_number ,
                       run_counter ,
                       t3.user_nm
                from   ROOT.alarm t LEFT OUTER JOIN (SELECT *
                        FROM   ROOT.EZ_JOB_MAPPER
                        WHERE  data_center = :1 ) t2 on t.job_name = t2.job LEFT OUTER JOIN ROOT.EZ_USER t3 on ROOT.user_cd_1 = ROOT.user_cd
                where  1=1
                and    severity = :2
                and    t.data_center = :3
                and    TO_CHAR(t.host_time, 'yyyy/mm/dd') >= :4
                and    TO_CHAR(t.host_time, 'yyyy/mm/dd') <= :5
                order by serial DESC )TTT ) tb1
WHERE  row_num between :6 and :7 ;
