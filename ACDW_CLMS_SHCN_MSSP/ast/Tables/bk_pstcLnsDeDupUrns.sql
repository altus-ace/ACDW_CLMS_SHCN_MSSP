CREATE TABLE [ast].[bk_pstcLnsDeDupUrns] (
    [URN]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) NOT NULL,
    [CreatedBy]   VARCHAR (20)  NOT NULL,
    [LoadDate]    DATE          NOT NULL,
    CONSTRAINT [PK_bk_pstcLnsDeDupUrns_UrnLoadDate] PRIMARY KEY CLUSTERED ([URN] ASC, [LoadDate] ASC)
);

