CREATE TABLE [lst].[NtfConfigClient] (
    [NtfConfigClientKey]    INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]           VARCHAR (100) NULL,
    [CreatedDate]           DATE          CONSTRAINT [DF_NtfConfigClient_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [DF_NtfConfigClient_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATE          CONSTRAINT [DF_NtfConfigClient_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [DF_NtfConfigClient_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]             INT           NOT NULL,
    [NtfType]               VARCHAR (10)  NOT NULL,
    [NtfFollupDays]         INT           NOT NULL,
    [NtfFollupUpAnchorDate] VARCHAR (10)  NOT NULL,
    PRIMARY KEY CLUSTERED ([NtfConfigClientKey] ASC),
    CONSTRAINT [CK_NtfConfigClient_NtfFollowUpAnchorDate] CHECK ([NtfFollupUpAnchorDate]='discharged' OR [NtfFollupUpAnchorDate]='received')
);


GO

CREATE TRIGGER lst.[AU_NtfConfigClient]
ON lst.[NtfConfigClient]
AFTER UPDATE 
AS
   UPDATE lst.[NtfConfigClient]
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE lst.[NtfConfigClient].NtfConfigClientKey = i.NtfConfigClientKey
   ;
