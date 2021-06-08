CREATE TABLE [dbo].[AceMpi_UpdateMstrMrnLog] (
    [Target]          VARCHAR (10) NULL,
    [ClientKey]       INT          NULL,
    [CMK]             VARCHAR (50) NULL,
    [MpiSplitKey]     INT          NULL,
    [RowStatus]       TINYINT      NULL,
    [NewMrn]          NUMERIC (15) NULL,
    [OldMrn]          NUMERIC (15) NULL,
    [OriginTableName] VARCHAR (50) NULL,
    [OriginPKey]      INT          NULL
);

