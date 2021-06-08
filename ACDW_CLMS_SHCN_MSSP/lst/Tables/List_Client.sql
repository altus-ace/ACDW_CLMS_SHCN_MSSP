CREATE TABLE [lst].[List_Client] (
    [ClientKey]                       INT           IDENTITY (1, 1) NOT NULL,
    [ClientName]                      VARCHAR (100) NOT NULL,
    [ClientShortName]                 VARCHAR (15)  NOT NULL,
    [CS_Export_LobName]               VARCHAR (20)  CONSTRAINT [DF_LstList_CLIENT_CS_LOB_NAME] DEFAULT ('CS_LOB') NOT NULL,
    [IpDischargeFollupIntervalInDays] TINYINT       CONSTRAINT [DF_LstList_Client_IpDFollowInteraval] DEFAULT ((0)) NOT NULL,
    [ErDischargeFollupIntervalInDays] TINYINT       CONSTRAINT [DF_LstList_Client_ErDFollowInteraval] DEFAULT ((0)) NOT NULL,
    [CreatedDate]                     DATETIME2 (7) CONSTRAINT [DF_LstList_Client_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                       VARCHAR (50)  CONSTRAINT [DF_LstList_Client_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                 DATETIME2 (7) CONSTRAINT [DF_LstList_Client_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                   VARCHAR (50)  CONSTRAINT [DF_LstList_Client_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ClientKey] ASC)
);

