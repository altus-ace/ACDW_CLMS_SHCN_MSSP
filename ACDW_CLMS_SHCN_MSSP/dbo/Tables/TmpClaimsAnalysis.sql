CREATE TABLE [dbo].[TmpClaimsAnalysis] (
    [MSSPPartAClaimKey]     INT           NOT NULL,
    [ClaimStartDTS]         DATE          NULL,
    [ProcessingDTS]         DATE          NULL,
    [MedicareBeneficiaryID] VARCHAR (20)  NULL,
    [SrcAdiKey]             INT           NOT NULL,
    [clmSKey]               VARCHAR (50)  NOT NULL,
    [clmHdrURN]             INT           NULL,
    [AdjustmentTypeCD]      VARCHAR (20)  NULL,
    [AdjustmentTypeDSC]     VARCHAR (500) NULL,
    [PaymentQueryCD]        VARCHAR (20)  NULL,
    [PaymentQueryDSC]       VARCHAR (20)  NULL,
    [BillFrequencyCD]       VARCHAR (20)  NULL,
    [BillFrequencyDSC]      VARCHAR (500) NULL
);

