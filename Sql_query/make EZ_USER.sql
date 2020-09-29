CREATE TABLE EZ_USER 		
(		
	USER_CD                   NUMBER (9) NOT NULL,	
		
	/*
	USER_PW                   VARCHAR2 (50),	
	USER_GB                   CHAR (2) DEFAULT '01' NOT NULL,	
	NO_AUTH                   VARCHAR2 (4000),*/	
	DEPT_CD                   NUMBER (9) NOT NULL,	
	--DUTY_CD                   NUMBER (9) NOT NULL,	
	TEAM_CD                   NUMBER (9) NOT NULL,	
	USER_ID                   VARCHAR2 (50) NOT NULL,
  USER_NM                   VARCHAR2 (50) NOT NULL,	
  USER_HP                   VARCHAR2 (20),
  USER_JOB                  VARCHAR2 (1000)
    /*
   
    DEL_YN                    CHAR (1) DEFAULT 'N' NOT NULL,	
	RETIRE_YN                 CHAR (1) DEFAULT 'N' NOT NULL,	
	USER_EMAIL                VARCHAR2 (100),	
		
	USER_TEL                  VARCHAR2 (20),	
	SELECT_DATA_CENTER_CODE   VARCHAR2 (3),	
	PW_FAIL_CNT               NUMBER (1),	
	PW_DATE                   DATE,	
	BEFORE_PW                 VARCHAR2 (50),	
	ACCOUNT_LOCK              VARCHAR2 (1),	
	ABSENCE_START_DATE        DATE,	
	ABSENCE_END_DATE          DATE,	
	ABSENCE_REASON            VARCHAR2 (200),	
	ABSENCE_USER_CD           NUMBER (9),	
	INS_DATE                  DATE NOT NULL,	
	INS_USER_CD               NUMBER (9) NOT NULL,	
	INS_USER_IP               VARCHAR2 (50) NOT NULL,	
	UDT_DATE                  DATE,	
	UDT_USER_CD               NUMBER (9),	
	UDT_USER_IP               VARCHAR2 (50),	
	RESET_YN                  VARCHAR2 (1),	
	DEFAULT_PAGING            VARCHAR2 (5)	*/
)		