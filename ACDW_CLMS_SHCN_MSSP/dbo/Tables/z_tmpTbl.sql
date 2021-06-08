CREATE TABLE [dbo].[z_tmpTbl] (
    [urn]        INT          IDENTITY (1, 1) NOT NULL,
    [tblName]    VARCHAR (50) NULL,
    [DataDate]   DATE         NULL,
    [CntRecords] INT          DEFAULT ((0)) NULL
);

