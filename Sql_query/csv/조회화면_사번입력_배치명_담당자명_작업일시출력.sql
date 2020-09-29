-- 조회화면
-- 사번을 입력하면
-- --배치명(+설명), 작업일시, 성공여부, 담당자 출력
-- 페이징 10~20

-- 사번입력 / 배치명 (설명), 작업일시, 성공여부, ORDER_TIME 출력
SELECT JOB_NAME, DESCRIPTION, ORDER_TIME, STATUS, ORDER_TIME
FROM (
         SELECT ROW_NUMBER() over (ORDER BY ORDER_TIME) rnum, JOB_NAME, DESCRIPTION, ORDER_TIME, STATUS, ORDER_TIME
         FROM (
                  WITH JOB_T AS (
                      SELECT JOB_NAME, DESCRIPTION, ORDER_TIME, STATUS, ORDER_ID
                      FROM EZ_HISTORY
                      WHERE EZ_HISTORY.ODATE = '200813' --실행날짜
                        AND JOB_NAME in (
                          SELECT JOB_NAME --유저 일련번호로 담당 배치 찾기
                          FROM EZ_JOB_MAPPER
                          WHERE USER_CD_1 = (
                              SELECT USER_CD
                              FROM EZ_USER
                              WHERE USER_ID = 'SE12055' --사번으로 USER일련번호 찾기
                          )
                      )
                  ),
                       USERNM_T AS (
                           SELECT EZ_JOB_MAPPER.JOB_NAME, EZ_USER.USER_NM
                           FROM EZ_JOB_MAPPER,
                                EZ_USER
                           WHERE EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+)
                       )

                  SELECT JOB_T.JOB_NAME,
                         JOB_T.DESCRIPTION,
                         JOB_T.ORDER_TIME,
                         JOB_T.STATUS,
                         USERNM_T.USER_NM
                  FROM JOB_T,
                       USERNM_T
                  WHERE JOB_T.JOB_NAME = USERNM_T.JOB_NAME(+)
              )
    ORDER BY ORDER_TIME
     )
WHERE rnum BETWEEN 10 AND 20;