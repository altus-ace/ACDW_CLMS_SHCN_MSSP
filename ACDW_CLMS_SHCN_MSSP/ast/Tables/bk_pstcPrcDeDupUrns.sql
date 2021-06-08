CREATE TABLE [ast].[bk_pstcPrcDeDupUrns] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) NOT NULL,
    [CreatedBy]   VARCHAR (20)  NOT NULL,
    [LoadDate]    DATE          NOT NULL,
    CONSTRAINT [PK_bk_pstcPrcDeDupUrns_UrnLoadDate] PRIMARY KEY CLUSTERED ([urn] ASC, [LoadDate] ASC)
);

