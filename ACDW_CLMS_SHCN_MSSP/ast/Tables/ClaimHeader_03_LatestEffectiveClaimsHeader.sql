CREATE TABLE [ast].[ClaimHeader_03_LatestEffectiveClaimsHeader] (
    [clmSKey]            VARCHAR (50)  NOT NULL,
    [LatestClaimAdiKey]  INT           NOT NULL,
    [LatestClaimID]      VARCHAR (50)  NOT NULL,
    [ReplacesAdiKey]     INT           NOT NULL,
    [ReplacesClaimID]    VARCHAR (50)  NOT NULL,
    [ProcessDate]        DATE          NOT NULL,
    [ClaimAdjCode]       SMALLINT      NOT NULL,
    [LatestClaimRankNum] SMALLINT      NOT NULL,
    [CreatedDate]        DATETIME2 (7) CONSTRAINT [df_astCLaimHeader03LatestEffClaim_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (20)  CONSTRAINT [df_astCLaimHeader03LatestEffClaim_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([clmSKey] ASC, [ReplacesAdiKey] ASC)
);

