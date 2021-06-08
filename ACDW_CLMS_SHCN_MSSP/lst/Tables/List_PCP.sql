﻿CREATE TABLE [lst].[List_PCP] (
    [CreatedDate]           DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdated]           DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]           VARCHAR (50)  NULL,
    [lstPCPKey]             INT           IDENTITY (1, 1) NOT NULL,
    [CLIENT_ID]             VARCHAR (50)  NULL,
    [PCP_NPI]               VARCHAR (50)  NULL,
    [PCP_FIRST_NAME]        VARCHAR (50)  NULL,
    [PCP_MI]                VARCHAR (50)  NULL,
    [PCP_LAST_NAME]         VARCHAR (50)  NULL,
    [PCP__ADDRESS]          VARCHAR (50)  NULL,
    [PCP__ADDRESS2]         VARCHAR (50)  NULL,
    [PCP_CITY]              VARCHAR (50)  NULL,
    [PCP_STATE]             VARCHAR (50)  NULL,
    [PCP_ZIP]               VARCHAR (50)  NULL,
    [PCP_PHONE]             VARCHAR (50)  NULL,
    [PCP_CLIENT_ID]         VARCHAR (50)  NULL,
    [PCP_PRACTICE_TIN]      VARCHAR (50)  NULL,
    [PCP_PRACTICE_TIN_NAME] VARCHAR (100) NULL,
    [PRIM_SPECIALTY]        VARCHAR (100) NULL,
    [PROV_TYPE]             VARCHAR (20)  NULL,
    [PCP_FLAG]              VARCHAR (1)   NULL,
    [CAMPAIGN_RUN_ID]       INT           NULL,
    [T_Modify_by]           VARCHAR (50)  NULL,
    [ACTIVE]                CHAR (1)      DEFAULT ('Y') NULL,
    [EffectiveDate]         DATE          DEFAULT (getdate()) NULL,
    [ExpirationDate]        DATE          DEFAULT ('2099-12-31') NULL,
    [PCP_POD]               VARCHAR (50)  NULL,
    [AccountType]           VARCHAR (50)  NULL,
    [County]                VARCHAR (50)  NULL,
    [Sub_Speciality]        VARCHAR (50)  NULL,
    [TinHPEffectiveDate]    DATE          NULL,
    [TinHPExpirationDate]   DATE          NULL,
    PRIMARY KEY CLUSTERED ([lstPCPKey] ASC)
);


GO
CREATE STATISTICS [_dta_stat_48719226_29_8]
    ON [lst].[List_PCP]([PCP_POD], [PCP_NPI]);

