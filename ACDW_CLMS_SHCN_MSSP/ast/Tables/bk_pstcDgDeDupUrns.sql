CREATE TABLE [ast].[bk_pstcDgDeDupUrns] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) NOT NULL,
    [CreatedBy]   VARCHAR (20)  NOT NULL,
    [LoadDate]    DATE          NOT NULL,
    CONSTRAINT [PK_bk_pstcDgDeDupUrns_UrnLoadDate] PRIMARY KEY CLUSTERED ([urn] ASC, [LoadDate] ASC)
);

