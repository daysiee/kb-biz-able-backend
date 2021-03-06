--DROP TABLE ROOT.DEF_JOB;
--DROP TABLE ROOT.PEAR;
--DROP TABLE ROOT.EZ_DEPT;
CREATE TABLE DEF_JOB 		
(		
	JOB_ID                 NUMBER NOT NULL,	
    TABLE_ID               NUMBER NOT NULL,	
    JOB_ORDER              NUMBER NOT NULL,	
	APPLICATION            VARCHAR2 (64),	
	GROUP_NAME             VARCHAR2 (64),	
	MEMNAME                VARCHAR2 (64),	
	JOB_NAME               VARCHAR2 (64),	
    AUTHOR                 VARCHAR2 (64),	
	OWNER                  VARCHAR2 (30),	
    TASK_TYPE              VARCHAR2 (21),	
    NODE_ID                VARCHAR2 (50),	
    MEM_LIB                VARCHAR2 (255),	
    APPL_TYPE              VARCHAR2 (10),	
    APPL_FORM              VARCHAR2 (30),	
    CREATION_USER          VARCHAR2 (64),	
    CHANGE_USERID          VARCHAR2 (64),	
    PARENT_TABLE           VARCHAR2 (770),	
    OVER_LIB               VARCHAR2 (255),	
    DAYS_CAL               VARCHAR2 (30),	
    WEEKS_CAL              VARCHAR2 (30),	
    CONF_CAL               VARCHAR2 (30),	
    STAT_CAL               VARCHAR2 (30),	
    CMD_LINE               VARCHAR2 (512),	
    CYCLIC                 VARCHAR2 (1) NOT NULL,	
    END_FOLDER             VARCHAR2 (1)	
    
    /*
    DESCRIPTION            VARCHAR2 (4000),	
	PRIORITY               VARCHAR2 (200),	
	CRITICAL               VARCHAR2 (1) NOT NULL,	
	DOC_LIB                VARCHAR2 (255),	
	DOC_MEM                VARCHAR2 (64),	
	INTERVAL VARCHAR2 (6),	
	CONFIRM_FLAG           VARCHAR2 (1) NOT NULL,	
	RETRO                  VARCHAR2 (1) NOT NULL,	
	MAX_WAIT               NUMBER,	
	MAX_RERUN              NUMBER NOT NULL,	
	AUTO_ARCHIVE           VARCHAR2 (1) NOT NULL,	
	MAX_DAYS               NUMBER,	
	MAX_RUNS               NUMBER,	
	FROM_TIME              VARCHAR2 (4),	
	TO_TIME                VARCHAR2 (4),	
	DAY_STR                VARCHAR2 (160),	
	W_DAY_STR              VARCHAR2 (50),	
	MONTH_1                VARCHAR2 (1) NOT NULL,	
	MONTH_2                VARCHAR2 (1) NOT NULL,	
	MONTH_3                VARCHAR2 (1) NOT NULL,	
	MONTH_4                VARCHAR2 (1) NOT NULL,	
	MONTH_5                VARCHAR2 (1) NOT NULL,	
	MONTH_6                VARCHAR2 (1) NOT NULL,	
	MONTH_7                VARCHAR2 (1) NOT NULL,	
	MONTH_8                VARCHAR2 (1) NOT NULL,	
	MONTH_9                VARCHAR2 (1) NOT NULL,	
	MONTH_10               VARCHAR2 (1) NOT NULL,	
	MONTH_11               VARCHAR2 (1) NOT NULL,	
	MONTH_12               VARCHAR2 (1) NOT NULL,	
	DATES_STR              VARCHAR2 (255),	
	RERUN_MEM              VARCHAR2 (8),	
	DAYS_AND_OR            VARCHAR2 (1),	
	CTLD_CATEGORY          VARCHAR2 (20),	
	SHIFT                  VARCHAR2 (10),	
	SHIFT_NUM              VARCHAR2 (3),	
	PDS                    VARCHAR2 (44),	
	MIN_PDS_TRACKS         VARCHAR2 (3),	
	PREVENT_NCT2           VARCHAR2 (1),	
	SYSOPT                 VARCHAR2 (16),	
	FROM_CLASS             VARCHAR2 (1),	
	PARM                   VARCHAR2 (255),	
	SYSDB                  VARCHAR2 (1) NOT NULL,	
	DUE_OUT                VARCHAR2 (4),	
	RETEN_DAYS             VARCHAR2 (3),	
	RETEN_GEN              VARCHAR2 (2),	
	TASK_CLASS             VARCHAR2 (3),	
	JOB_NO                 VARCHAR2 (10),	
	PREV_DAY               VARCHAR2 (1),	
	ADJUST_COND            VARCHAR2 (1),	
	JOBS_IN_GROUP          VARCHAR2 (5),	
	LARGE_SIZE             VARCHAR2 (6),	
	IND_CYCLIC             VARCHAR2 (1),	
	CREATION_DATE          VARCHAR2 (8),	
	CREATION_TIME          VARCHAR2 (8),	
	CHANGE_DATE            VARCHAR2 (8),	
	CHANGE_TIME            VARCHAR2 (8),	
	JOB_RELESE             VARCHAR2 (10),	
	JOB_VERSION            VARCHAR2 (5),	
	TAG_RELATIONSHIP       VARCHAR2 (1),	
	TIME_REF               VARCHAR2 (1),	
	TIME_ZONE              VARCHAR2 (9),	
	APPL_VER               VARCHAR2 (10),	
	CM_VER                 VARCHAR2 (10),	
	STATE_MASK             VARCHAR2 (9),	
	MULTY_AGENT            VARCHAR2 (1),	
	ACTIVE_FROM            VARCHAR2 (8),	
	ACTIVE_TILL            VARCHAR2 (8),	
	SCHEDULE_ENV           VARCHAR2 (16),	
	SYS_AFFINITY           VARCHAR2 (5),	
	REQ_NJE_NODE           VARCHAR2 (8),	
	INSTREAM_JCL           CLOB,	
	USE_INSTREAM_JCL       VARCHAR2 (1),	
	DUE_OUT_DAYSOFFSET     VARCHAR2 (3),	
	FROM_DAYSOFFSET        VARCHAR2 (3),	
	TO_DAYSOFFSET          VARCHAR2 (3),	
	VERSION_OPCODE         VARCHAR2 (1) NOT NULL,	
	IS_CURRENT_VERSION     VARCHAR2 (1),	
	VERSION_SERIAL         NUMBER NOT NULL,	
	VERSION_HOST           VARCHAR2 (255) NOT NULL,	
	CHECKSUM               VARCHAR2 (256) NOT NULL,	
	DELETION_TIMESTAMP     VARCHAR2 (14),	
	DELETION_USER          VARCHAR2 (64),	
	DELETION_HOST          VARCHAR2 (255),	
	VERSION_TIMESTAMP      VARCHAR2 (14) NOT NULL,	
	SYNC_TIMESTAMP         VARCHAR2 (14),	
	VERSION_USER           VARCHAR2 (64) NOT NULL,	
	SYNC_TYPE              VARCHAR2 (1) NOT NULL,	
	INTERVAL_SEQUENCE      VARCHAR2 (4000),	
	SPECIFIC_TIMES         VARCHAR2 (4000),	
	TOLERANCE              NUMBER,	
	CYCLIC_TYPE            VARCHAR2 (1),	
	EXPIRATION_TIMESTAMP   VARCHAR2 (14),	
	REMOVEATONCE           VARCHAR2 (1),	
	DAYSKEEPINNOTOK        NUMBER,	
	DELAY                  NUMBER,	
	*/
)		
TABLESPACE NEMUSER;		
		
/*CREATE UNIQUE INDEX PK_DEF_JOB_0
ON DEF_JOB		
(		
	TABLE_ID ASC,	
	JOB_ID ASC,	
	VERSION_SERIAL ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_0 		
ON DEF_JOB		
(		
	MEMNAME ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_1 		
ON DEF_JOB		
(		
	JOB_NAME ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_2 		
ON DEF_JOB		
(		
	APPLICATION ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_3 		
ON DEF_JOB		
(		
	GROUP_NAME ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_4 		
ON DEF_JOB		
(		
	TASK_TYPE ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_5 		
ON DEF_JOB		
(		
	VERSION_TIMESTAMP ASC	
)		
TABLESPACE NEMUSER;		
		
CREATE INDEX DEF_JOB_6 		
ON DEF_JOB		
(		
	JOB_ORDER ASC	
)		
TABLESPACE NEMUSER;		*/
