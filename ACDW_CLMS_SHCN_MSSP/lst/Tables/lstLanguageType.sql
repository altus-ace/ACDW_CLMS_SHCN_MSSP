CREATE TABLE [lst].[lstLanguageType] (
    [lstLanguageTypeKey] INT           IDENTITY (1, 1) NOT NULL,
    [LanguageTypeName]   VARCHAR (50)  NOT NULL,
    [LanguageTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]           DATE          NOT NULL,
    [DataDate]           DATE          NOT NULL,
    [CreatedDate]        DATETIME2 (7) CONSTRAINT [DF_LstLanguageType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_LstLanguageType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME2 (7) CONSTRAINT [DF_LstLanguageType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_LstLanguageType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstLanguageTypeKey] ASC)
);

