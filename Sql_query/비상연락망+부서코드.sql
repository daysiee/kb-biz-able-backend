-- 비상연락망 + 부서이름

SELECT ODATE, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in (
    SELECT JOB_NAME FROM EZ_JOB_MAPPER WHERE USER_CD_1 = (
        SELECT USER_CD FROM EZ_USER WHERE USER_NM = '신혜가'
        )
    );


-- 위에서부터 부서이름, 유저이름, 휴대전화, 업무
SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB
FROM EZ_USER, EZ_DEPT
WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+) AND ROWNUM <= 20 AND USER_NM = '전다가';



-------------- 이름과 업무로 비상연락망 검색하기 ----------------

-- 비상연락망 (이름('준')검색가능) : 부서이름, 유저이름, 휴대전화, 업무, 사용자 일련번호 // 페이징 1~100
SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD
FROM (
         SELECT ROW_NUMBER() over (ORDER BY USER_NM) rnum, DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD
         FROM (
                  SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB, EZ_USER.USER_CD
                  FROM EZ_USER,
                       EZ_DEPT
                  WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)
                    AND USER_NM LIKE'%인%' --이 이름 필터를 지우면 전체 검색 가능
              )
         ORDER BY USER_NM
     )
WHERE rnum BETWEEN 1 AND 20;


-- 비상연락망 (업무('청약')검색가능) : 부서이름, 유저이름, 휴대전화, 업무, 사용자 일련번호 // 페이징 1~10000
SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD
FROM (
         SELECT ROW_NUMBER() over (ORDER BY USER_NM) rnum, DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD
         FROM (
                  SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD
                  FROM EZ_USER,
                       EZ_DEPT
                  WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)
                    AND USER_JOB LIKE '%약%' --이 업무 필터를 지우면 전체 검색 가능
              )
         ORDER BY USER_NM
     )
WHERE rnum BETWEEN 0 AND 1000000;