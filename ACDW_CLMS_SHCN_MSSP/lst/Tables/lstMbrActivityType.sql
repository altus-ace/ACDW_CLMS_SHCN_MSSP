CREATE TABLE [lst].[lstMbrActivityType] (
    [lstMbrActivityTypeKey] INT           IDENTITY (1, 1) NOT NULL,
    [MbrActivityTypeName]   VARCHAR (50)  NOT NULL,
    [MbrActivityTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]              DATE          NOT NULL,
    [DataDate]              DATE          NOT NULL,
    [CreatedDate]           DATETIME2 (7) CONSTRAINT [DF_LstMbrActivityType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [DF_LstMbrActivityType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATETIME2 (7) CONSTRAINT [DF_LstMbrActivityType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [DF_LstMbrActivityType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstMbrActivityTypeKey] ASC)
);

