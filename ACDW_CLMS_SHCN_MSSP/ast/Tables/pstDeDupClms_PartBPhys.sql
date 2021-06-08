﻿CREATE TABLE [ast].[pstDeDupClms_PartBPhys] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astpstcDeDupClms_Cclf5_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astpstcDeDupClms_Cclf5_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_PstDeDupClms_PartBPhys_AdiKey]
    ON [ast].[pstDeDupClms_PartBPhys]([urn] ASC);

