CREATE TABLE [adi].[Steward_MSSPBeneficiaryCrossReference] (
    [MSSPBeneficiaryCrossReferenceKey]           INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                                VARCHAR (100) NULL,
    [CreateDate]                                 DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                                   VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                           VARCHAR (100) NULL,
    [LastUpdatedBy]                              VARCHAR (100) NULL,
    [LastUpdatedDate]                            DATETIME      NULL,
    [DataDate]                                   DATE          NULL,
    [IdentifierTypeCD]                           VARCHAR (10)  NULL,
    [CurrentHealthInsuranceClaimNBR]             VARCHAR (50)  NULL,
    [PreviousHealthInsuranceClaimNBR]            VARCHAR (50)  NULL,
    [PreviousHealthInsuranceClaimNumberStartDTS] DATE          NULL,
    [PreviousHealthInsuranceClaimNumberEndDTS]   DATE          NULL,
    [RailroadBoardNBR]                           VARCHAR (50)  NULL,
    [FileNM]                                     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([MSSPBeneficiaryCrossReferenceKey] ASC)
);

