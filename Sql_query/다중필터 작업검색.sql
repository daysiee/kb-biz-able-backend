-- 담당자명, 소속부서, 작업명, 작업상태, 작업일시, 어플리케이션그룹, 작업그룹으로 검색(입력)
-- 그 결과 : 배치이름, 소속(부서), 이름, 상태, 시작시간, ##작업일련번호##를 전송하여 추후 상세정보 검색가능
WITH NAMEFILTER_T AS (
    SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM
    FROM EZ_JOB_MAPPER,
         (
             SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM
             FROM EZ_USER, EZ_DEPT
             WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)
             )
    WHERE EZ_JOB_MAPPER.USER_CD_1 = USER_CD(+)
      AND DEPT_NM LIKE '%%' -- 부서로 검색
      AND USER_NM LIKE '%%' -- 이름으로 검색
      AND JOB_NAME LIKE '%SLBD0099_S01%' -- 작업명으로 검색
),
JOBFILTER_T AS (
    SELECT JOB_NAME, STATUS, ORDER_TIME, ORDER_ID
    FROM EZ_HISTORY
    WHERE STATUS LIKE '%%' --성공여부로 검색
      AND APPLICATION LIKE '%%' -- 어플리케이션 그룹으로 검색
      AND GROUP_NAME LIKE '%%' -- 작업그룹으로 검색
      AND ODATE BETWEEN 200812 AND 200814 -- 실행기간 필터링
)

SELECT JOB_NAME, DEPT_NM, USER_NM, STATUS, ORDER_TIME, ORDER_ID
FROM (
         SELECT ROW_NUMBER() over (ORDER BY DEPT_NM) rnum, JOBFILTER_T.JOB_NAME, DEPT_NM, USER_NM, STATUS, ORDER_TIME, ORDER_ID
         FROM NAMEFILTER_T,
              JOBFILTER_T
         WHERE JOBFILTER_T.JOB_NAME = NAMEFILTER_T.JOB_NAME
     )
WHERE rnum BETWEEN 1 AND 100;







