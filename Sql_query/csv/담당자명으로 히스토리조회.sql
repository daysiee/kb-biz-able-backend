--SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'


/*SELECT JOB, ERROR_DESCRIPTION FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
    SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
    )

SELECT JOB FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
        SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
    )
*/
SELECT ODATE, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB_NAME FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
        SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
        )
    )

