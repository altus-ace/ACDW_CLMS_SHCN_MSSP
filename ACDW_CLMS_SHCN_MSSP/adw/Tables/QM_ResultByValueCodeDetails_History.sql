﻿CREATE TABLE [adw].[QM_ResultByValueCodeDetails_History] (
    [QMValueCodeKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]               INT           NOT NULL,
    [ClientMemberKey]         VARCHAR (20)  NOT NULL,
    [ValueCodeSystem]         VARCHAR (20)  NULL,
    [ValueCode]               VARCHAR (20)  NULL,
    [ValueCodePrimarySvcDate] DATE          NULL,
    [QmMsrID]                 VARCHAR (20)  NULL,
    [QmCntCat]                VARCHAR (20)  NULL,
    [QMDate]                  DATE          NOT NULL,
    [RunDate]                 DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               VARCHAR (50)  DEFAULT (suser_name()) NOT NULL,
    [LastUpdatedDate]         DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]           VARCHAR (50)  DEFAULT (suser_name()) NOT NULL,
    [SEQ_CLAIM_ID]            VARCHAR (50)  DEFAULT ('') NULL,
    [SVC_TO_DATE]             DATE          DEFAULT ('') NULL,
    [SVC_PROV_NPI]            VARCHAR (50)  NULL,
    [srcFileName]             VARCHAR (150) CONSTRAINT [df_updatSrc] DEFAULT ('QMCalc') NOT NULL,
    [AdiKey]                  INT           CONSTRAINT [df_updatAdikey] DEFAULT ((0)) NOT NULL,
    [adiTableName]            VARCHAR (150) CONSTRAINT [df_updatAditab] DEFAULT ('QMCalc') NOT NULL,
    PRIMARY KEY CLUSTERED ([QMValueCodeKey] ASC)
);

