DROP TABLE ALARM;
CREATE TABLE ALARM 		
(		
	MEMNAME          VARCHAR2 (64),	
	APPLICATION      VARCHAR2 (64),	
	GROUP_NAME       VARCHAR2 (64),	
	MESSAGE          VARCHAR2 (512) NOT NULL,	
	HANDLED          NUMBER NOT NULL,	
	JOB_NAME         VARCHAR2 (64),	
	SEVERITY         VARCHAR2 (1) NOT NULL,	
	ORDER_ID         VARCHAR2 (5),	
	USER_ID          VARCHAR2 (64),	
	NODE_ID          VARCHAR2 (50),	
	HOST_TIME        DATE,	
	CHANGED_BY       VARCHAR2 (64),	
	UPD_TIME         DATE,	
	NOTES            VARCHAR2 (100),	
	DATA_CENTER      VARCHAR2 (20) NOT NULL,	
	SERIAL           NUMBER NOT NULL,	
	TYPE             VARCHAR2 (1) DEFAULT 'R',	
	CLOSED_FROM_EM   VARCHAR2 (1),	
	TICKET_NUMBER    VARCHAR2 (15),	
	RUN_COUNTER      NUMBER,	
	REMEDY_PROFILE   VARCHAR2 (64)	
)		
TABLESPACE NEMUSER;		
		
CREATE UNIQUE INDEX UK_ALARM_0 		
ON ALARM		
(		
	SERIAL ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX ALARM_0 		
ON ALARM		
(		
	DATA_CENTER ASC,	
	ORDER_ID ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX ALARM_1 		
ON ALARM		
(		
	HANDLED ASC	
)		
TABLESPACE NEMUSER;		*/
