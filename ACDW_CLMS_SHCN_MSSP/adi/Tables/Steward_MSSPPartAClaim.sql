CREATE TABLE [adi].[Steward_MSSPPartAClaim] (
    [MSSPPartAClaimKey]                      INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                            VARCHAR (100) NULL,
    [CreateDate]                             DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                               VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                       VARCHAR (100) NULL,
    [LastUpdatedBy]                          VARCHAR (100) NULL,
    [LastUpdatedDate]                        DATETIME      NULL,
    [DataDate]                               DATE          NULL,
    [ClaimID]                                VARCHAR (20)  NULL,
    [CMSCertificationNBR]                    VARCHAR (20)  NULL,
    [MedicareBeneficiaryID]                  VARCHAR (20)  NULL,
    [HealthInsuranceClaimNBR]                VARCHAR (20)  NULL,
    [ClaimTypeCD]                            VARCHAR (20)  NULL,
    [ClaimTypeDSC]                           VARCHAR (500) NULL,
    [ClaimStartDTS]                          DATE          NULL,
    [ClaimEndDTS]                            DATE          NULL,
    [BillFacilityTypeCD]                     VARCHAR (20)  NULL,
    [BillFacilityTypeDSC]                    VARCHAR (500) NULL,
    [BillClassificationCD]                   VARCHAR (20)  NULL,
    [BillClassificationDSC]                  VARCHAR (500) NULL,
    [PrincipalICDDiagnosisCD]                VARCHAR (20)  NULL,
    [AdmitICDDiagnosisCD]                    VARCHAR (20)  NULL,
    [PaymentDenialReasonCD]                  VARCHAR (20)  NULL,
    [PaymentDenialReasonDSC]                 VARCHAR (500) NULL,
    [PaymentAMT]                             MONEY         NULL,
    [PrimaryPayerCD]                         VARCHAR (20)  NULL,
    [PrimaryPayerDSC]                        VARCHAR (500) NULL,
    [FacilityFIPSStateCD]                    VARCHAR (20)  NULL,
    [DischargeStatusCD]                      VARCHAR (20)  NULL,
    [DischargeStatusDSC]                     VARCHAR (500) NULL,
    [MSDRG]                                  VARCHAR (10)  NULL,
    [OutpatientServiceTypeCD]                VARCHAR (20)  NULL,
    [OutpatientServiceTypeDSC]               VARCHAR (500) NULL,
    [FacilityNPI]                            VARCHAR (20)  NULL,
    [OperatingProviderNPI]                   VARCHAR (20)  NULL,
    [AttendingProviderNPI]                   VARCHAR (20)  NULL,
    [OtherProviderNPI]                       VARCHAR (20)  NULL,
    [AdjustmentTypeCD]                       VARCHAR (20)  NULL,
    [AdjustmentTypeDSC]                      VARCHAR (500) NULL,
    [ProcessingDTS]                          DATE          NULL,
    [RepositoryLoadDTS]                      DATE          NULL,
    [UmbrellaHealthInsuranceClaimNBR]        VARCHAR (20)  NULL,
    [AdmitTypeCD]                            VARCHAR (20)  NULL,
    [AdmitTypeDSC]                           VARCHAR (500) NULL,
    [AdmitSourceCD]                          VARCHAR (20)  NULL,
    [AdmitSourceDSC]                         VARCHAR (500) NULL,
    [BillFrequencyCD]                        VARCHAR (20)  NULL,
    [BillFrequencyDSC]                       VARCHAR (500) NULL,
    [PaymentQueryCD]                         VARCHAR (20)  NULL,
    [PaymentQueryDSC]                        VARCHAR (20)  NULL,
    [ICDRevisionCD]                          VARCHAR (20)  NULL,
    [PopulationBasedPaymentInclusionAMT]     MONEY         NULL,
    [PopulationBasedPaymentReductionAMT]     MONEY         NULL,
    [TotalChargeAMT]                         MONEY         NULL,
    [CapitalIndirectMedicalEducationAMT]     MONEY         NULL,
    [OperationalIndirectMedicalEducationAMT] MONEY         NULL,
    [CapitalDisproportionateAMT]             MONEY         NULL,
    [HIPPSUncompensatedAMT]                  MONEY         NULL,
    [OperationalDisproportionateAMT]         MONEY         NULL,
    [FileNM]                                 VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([MSSPPartAClaimKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPPartAClaim_17_635149308__K10]
    ON [adi].[Steward_MSSPPartAClaim]([CMSCertificationNBR] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPPartAClaim_17_635149308__K10_K13]
    ON [adi].[Steward_MSSPPartAClaim]([CMSCertificationNBR] ASC, [ClaimTypeCD] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPPartAClaim_17_635149308__K13_1_2_3_4_5_6_7_8_9_10_11_12_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_]
    ON [adi].[Steward_MSSPPartAClaim]([ClaimTypeCD] ASC)
    INCLUDE([MSSPPartAClaimKey], [SrcFileName], [CreateDate], [CreateBy], [OriginalFileName], [LastUpdatedBy], [LastUpdatedDate], [DataDate], [ClaimID], [CMSCertificationNBR], [MedicareBeneficiaryID], [HealthInsuranceClaimNBR], [ClaimTypeDSC], [ClaimStartDTS], [ClaimEndDTS], [BillFacilityTypeCD], [BillFacilityTypeDSC], [BillClassificationCD], [BillClassificationDSC], [PrincipalICDDiagnosisCD], [AdmitICDDiagnosisCD], [PaymentDenialReasonCD], [PaymentDenialReasonDSC], [PaymentAMT], [PrimaryPayerCD], [PrimaryPayerDSC], [FacilityFIPSStateCD], [DischargeStatusCD], [DischargeStatusDSC], [MSDRG], [OutpatientServiceTypeCD], [OutpatientServiceTypeDSC], [FacilityNPI], [OperatingProviderNPI], [AttendingProviderNPI], [OtherProviderNPI], [AdjustmentTypeCD], [AdjustmentTypeDSC], [ProcessingDTS], [RepositoryLoadDTS], [UmbrellaHealthInsuranceClaimNBR], [AdmitTypeCD], [AdmitTypeDSC], [AdmitSourceCD], [AdmitSourceDSC], [BillFrequencyCD], [BillFrequencyDSC], [PaymentQueryCD], [PaymentQueryDSC], [ICDRevisionCD], [PopulationBasedPaymentInclusionAMT], [PopulationBasedPaymentReductionAMT], [TotalChargeAMT], [CapitalIndirectMedicalEducationAMT], [OperationalIndirectMedicalEducationAMT], [CapitalDisproportionateAMT], [HIPPSUncompensatedAMT], [OperationalDisproportionateAMT], [FileNM]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Steward_MSSPPartAClaim_17_635149308__K10_K11_K15_K16_K1_K13_K40_K38]
    ON [adi].[Steward_MSSPPartAClaim]([CMSCertificationNBR] ASC, [MedicareBeneficiaryID] ASC, [ClaimStartDTS] ASC, [ClaimEndDTS] ASC, [MSSPPartAClaimKey] ASC, [ClaimTypeCD] ASC, [ProcessingDTS] ASC, [AdjustmentTypeCD] ASC);


GO
CREATE STATISTICS [_dta_stat_635149308_1_10_11_15]
    ON [adi].[Steward_MSSPPartAClaim]([MSSPPartAClaimKey], [CMSCertificationNBR], [MedicareBeneficiaryID], [ClaimStartDTS]);


GO
CREATE STATISTICS [_dta_stat_635149308_13_40_38]
    ON [adi].[Steward_MSSPPartAClaim]([ClaimTypeCD], [ProcessingDTS], [AdjustmentTypeCD]);

