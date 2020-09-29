--SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'


/*SELECT JOB, ERROR_DESCRIPTION FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
    SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
    )

SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
        SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
    )
*/
SELECT ODATE, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
        SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
        )
    )




SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = (
    SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
    )

-- 부서명으로 검색 - JOB_NAME, ODATE, ORDER_TIME, DESCRIPTION 출력

SELECT JOB_NAME, ODATE, ORDER_TIME, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 in (
        SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = (
            SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
            )
        )
    )
--UNION
--  부서로 검색하였을때 배치이름이랑 USER_CD 출력

SELECT JOB, USER_CD_1 FROM EZ_JOB_MAPPER WHERE USER_CD_1 in (
        SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = (
            SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
    )
) ORDER BY USER_CD_1 ASC

-----

SELECT USER_NM FROM EZ_USER WHERE DEPT_CD = (
    SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
    )


-----

SELECT JOB_NAME, ODATE, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 in (
        SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = (
            SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
            )
        )
    )

--- 임시테이블 With

WITH T AS (
    SELECT JOB_NAME FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 in (
        SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = (
            SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM = '비즈니스시스템부'
            )
        )
    )
)



SELECT USER_NM FROM T, EZ_USER WHERE T.JOB_NAME =

---

SELECT * FROM EZ_HISTORY WHERE JOB_NAME = 'SRBD0037_S02';

---- 부서명으로 검색하였을때
-- 배치명, Odate, 디스크립션 // 담당자, Status(성공,실패-에러디스크립션) 출력 - 완료
WITH J_T AS (
    SELECT JOB_NAME, ORDER_ID, ORDER_TIME, ODATE, DESCRIPTION
    FROM EZ_HISTORY
    WHERE JOB_NAME in (
       SELECT JOB_NAME
       FROM EZ_JOB_MAPPER
       WHERE USER_CD_1 in (
           SELECT USER_CD
           FROM EZ_USER
           WHERE DEPT_CD = (
               SELECT DEPT_CD
               FROM EZ_DEPT
               WHERE DEPT_NM = '데이터플랫폼부'
           )
       )
   )
),
MAPPER_T AS(
    SELECT JOB_NAME, USER_NM FROM EZ_JOB_MAPPER
    JOIN EZ_USER
    ON EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD
),
ERROR_CHK_T AS(
    SELECT EZ_HISTORY.ORDER_ID, ALARM.MESSAGE
    FROM EZ_HISTORY, ALARM
    WHERE EZ_HISTORY.ORDER_ID = ALARM.ORDER_ID(+)
)

SELECT J_T.JOB_NAME, J_T.ORDER_ID, J_T.ODATE, J_T.ORDER_TIME, J_T.DESCRIPTION,
       MAPPER_T.USER_NM, /*DECODE(ERROR_CHK_T.MESSAGE, NULL, 'SUCCESS', 'FAIL') as SUCCESS,*/ ERROR_CHK_T.MESSAGE
FROM J_T , MAPPER_T, ERROR_CHK_T
WHERE J_T.JOB_NAME = MAPPER_T.JOB_NAME AND  J_T.ORDER_ID = ERROR_CHK_T.ORDER_ID ;




  --AND ODATE = 200813;





---test
SELECT EZ_HISTORY.ORDER_ID, ALARM.MESSAGE
    FROM EZ_HISTORY, ALARM
    WHERE EZ_HISTORY.ORDER_ID = ALARM.ORDER_ID(+);
--


ALTER TABLE EZ_HISTORY ADD STATUS VARCHAR2(20) DEFAULT 'SUCCESS' NOT NULL;
UPDATE EZ_HISTORY SET STATUS CASE WHEN ALARM.