CREATE TABLE [adw].[Claims_Diags] (
    [URN]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]       VARCHAR (50)  NULL,
    [SUBSCRIBER_ID]      VARCHAR (50)  NULL,
    [ICD_FLAG]           CHAR (2)      NULL,
    [diagNumber]         SMALLINT      NULL,
    [diagCode]           VARCHAR (20)  NULL,
    [diagCodeWithoutDot] VARCHAR (20)  NULL,
    [diagPoa]            VARCHAR (20)  NULL,
    [LoadDate]           DATETIME      NOT NULL,
    [SrcAdiTableName]    VARCHAR (100) NULL,
    [SrcAdiKey]          INT           NOT NULL,
    [CreatedDate]        DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Diags] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NdxClmDgs_Seq_Claim_ID]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_ClmDiag_DiagNum]
    ON [adw].[Claims_Diags]([diagNumber] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [diagCode], [diagCodeWithoutDot]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDiags_diagCode]
    ON [adw].[Claims_Diags]([diagCode] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmDiag_UniqIDSubIDDiagNumDiagCdDiagPOA]
    ON [adw].[Claims_Diags]([ICD_FLAG] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [diagNumber], [diagCode], [diagPoa]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmDgs_ClmID]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID] ASC)
    INCLUDE([SUBSCRIBER_ID], [diagCode]);


GO
CREATE NONCLUSTERED INDEX [ndx_ClaimsDiags_DigaCodeWithOutDot]
    ON [adw].[Claims_Diags]([diagCodeWithoutDot] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [NdxCD_DiagNum]
    ON [adw].[Claims_Diags]([diagNumber] ASC);


GO

CREATE TRIGGER adw.ClaimsDiags_AfterUpdate
ON adw.Claims_Diags
AFTER UPDATE 
AS
   UPDATE adw.Claims_Diags
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Diags.URN = i.URN;
