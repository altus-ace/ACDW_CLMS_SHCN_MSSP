CREATE TABLE [lst].[zz_LIST_ICD10CM] (
    [CreatedDate]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdated]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]        VARCHAR (50)  NULL,
    [lstICD10CMKey]      INT           IDENTITY (1, 1) NOT NULL,
    [VALUE_SET_NAME]     VARCHAR (100) NULL,
    [VALUE_SET_OID]      VARCHAR (100) NULL,
    [VALUE_SET_VER]      VARCHAR (50)  NULL,
    [VALUE_CODE]         VARCHAR (50)  NULL,
    [VALUE_CODE_NAME]    VARCHAR (MAX) NULL,
    [VALUE_CODE_SYSTEM]  VARCHAR (50)  NULL,
    [CODE_SYSTEM_OID]    VARCHAR (50)  NULL,
    [CODE_SYSTEM_VER]    VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (20)  NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   NULL,
    [ACTIVE]             CHAR (1)      DEFAULT ('Y') NULL,
    [EffectiveDate]      DATE          DEFAULT (getdate()) NULL,
    [ExpirationDate]     DATE          DEFAULT ('2099-12-31') NULL,
    PRIMARY KEY CLUSTERED ([lstICD10CMKey] ASC)
);

