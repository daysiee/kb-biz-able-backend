CREATE TABLE EZ_HISTORY 	
(	
	ORDER_ID                   VARCHAR2 (5) NOT NULL,
	APPLICATION                VARCHAR2 (64),
	GROUP_NAME                 VARCHAR2 (64),
	MEMNAME                    VARCHAR2 (64),
	RBA                        VARCHAR2 (6),
	GRP_RBA                    VARCHAR2 (6),
	MEM_LIB                    VARCHAR2 (255),
	OWNER                      VARCHAR2 (30),
	TASK_TYPE                  VARCHAR2 (21),
	JOB_NAME                   VARCHAR2 (64),
	JOB_ID                     VARCHAR2 (17),
	ODATE                      VARCHAR2 (6),
	MAX_WAIT                   NUMBER,
	DESCRIPTION                VARCHAR2 (4000),

	CONFIRM_FLAG               VARCHAR2 (1) NOT NULL,
	PREVENT_NCT2               VARCHAR2 (1),

	INTERVAL VARCHAR2 (6),
	--RERUN_MEM                  VARCHAR2 (8),
	--NEXT_TIME                  VARCHAR2 (14),
	PRIORITY                   VARCHAR2 (2),
	CPU_ID                     VARCHAR2 (50),
	/*NJE                        VARCHAR2 (1),
	SEARCH_COUNT               NUMBER,
	MAX_RERUN                  NUMBER,
	AUTO_ARCHIVE               VARCHAR2 (1) NOT NULL,
	SYSDB                      VARCHAR2 (1) NOT NULL,
	MAX_DAYS                   NUMBER,
	MAX_RUNS                   NUMBER,*/
	AVG_RUNTIME                VARCHAR2 (6),
	/*STD_DEV                    VARCHAR2 (6),
	SYSOPT                     VARCHAR2 (16),
	FROM_CLASS                 VARCHAR2 (1),
	PARM                       VARCHAR2 (255),
	STATE_DIGITS               VARCHAR2 (15),
	STATUS                     VARCHAR2 (16) NOT NULL,
	STATE                      VARCHAR2 (40),
	DELETE_FLAG                VARCHAR2 (1) NOT NULL,
	SEQ_CNT                    NUMBER,
	START_TIME                 VARCHAR2 (14),
	END_TIME                   VARCHAR2 (14),
	RERUN_COUNTER              NUMBER,
	NR_RECORDS                 NUMBER,
	OVER_LIB                   VARCHAR2 (255),*/
	CMD_LINE                   VARCHAR2 (512),
	/*CRITICAL                   VARCHAR2 (1),
	CYCLIC                     VARCHAR2 (1),
	DUE_IN                     VARCHAR2 (4),
	DUE_OUT                    VARCHAR2 (4),
	ELAPSED                    NUMBER,*/
	NODEGROUP                  VARCHAR2 (50),
	/*NJE_NODE                   VARCHAR2 (8),
	TASK_CLASS                 VARCHAR2 (3),
	IND_CYCLIC                 VARCHAR2 (1),
	RETEN_DAYS                 VARCHAR2 (3),
	RETEN_GEN                  VARCHAR2 (2),
	ORDER_TABLE                VARCHAR2 (770),
	ORDER_LIB                  VARCHAR2 (44),
	STICKY_IND                 VARCHAR2 (1),
	SEQ_CNT_ADDED              NUMBER,
	SHORT_FFU                  VARCHAR2 (12),
	DSECT_FFU                  VARCHAR2 (100),
	ISN_                       NUMBER NOT NULL,
	TIME_REF                   VARCHAR2 (1),
	TIME_ZONE                  VARCHAR2 (9),
	APPL_TYPE                  VARCHAR2 (10),
	APPL_VER                   VARCHAR2 (10),
	APPL_FORM                  VARCHAR2 (30),
	CM_VER                     VARCHAR2 (10),
	STATE_MASK                 VARCHAR2 (9),
	MULTY_AGENT                VARCHAR2 (1),
	SCHEDULE_ENV               VARCHAR2 (16),
	SYS_AFFINITY               VARCHAR2 (5),
	REQ_NJE_NODE               VARCHAR2 (8),
	ADJUST_COND                VARCHAR2 (1),
	IN_SERVICE                 VARCHAR2 (255),
	STAT_CAL                   VARCHAR2 (30),
	STAT_PERIOD                VARCHAR2 (1),
	INSTREAM_JCL               CLOB,
	USE_INSTREAM_JCL           VARCHAR2 (1),
	LPAR                       VARCHAR2 (8),
	DUE_OUT_DAYSOFFSET         VARCHAR2 (3),
	FROM_DAYSOFFSET            VARCHAR2 (3),
	TO_DAYSOFFSET              VARCHAR2 (3),*/
	ORDER_TIME                 VARCHAR2 (14),
	AVG_START_TIME             VARCHAR2 (6),
	/*CPU_TIME                   NUMBER,
	EM_STAT_CAL_CTM            VARCHAR2 (20),
	EM_STAT_CAL                VARCHAR2 (30),
	EM_STAT_PERIOD             VARCHAR2 (1),
	INTERVAL_SEQUENCE          VARCHAR2 (4000),
	SPECIFIC_TIMES             VARCHAR2 (4000),
	TOLERANCE                  NUMBER,
	CYCLIC_TYPE                VARCHAR2 (1),
	CURRENT_RUN                NUMBER,
	ELAPSED_RUNTIME            NUMBER,
	WORKLOADS                  VARCHAR2 (525),*/
	DEF_NODEGROUP              VARCHAR2 (50)
	/*NODEGROUP_SET_BY           VARCHAR2 (1),
	FAILURE_RC                 VARCHAR2 (5),
	FAILURE_RC_STEP            VARCHAR2 (8),
	FAILURE_RC_PROCSTEP        VARCHAR2 (8),
	HIGHEST_RC                 VARCHAR2 (5),
	HIGHEST_RC_STEP            VARCHAR2 (8),
	HIGHEST_RC_PROCSTEP        VARCHAR2 (8),
	HIGHEST_RC_MEMNAME         VARCHAR2 (8),
	ASSOCIATED_RBC             VARCHAR2 (20),
	CM_STATUS                  VARCHAR2 (32),
	DEPEND_SERVICE_IN          VARCHAR2 (1),
	DEPEND_SERVICE_OUT         VARCHAR2 (1),
	EM_STAT_DETAIL_DATA        VARCHAR2 (1500),
	PREV_ODATE_RERUN_COUNTER   NUMBER,
	JOBRC                      VARCHAR2 (5),
	REMOVEATONCE               VARCHAR2 (1),
	DAYSKEEPINNOTOK            NUMBER,
	DELAY                      NUMBER,
	BIMINFO                    VARCHAR2 (20),
	STD_DEV_START_TIME         VARCHAR2 (11),
	END_FOLDER                 VARCHAR2 (1)
    
    FROM_PGMSTEP               VARCHAR2 (8),
	FROM_PROCSTEP              VARCHAR2 (8),
	TO_PGMSTEP                 VARCHAR2 (8),
	TO_PROCSTEP                VARCHAR2 (8),
    DOC_MEM                    VARCHAR2 (64),
	DOC_LIB                    VARCHAR2 (255),
	FROM_TIME                  VARCHAR2 (4),
	TO_TIME                    VARCHAR2 (4),*/
)	
TABLESPACE NEMUSER;	
	
/*CREATE INDEX EZ_HISTORY_0 	
ON EZ_HISTORY	
(	
	ORDER_ID ASC
)	
TABLESPACE NEMUSER ;	
	
CREATE INDEX EZ_HISTORY_1 	
ON EZ_HISTORY	
(	
	ODATE ASC
)	
TABLESPACE NEMUSER ;	*/
