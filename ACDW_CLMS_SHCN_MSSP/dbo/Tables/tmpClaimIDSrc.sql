CREATE TABLE [dbo].[tmpClaimIDSrc] (
    [id]       INT          IDENTITY (1, 1) NOT NULL,
    [claimsID] VARCHAR (20) NOT NULL,
    [src]      CHAR (2)     NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

