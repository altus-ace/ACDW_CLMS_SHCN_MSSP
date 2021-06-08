CREATE TABLE [ast].[bk_pstDeDupClms_PartDPharma] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) NOT NULL,
    [CreatedBy]   VARCHAR (20)  NOT NULL,
    [LoadDate]    DATE          NOT NULL,
    CONSTRAINT [PK_bk_pstDeDupClms_PartDPharma_UrnLoadDate] PRIMARY KEY CLUSTERED ([urn] ASC, [LoadDate] ASC)
);

