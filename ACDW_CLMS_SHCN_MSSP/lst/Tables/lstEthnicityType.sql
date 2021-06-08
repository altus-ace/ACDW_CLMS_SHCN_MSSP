CREATE TABLE [lst].[lstEthnicityType] (
    [lstEthnicityTypeKey] INT           IDENTITY (1, 1) NOT NULL,
    [EthnicityTypeName]   VARCHAR (50)  NOT NULL,
    [EthnicityTypeCode]   VARCHAR (10)  NOT NULL,
    [LoadDate]            DATE          NOT NULL,
    [DataDate]            DATE          NOT NULL,
    [CreatedDate]         DATETIME2 (7) CONSTRAINT [DF_LstEthnicityType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_LstEthnicityType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstEthnicityType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)  CONSTRAINT [DF_LstEthnicityType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]         VARCHAR (100) NOT NULL,
    CONSTRAINT [PK__lstEthni__A2C05402AB8540E0] PRIMARY KEY CLUSTERED ([lstEthnicityTypeKey] ASC)
);

