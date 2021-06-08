CREATE TABLE [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader] (
    [clmSKey]     VARCHAR (50)  NOT NULL,
    [clmHdrURN]   INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) NOT NULL,
    [CreatedBy]   VARCHAR (20)  NOT NULL,
    [LoadDate]    DATE          NOT NULL,
    CONSTRAINT [PK_bk_ClaimHeader_03_LatestEffectiveClaimsHeader_ClmsHdrUrnLoadDate] PRIMARY KEY CLUSTERED ([clmHdrURN] ASC, [LoadDate] ASC)
);

