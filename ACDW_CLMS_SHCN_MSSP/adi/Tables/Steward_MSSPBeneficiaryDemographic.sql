CREATE TABLE [adi].[Steward_MSSPBeneficiaryDemographic] (
    [MSSPBeneficiaryDemographicKey]              INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                                VARCHAR (100) NULL,
    [CreateDate]                                 DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                                   VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                           VARCHAR (100) NULL,
    [LastUpdatedBy]                              VARCHAR (100) NULL,
    [LastUpdatedDate]                            DATETIME      NULL,
    [DataDate]                                   DATE          NULL,
    [MedicareBeneficiaryID]                      VARCHAR (50)  NULL,
    [HealthInsuranceClaimNBR]                    VARCHAR (50)  NULL,
    [FIPSStateCD]                                VARCHAR (10)  NULL,
    [FIPSCountyCD]                               VARCHAR (10)  NULL,
    [ZipCD]                                      VARCHAR (15)  NULL,
    [BirthDTS]                                   DATE          NULL,
    [SexCD]                                      VARCHAR (10)  NULL,
    [RaceCD]                                     VARCHAR (10)  NULL,
    [AgeNBR]                                     SMALLINT      NULL,
    [BeneficiaryMedicareStatusCD]                VARCHAR (10)  NULL,
    [BeneficiaryDualStatusCD]                    VARCHAR (10)  NULL,
    [DeathDTS]                                   DATE          NULL,
    [HospiceStartDTS]                            DATE          NULL,
    [HospiceEndDTS]                              DATE          NULL,
    [FirstNM]                                    VARCHAR (50)  NULL,
    [MiddleNM]                                   VARCHAR (50)  NULL,
    [LastNM]                                     VARCHAR (50)  NULL,
    [BeneficiaryOriginalEntitlementReasonCD]     VARCHAR (10)  NULL,
    [BeneficiaryEntitlementBuyInCD]              VARCHAR (50)  NULL,
    [MedicarePartABeneficiaryEnrollmentBeginDTS] DATE          NULL,
    [MedicarePartBBeneficiaryEnrollmentBeginDTS] DATE          NULL,
    [MailingAddress01TXT]                        VARCHAR (50)  NULL,
    [MailingAddress02TXT]                        VARCHAR (50)  NULL,
    [MailingAddress03TXT]                        VARCHAR (50)  NULL,
    [MailingAddress04TXT]                        VARCHAR (50)  NULL,
    [MailingAddress05TXT]                        VARCHAR (50)  NULL,
    [MailingAddress06TXT]                        VARCHAR (50)  NULL,
    [CityNM]                                     VARCHAR (50)  NULL,
    [StateCD]                                    VARCHAR (50)  NULL,
    [PostalZipCD]                                VARCHAR (12)  NULL,
    [ZipExtensionCD]                             VARCHAR (10)  NULL,
    [FileNM]                                     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([MSSPBeneficiaryDemographicKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPBeneficiaryDemograph_17_603149194__K28_K9_K8]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicarePartABeneficiaryEnrollmentBeginDTS] ASC, [MedicareBeneficiaryID] ASC, [DataDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPBeneficiaryDemograph_17_603149194__K29_K9_K8]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicarePartBBeneficiaryEnrollmentBeginDTS] ASC, [MedicareBeneficiaryID] ASC, [DataDate] ASC);


GO
CREATE STATISTICS [_dta_stat_603149194_29_28]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicarePartBBeneficiaryEnrollmentBeginDTS], [MedicarePartABeneficiaryEnrollmentBeginDTS]);


GO
CREATE STATISTICS [_dta_stat_603149194_9_28_29_8]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicareBeneficiaryID], [MedicarePartABeneficiaryEnrollmentBeginDTS], [MedicarePartBBeneficiaryEnrollmentBeginDTS], [DataDate]);


GO
CREATE STATISTICS [_dta_stat_603149194_9_29_8]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicareBeneficiaryID], [MedicarePartBBeneficiaryEnrollmentBeginDTS], [DataDate]);


GO
CREATE STATISTICS [_dta_stat_603149194_9_8_28]
    ON [adi].[Steward_MSSPBeneficiaryDemographic]([MedicareBeneficiaryID], [DataDate], [MedicarePartABeneficiaryEnrollmentBeginDTS]);

