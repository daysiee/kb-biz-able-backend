/*
   1. 개인 작업 조회 (PARAM : USER_ID (사번))
 */

--개인작업 조회(로그인 한 사원의 BATCH 내역)
WITH OPERATION AS (
    SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_OPER
    FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER
    WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '01%' AND ODATE = '200812'
    GROUP BY STATUS, ODATE, USER_CD
), INFORMATION AS (
    SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_INFO
    FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER
    WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '02%'AND ODATE = '200812'
    GROUP BY STATUS, ODATE, USER_CD
), EDW AS (
    SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_EDW
    FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER
    WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '03%' AND ODATE = '200812'
    GROUP BY STATUS, ODATE, USER_CD
), ETC AS (
    SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_ETC
    FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER
    WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND REGEXP_LIKE(APPLICATION, '99|10|11|BMC|16|15|12') AND ODATE = '200812'
    GROUP BY STATUS, ODATE, USER_CD
), USERINFO AS (
        select USER_CD, USER_ID, STATUS
        from( SELECT USER_CD, USER_ID, 'SUCCESS' AS SUCCESS, 'FAIL' AS FAIL
        FROM EZ_USER)
        UNPIVOT (VALUE FOR STATUS IN (SUCCESS, FAIL))
)
SELECT USERINFO.USER_CD, USERINFO.USER_ID, USERINFO.STATUS, DECODE(CNT_OPER, NULL, 0, CNT_OPER) AS CNT_OPER, DECODE(CNT_INFO, NULL, 0, CNT_INFO) AS CNT_INFO, DECODE(CNT_EDW,NULL, 0, CNT_EDW) AS CNT_EDW,
       DECODE(CNT_ETC,NULL, 0, CNT_ETC) AS CNT_ETC
FROM OPERATION, INFORMATION, EDW, ETC, USERINFO
WHERE USERINFO.USER_CD = OPERATION.USER_CD(+) AND  USERINFO.USER_CD = INFORMATION.USER_CD(+) AND USERINFO.USER_CD = EDW.USER_CD(+) AND USERINFO.USER_CD = ETC.USER_CD(+) AND USERINFO.STATUS = OPERATION.STATUS(+)
AND USERINFO.STATUS = INFORMATION.STATUS(+) AND USERINFO.STATUS = EDW.STATUS(+) AND USERINFO.STATUS = ETC.STATUS(+) AND USERINFO.USER_ID ='SE02231'; -- PARAM은 사번
