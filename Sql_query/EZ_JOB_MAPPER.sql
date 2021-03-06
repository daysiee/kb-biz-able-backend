			
CREATE TABLE EZ_JOB_MAPPER 			
(			
	DATA_CENTER         VARCHAR2 (64) NOT NULL,		
	JOB                 VARCHAR2 (64) NOT NULL,		
	USER_CD_1           NUMBER,		
	USER_CD_2           NUMBER,		
	USER_CD_3           NUMBER,		
	USER_CD_4           NUMBER,		
	DESCRIPTION         VARCHAR2 (4000),		
	/*INS_DATE            DATE NOT NULL,		
	INS_USER_CD         NUMBER NOT NULL,		
	INS_USER_IP         VARCHAR2 (50) NOT NULL,		
	UDT_DATE            DATE,		
	UDT_USER_CD         NUMBER,		
	UDT_USER_IP         VARCHAR2 (50),	*/	
	SMS_1               VARCHAR2 (1),		
	SMS_2               VARCHAR2 (1),		
	SMS_3               VARCHAR2 (1),		
	SMS_4               VARCHAR2 (1),		
	ERROR_DESCRIPTION   VARCHAR2 (4000)		
	/*LOG_NAME_1          VARCHAR2 (100),		
	LOG_NAME_2          VARCHAR2 (100),		
	LOG_PATH_1          VARCHAR2 (500),		
	LOG_PATH_2          VARCHAR2 (500),		
	TRANS_YN            VARCHAR2 (1),		
	SEND_GUBUN          VARCHAR2 (1),		
	MAIL_1              VARCHAR2 (1),		
	MAIL_2              VARCHAR2 (1),		
	MAIL_3              VARCHAR2 (1),		
	MAIL_4              VARCHAR2 (1),		
	LATE_SUB            VARCHAR2 (4),		
	LATE_TIME           VARCHAR2 (4),		
	LATE_EXEC           VARCHAR2 (10),		
	APPLY_DATE          DATE,		
	APPLY_CD            VARCHAR2 (25),		
	APPLY_CHECK         VARCHAR2 (25),		
	CANCEL_COMMENT      VARCHAR2 (25),		
	USER_CD_5           NUMBER,		
	SMS_5               VARCHAR2 (1),		
	MAIL_5              VARCHAR2 (1),		
	USER_CD_6           NUMBER,		
	SMS_6               VARCHAR2 (1),		
	MAIL_6              VARCHAR2 (1),		
	USER_CD_7           NUMBER,		
	SMS_7               VARCHAR2 (1),		
	MAIL_7              VARCHAR2 (1),		
	USER_CD_8           NUMBER,		
	SMS_8               VARCHAR2 (1),		
	MAIL_8              VARCHAR2 (1),		
	USER_CD_9           NUMBER,		
	SMS_9               VARCHAR2 (1),		
	MAIL_9              VARCHAR2 (1),		
	USER_CD_10          NUMBER,		
	SMS_10              VARCHAR2 (1),		
	MAIL_10             VARCHAR2 (1)	*/	
)			
TABLESPACE NEMUSER;			
			
CREATE UNIQUE INDEX PK_EZ_JOB_MAPPER 			
ON EZ_JOB_MAPPER			
(			
	DATA_CENTER ASC,		
	JOB ASC		
)			
TABLESPACE NEMUSER;			
