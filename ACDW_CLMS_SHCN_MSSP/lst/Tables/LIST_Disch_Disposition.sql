CREATE TABLE [lst].[LIST_Disch_Disposition] (
    [CreatedDate]            DATETIME       NOT NULL,
    [CreatedBy]              VARCHAR (50)   NOT NULL,
    [LastUpdated]            DATETIME       NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)   NOT NULL,
    [SrcFileName]            VARCHAR (50)   NULL,
    [lstDischDispositionKey] INT            IDENTITY (1, 1) NOT NULL,
    [DataDate]               DATE           NOT NULL,
    [Disch_Disp_Code]        VARCHAR (10)   NULL,
    [Disch_Disp_CodeValue]   VARCHAR (100)  NULL,
    [Disch_Disp_Description] VARCHAR (1000) NULL,
    [Version]                VARCHAR (50)   NULL,
    [ACTIVE]                 CHAR (1)       NULL,
    [EffectiveDate]          DATE           NULL,
    [ExpirationDate]         DATE           NULL,
    [Disch_Disp_CodePadded]  VARCHAR (10)   NULL
);

