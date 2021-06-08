CREATE TABLE [adw].[MbrClientMemberKeyHistory] (
    [MbrCmkHistoryKey]        INT           IDENTITY (1, 1) NOT NULL,
    [NewCmkAdiKey]            INT           NULL,
    [NewCmkAdiTableName]      VARCHAR (100) NULL,
    [IsCurrent]               TINYINT       CONSTRAINT [DF_MbrCmkHistory_IsCurrent] DEFAULT ((1)) NOT NULL,
    [CurrentClientMemberKey]  VARCHAR (50)  NOT NULL,
    [PreviousClientMemberKey] VARCHAR (50)  NOT NULL,
    [PreviousEffectiveDate]   DATE          NOT NULL,
    [PreviousExpirationDate]  DATE          CONSTRAINT [DF_MbrCmkHistory_ExpDate] DEFAULT ('12/31/9999') NOT NULL,
    [LoadDate]                DATE          NOT NULL,
    [DataDate]                DATE          NOT NULL,
    [SrcFileName]             VARCHAR (100) CONSTRAINT [DF_MbrCmkHistory_SrcFileName] DEFAULT ('No File Name') NULL,
    [CreatedDate]             DATETIME2 (7) CONSTRAINT [DF_MbrCmkHistory_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               VARCHAR (50)  CONSTRAINT [DF_MbrCmkHistory_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]         DATETIME2 (7) CONSTRAINT [DF_MbrCmkHistory_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]           VARCHAR (50)  CONSTRAINT [DF_MbrCmkHistory_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([MbrCmkHistoryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrCmkHistory_CurCmkPrevCmk]
    ON [adw].[MbrClientMemberKeyHistory]([CurrentClientMemberKey] ASC, [PreviousClientMemberKey] ASC);


GO


CREATE TRIGGER adw.[AU_MbrClientMemberKeyHistory]
ON adw.[MbrClientMemberKeyHistory]
AFTER UPDATE 
AS
   UPDATE adw.[MbrClientMemberKeyHistory]
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.[MbrClientMemberKeyHistory].mbrCmkHistoryKey = i.mbrCmkHistoryKey
   ;
