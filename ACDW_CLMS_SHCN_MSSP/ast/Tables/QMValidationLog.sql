CREATE TABLE [ast].[QMValidationLog] (
    [CreatedDate]         DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]           VARCHAR (20)  DEFAULT (suser_name()) NULL,
    [AceValidationLogKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberkey]     VARCHAR (50)  NULL,
    [JobName]             VARCHAR (100) NULL,
    [ValidationType]      VARCHAR (100) NULL,
    [Details]             VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([AceValidationLogKey] ASC)
);

