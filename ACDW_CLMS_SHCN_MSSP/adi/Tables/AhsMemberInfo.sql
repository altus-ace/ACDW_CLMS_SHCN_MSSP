CREATE TABLE [adi].[AhsMemberInfo] (
    [AhsMemberInfoKey]          INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]               VARCHAR (100) NOT NULL,
    [CreateDate]                DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]                  VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [DataDate]                  DATE          NOT NULL,
    [CLientMemberKey]           VARCHAR (50)  NULL,
    [PcpPreferredNPI]           VARCHAR (10)  NULL,
    [PcpPreferredTIN]           VARCHAR (9)   NULL,
    [PcpPreferredEffectiveDate] DATE          NULL,
    PRIMARY KEY CLUSTERED ([AhsMemberInfoKey] ASC)
);


GO
CREATE TRIGGER adi.[AU_AhsMemberInfo]
ON adi.AhsMemberInfo
AFTER UPDATE 
AS
   UPDATE adi.AhsMemberInfo
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adi.AhsMemberInfo.[AhsMemberInfoKey] = i.AhsMemberInfoKey
   ;


