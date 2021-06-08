﻿CREATE TABLE [lst].[lstScoringSystem] (
    [lstScoringSystemKey] INT            IDENTITY (1, 1) NOT NULL,
    [ClientKey]           INT            NOT NULL,
    [LOB]                 VARCHAR (20)   NOT NULL,
    [LOB_State]           VARCHAR (10)   NULL,
    [EffectiveDate]       DATE           NULL,
    [ExpirationDate]      DATE           NULL,
    [Active]              TINYINT        DEFAULT ((1)) NOT NULL,
    [ScoringType]         VARCHAR (10)   NULL,
    [P4qIndicator]        CHAR (1)       NOT NULL,
    [MeasureID]           VARCHAR (20)   NOT NULL,
    [MeasureDesc]         VARCHAR (80)   NOT NULL,
    [Score_A]             NUMERIC (9, 3) DEFAULT ((0)) NULL,
    [Score_B]             NUMERIC (9, 3) DEFAULT ((0)) NULL,
    [Score_C]             NUMERIC (9, 3) DEFAULT ((0)) NULL,
    [Score_D]             NUMERIC (9, 3) DEFAULT ((0)) NULL,
    [Score_E]             NUMERIC (9, 3) DEFAULT ((0)) NULL,
    [Weight_1]            INT            DEFAULT ((1)) NULL,
    [Weight_2]            INT            DEFAULT ((1)) NULL,
    [Weight_3]            INT            DEFAULT ((1)) NULL,
    [Weight_4]            INT            DEFAULT ((1)) NULL,
    [Weight_5]            INT            DEFAULT ((1)) NULL,
    [AceQmWeight]         INT            DEFAULT ((1)) NULL,
    [AceCmWeight]         INT            DEFAULT ((1)) NULL,
    [Pq4BaseValue]        MONEY          DEFAULT ((0)) NULL,
    [CreatedDate]         DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]         VARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([lstScoringSystemKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_lstScoringSystem_MsrIDCreateDateClientKey]
    ON [lst].[lstScoringSystem]([MeasureID] ASC, [CreatedDate] DESC, [ClientKey] ASC)
    INCLUDE([EffectiveDate], [ExpirationDate], [Score_A]);


GO
CREATE STATISTICS [ndx_lstScoringSystem_ClientKeyMsrID]
    ON [lst].[lstScoringSystem]([ClientKey], [MeasureID]);

