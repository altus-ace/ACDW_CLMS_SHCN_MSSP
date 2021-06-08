CREATE TABLE [lst].[z_ListTables] (
    [urn]         INT          IDENTITY (1, 1) NOT NULL,
    [TABLE_NAME]  VARCHAR (75) NULL,
    [COLUMN_NAME] VARCHAR (50) NULL,
    [MaxExpDate]  DATE         NULL,
    [CreatedDate] DATE         DEFAULT (getdate()) NULL,
    [CreatedBy]   VARCHAR (50) DEFAULT (suser_sname()) NULL
);

