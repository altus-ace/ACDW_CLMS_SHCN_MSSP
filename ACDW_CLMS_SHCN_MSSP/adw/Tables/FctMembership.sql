CREATE TABLE [adw].[FctMembership] (
    [FctMembershipSkey]                     INT             IDENTITY (1, 1) NOT NULL,
    [CreatedDate]                           DATETIME        DEFAULT (getdate()) NULL,
    [CreatedBy]                             VARCHAR (20)    DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]                       DATETIME        DEFAULT (getdate()) NULL,
    [LastUpdatedBy]                         VARCHAR (20)    DEFAULT (suser_sname()) NULL,
    [AdiKey]                                INT             NULL,
    [SrcFileName]                           VARCHAR (100)   NULL,
    [AdiTableName]                          VARCHAR (100)   NULL,
    [LoadDate]                              DATE            NULL,
    [DataDate]                              DATE            NULL,
    [RwEffectiveDate]                       DATE            NULL,
    [RwExpirationDate]                      DATE            NULL,
    [ClientKey]                             INT             NULL,
    [Ace_ID]                                NUMERIC (15)    NULL,
    [ClientMemberKey]                       VARCHAR (50)    NULL,
    [MBI]                                   VARCHAR (50)    NULL,
    [HICN]                                  VARCHAR (50)    NULL,
    [SubscriberIndicator]                   CHAR (1)        DEFAULT ('') NULL,
    [MemberIndicator]                       CHAR (1)        DEFAULT ('') NULL,
    [Relationship]                          VARCHAR (20)    DEFAULT ('') NULL,
    [FirstName]                             VARCHAR (50)    NULL,
    [MiddleName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [LastName]                              VARCHAR (50)    NULL,
    [Gender]                                VARCHAR (10)    NULL,
    [DOB]                                   DATE            NULL,
    [DOD]                                   DATE            CONSTRAINT [DF__FctMembersh__DOD] DEFAULT ('01/01/1900') NULL,
    [MemberSSN]                             VARCHAR (15)    DEFAULT ('') NULL,
    [CurrentAge]                            INT             NULL,
    [AgeGroup20Years]                       INT             DEFAULT ((0)) NULL,
    [AgeGroup10Years]                       INT             DEFAULT ((0)) NULL,
    [AgeGroup5Years]                        INT             DEFAULT ((0)) NULL,
    [MbrMonth]                              TINYINT         NULL,
    [MbrYear]                               SMALLINT        NULL,
    [LanguageCode]                          VARCHAR (100)   DEFAULT ('') NULL,
    [Ethnicity]                             VARCHAR (20)    DEFAULT ('') NULL,
    [Race]                                  VARCHAR (20)    DEFAULT ('') NULL,
    [MemberHomeAddress]                     VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeAddress1]                    VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeCity]                        VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeState]                       VARCHAR (50)    DEFAULT ('') NULL,
    [CountyName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [CountyNumber]                          VARCHAR (50)    DEFAULT ('') NULL,
    [Region]                                VARCHAR (50)    DEFAULT ('') NULL,
    [POD]                                   VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeZip]                         VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingAddress]                  VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingAddress1]                 VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingCity]                     VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingState]                    VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingZip]                      VARCHAR (50)    DEFAULT ('') NULL,
    [MemberPhone]                           VARCHAR (50)    DEFAULT ('') NULL,
    [MemberCellPhone]                       VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomePhone]                       VARCHAR (50)    DEFAULT ('') NULL,
    [MedicaidMedicareDualEligibleIndicator] CHAR (1)        DEFAULT ('') NULL,
    [PersonMonthCreatedfromClaimIndicator]  CHAR (1)        DEFAULT ('') NULL,
    [MemberStatus]                          VARCHAR (20)    DEFAULT ('') NULL,
    [EnrollementStatus]                     VARCHAR (10)    DEFAULT ('') NULL,
    [MemberID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [MedicaidID]                            VARCHAR (50)    DEFAULT ('') NULL,
    [CardID]                                VARCHAR (50)    DEFAULT ('') NULL,
    [FamilyID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [BenefitType]                           VARCHAR (50)    DEFAULT ('') NULL,
    [LOB]                                   VARCHAR (20)    DEFAULT ('') NULL,
    [PlanID]                                VARCHAR (50)    DEFAULT ('') NULL,
    [ProductCode]                           VARCHAR (50)    DEFAULT ('') NULL,
    [SubgrpID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [SubgrpName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [PlanName]                              VARCHAR (50)    DEFAULT ('') NULL,
    [PlanType]                              VARCHAR (10)    DEFAULT ('') NULL,
    [PlanTier]                              VARCHAR (10)    DEFAULT ('') NULL,
    [Contract]                              VARCHAR (20)    DEFAULT ('') NULL,
    [NPI]                                   VARCHAR (50)    DEFAULT ('') NULL,
    [PcpPracticeTIN]                        VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderFirstName]                     VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderMI]                            VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderLastName]                      VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderPracticeName]                  VARCHAR (100)   DEFAULT ('') NULL,
    [ProviderAddressLine1]                  VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderAddressLine2]                  VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderCity]                          VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderCounty]                        VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderZip]                           VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderPhone]                         VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderSpecialty]                     VARCHAR (100)   DEFAULT ('') NULL,
    [ProviderNetwork]                       VARCHAR (50)    DEFAULT ('') NULL,
    [SpecialistStatus]                      VARCHAR (50)    DEFAULT ('') NULL,
    [GroupOrPrivatePractice]                VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderPOD]                           VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderChapter]                       VARCHAR (50)    DEFAULT ('') NULL,
    [AceRiskScore]                          DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [AceRiskScoreLevel]                     DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [ClientRiskScore]                       DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [ClientRiskScoreLevel]                  DECIMAL (25, 2) DEFAULT ((0)) NULL,
    [RiskScoreUtilization]                  DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScoreClinical]                     DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScoreHRA]                          DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScorePlaceHolder]                  DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [EnrollmentYear]                        SMALLINT        DEFAULT ((0)) NULL,
    [EnrollmentQuarter]                     TINYINT         DEFAULT ((0)) NULL,
    [EnrollmentYearQuarter]                 TINYINT         DEFAULT ((0)) NULL,
    [EnrollmentYearMonth]                   TINYINT         DEFAULT ((0)) NULL,
    [EligibleYear]                          SMALLINT        DEFAULT ((0)) NULL,
    [EligibilityQuarter]                    TINYINT         DEFAULT ((0)) NULL,
    [EligibilityYearQuarter]                TINYINT         DEFAULT ((0)) NULL,
    [EligibilityYearMonth]                  TINYINT         DEFAULT ((0)) NULL,
    [MemberCount]                           TINYINT         DEFAULT ((0)) NULL,
    [AvgMemberCount]                        TINYINT         DEFAULT ((0)) NULL,
    [SubscriberCount]                       TINYINT         DEFAULT ((0)) NULL,
    [AvgSubscriberCount]                    TINYINT         DEFAULT ((0)) NULL,
    [PersonCreatedCount]                    TINYINT         DEFAULT ((0)) NULL,
    [MemberMonths]                          TINYINT         DEFAULT ((0)) NULL,
    [SubscriberMonths]                      TINYINT         DEFAULT ((0)) NULL,
    [FamilyRatio]                           TINYINT         DEFAULT ((0)) NULL,
    [AvgAge]                                TINYINT         DEFAULT ((0)) NULL,
    [NoOfMonths]                            TINYINT         DEFAULT ((0)) NULL,
    [MemberCurrentEffectiveDate]            DATE            NULL,
    [MemberCurrentExpirationDate]           DATE            NULL,
    [Active]                                BIT             NULL,
    [Excluded]                              BIT             DEFAULT ((0)) NULL,
    [MbrMemberKey]                          INT             DEFAULT ((0)) NULL,
    [MbrDemographicKey]                     INT             DEFAULT ((0)) NULL,
    [MbrPlanKey]                            INT             DEFAULT ((0)) NULL,
    [MbrCsPlanKey]                          INT             DEFAULT ((0)) NULL,
    [MbrPCPKey]                             INT             DEFAULT ((0)) NULL,
    [MbrPhoneKey_Home]                      INT             DEFAULT ((0)) NULL,
    [MbrPhoneKey_Mobile]                    INT             DEFAULT ((0)) NULL,
    [MbrPhoneKey_Work]                      INT             DEFAULT ((0)) NULL,
    [MbrAddressKey_Home]                    INT             DEFAULT ((0)) NULL,
    [MbrAddressKey_Work]                    INT             DEFAULT ((0)) NULL,
    [MbrEmailKey]                           INT             DEFAULT ((0)) NULL,
    [MbrRespPartyKey]                       INT             DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([FctMembershipSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrshp_RowEffDateRowExpDate]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [Gender], [DOB], [CurrentAge]);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrship_Active]
    ON [adw].[FctMembership]([Active] ASC)
    INCLUDE([LoadDate], [RwEffectiveDate], [RwExpirationDate], [ClientKey], [Ace_ID], [ClientMemberKey], [FirstName], [MiddleName], [LastName], [Gender], [DOB], [CurrentAge], [LanguageCode], [Ethnicity], [Race], [MemberHomeAddress], [MemberHomeAddress1], [MemberHomeCity], [MemberHomeState], [CountyName], [MemberHomeZip], [MemberMailingAddress], [MemberMailingAddress1], [MemberMailingCity], [MemberMailingState], [MemberMailingZip], [MemberCellPhone], [MemberHomePhone], [MedicaidID], [LOB], [PlanID], [SubgrpID], [SubgrpName], [PlanName], [Contract], [NPI], [PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName], [ProviderAddressLine1], [ProviderAddressLine2], [ProviderCity], [ProviderZip], [ProviderPhone], [ProviderPOD], [ClientRiskScore]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K32_K15]
    ON [adw].[FctMembership]([MbrYear] ASC, [MbrMonth] ASC, [ClientMemberKey] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K11_K12_13_15_72_73]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [NPI], [PcpPracticeTIN]);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrShp_RwEffRwExpDodActive]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC, [DOD] ASC, [Active] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [Gender], [DOB], [CurrentAge]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_118]
    ON [adw].[FctMembership]([MbrYear] ASC)
    INCLUDE([Active]);


GO
CREATE NONCLUSTERED INDEX [adwFctMembership_Active]
    ON [adw].[FctMembership]([Active] ASC)
    INCLUDE([CreatedDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_73]
    ON [adw].[FctMembership]([NPI] ASC)
    INCLUDE([PcpPracticeTIN]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_K1_73_77]
    ON [adw].[FctMembership]([NPI] ASC, [FctMembershipSkey] ASC)
    INCLUDE([PcpPracticeTIN], [ProviderPracticeName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_K1_73_74_76_77]
    ON [adw].[FctMembership]([NPI] ASC, [FctMembershipSkey] ASC)
    INCLUDE([PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName]);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwFctMbrshpCreatedDate]
    ON [adw].[FctMembership]([CreatedDate] ASC)
    INCLUDE([ClientMemberKey], [ClientRiskScore]);


GO
CREATE NONCLUSTERED INDEX [ndx_fctMbrClientCmkProvChapRwEffRwExp]
    ON [adw].[FctMembership]([ClientKey] ASC, [ClientMemberKey] ASC, [ProviderChapter] ASC, [RwEffectiveDate] ASC, [RwExpirationDate] ASC, [FctMembershipSkey] ASC, [AvgAge] ASC, [DOB] ASC, [Gender] ASC, [MemberPhone] ASC, [PcpPracticeTIN] ASC, [ProviderPracticeName] ASC, [NPI] ASC, [ProviderPhone] ASC)
    INCLUDE([FirstName], [LastName], [MemberHomeAddress], [MemberHomeAddress1], [MemberHomeCity], [MemberHomeState], [MemberMailingAddress], [MemberMailingAddress1], [MemberMailingCity], [MemberMailingState], [MemberMailingZip], [ProviderFirstName], [ProviderLastName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K11]
    ON [adw].[FctMembership]([MbrYear] ASC, [RwEffectiveDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K11_K12]
    ON [adw].[FctMembership]([MbrYear] ASC, [RwEffectiveDate] ASC, [RwExpirationDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_adwFctMbrshp_ClientClientMEmberKeyProvChapterRwEffDateRwExpDate]
    ON [adw].[FctMembership]([ClientKey] ASC, [ClientMemberKey] ASC, [ProviderChapter] ASC, [RwEffectiveDate] ASC, [RwExpirationDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrshp_RwEffRwExpActiveLoadDate]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC, [Active] ASC, [LoadDate] ASC)
    INCLUDE([FctMembershipSkey], [ClientMemberKey], [FirstName], [LastName], [DOB], [MemberHomeAddress], [MemberHomeAddress1], [MemberHomeCity], [MemberHomeState], [MemberHomeZip], [MemberHomePhone], [NPI], [PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName], [ProviderChapter]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_13_25_28_11]
    ON [adw].[FctMembership]([ClientMemberKey], [ClientKey], [DOB], [CurrentAge], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_25_15_11]
    ON [adw].[FctMembership]([DOB], [ClientMemberKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_12_15]
    ON [adw].[FctMembership]([RwExpirationDate], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_25_15_13_28]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [DOB], [ClientMemberKey], [ClientKey], [CurrentAge]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_11_32_33_13]
    ON [adw].[FctMembership]([ClientMemberKey], [RwEffectiveDate], [MbrMonth], [MbrYear], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_12_11_1]
    ON [adw].[FctMembership]([ClientMemberKey], [RwExpirationDate], [RwEffectiveDate], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_13_25_12]
    ON [adw].[FctMembership]([ClientMemberKey], [ClientKey], [DOB], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_33_32_1_13_11]
    ON [adw].[FctMembership]([ClientMemberKey], [MbrYear], [MbrMonth], [FctMembershipSkey], [ClientKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_24_11_12]
    ON [adw].[FctMembership]([Gender], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_32_13_15_11]
    ON [adw].[FctMembership]([MbrMonth], [ClientKey], [ClientMemberKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_25_11]
    ON [adw].[FctMembership]([DOB], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_11_13]
    ON [adw].[FctMembership]([ClientMemberKey], [RwEffectiveDate], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_32_15]
    ON [adw].[FctMembership]([MbrMonth], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_33_32_13]
    ON [adw].[FctMembership]([MbrYear], [MbrMonth], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_33_32_15_13]
    ON [adw].[FctMembership]([MbrYear], [MbrMonth], [ClientMemberKey], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_24_15_11_12]
    ON [adw].[FctMembership]([Gender], [ClientMemberKey], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_1_33]
    ON [adw].[FctMembership]([ClientMemberKey], [FctMembershipSkey], [MbrYear]);


GO
CREATE STATISTICS [_dta_stat_1219535428_14_11_12]
    ON [adw].[FctMembership]([Ace_ID], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_1_13_11_12_33]
    ON [adw].[FctMembership]([ClientMemberKey], [FctMembershipSkey], [ClientKey], [RwEffectiveDate], [RwExpirationDate], [MbrYear]);


GO
CREATE STATISTICS [_dta_stat_1219535428_1_15_13]
    ON [adw].[FctMembership]([FctMembershipSkey], [ClientMemberKey], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_105_11_12]
    ON [adw].[FctMembership]([EligibilityYearMonth], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_1_13_15]
    ON [adw].[FctMembership]([RwEffectiveDate], [FctMembershipSkey], [ClientKey], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_25_24_13]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [DOB], [Gender], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_1_13_11_12]
    ON [adw].[FctMembership]([FctMembershipSkey], [ClientKey], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_12_1_13_15_11]
    ON [adw].[FctMembership]([RwExpirationDate], [FctMembershipSkey], [ClientKey], [ClientMemberKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_12_15_33_32_13]
    ON [adw].[FctMembership]([RwExpirationDate], [ClientMemberKey], [MbrYear], [MbrMonth], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_13_1]
    ON [adw].[FctMembership]([ClientKey], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_13_15_33]
    ON [adw].[FctMembership]([ClientKey], [ClientMemberKey], [MbrYear]);


GO
CREATE STATISTICS [_dta_stat_1219535428_13_15_72_73_11]
    ON [adw].[FctMembership]([ClientKey], [ClientMemberKey], [NPI], [PcpPracticeTIN], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_13_12_15_33_32_1]
    ON [adw].[FctMembership]([RwEffectiveDate], [ClientKey], [RwExpirationDate], [ClientMemberKey], [MbrYear], [MbrMonth], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_1_72]
    ON [adw].[FctMembership]([FctMembershipSkey], [NPI]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_1_13_72]
    ON [adw].[FctMembership]([ClientMemberKey], [FctMembershipSkey], [ClientKey], [NPI]);


GO
CREATE STATISTICS [_dta_stat_1219535428_32_1_12_15_13_11]
    ON [adw].[FctMembership]([MbrMonth], [FctMembershipSkey], [RwExpirationDate], [ClientMemberKey], [ClientKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_1_33]
    ON [adw].[FctMembership]([RwEffectiveDate], [FctMembershipSkey], [MbrYear]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_33]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [MbrYear]);


GO
CREATE STATISTICS [_dta_stat_1219535428_12_33_1]
    ON [adw].[FctMembership]([RwExpirationDate], [MbrYear], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_26_1]
    ON [adw].[FctMembership]([DOD], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_1_88]
    ON [adw].[FctMembership]([FctMembershipSkey], [ProviderPOD]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_1]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_1_88_11]
    ON [adw].[FctMembership]([ClientMemberKey], [FctMembershipSkey], [ProviderPOD], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_26_12_88]
    ON [adw].[FctMembership]([RwEffectiveDate], [DOD], [RwExpirationDate], [ProviderPOD]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_26_15_1]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [DOD], [ClientMemberKey], [FctMembershipSkey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_88_26_1_15_11]
    ON [adw].[FctMembership]([ProviderPOD], [DOD], [FctMembershipSkey], [ClientMemberKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_1_11_12_88_26]
    ON [adw].[FctMembership]([ClientMemberKey], [FctMembershipSkey], [RwEffectiveDate], [RwExpirationDate], [ProviderPOD], [DOD]);


GO
CREATE STATISTICS [_dta_stat_1219535428_9_15_11_12_1_88_26]
    ON [adw].[FctMembership]([LoadDate], [ClientMemberKey], [RwEffectiveDate], [RwExpirationDate], [FctMembershipSkey], [ProviderPOD], [DOD]);


GO
CREATE STATISTICS [_dta_stat_1219535428_12_15_13_11_93]
    ON [adw].[FctMembership]([RwExpirationDate], [ClientMemberKey], [ClientKey], [RwEffectiveDate], [ClientRiskScoreLevel]);


GO
CREATE STATISTICS [_dta_stat_1219535428_93_11_12]
    ON [adw].[FctMembership]([ClientRiskScoreLevel], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_72_11]
    ON [adw].[FctMembership]([NPI], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_93_11_12]
    ON [adw].[FctMembership]([ClientMemberKey], [ClientRiskScoreLevel], [RwEffectiveDate], [RwExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_72_13_11]
    ON [adw].[FctMembership]([ClientMemberKey], [NPI], [ClientKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_15_72_11]
    ON [adw].[FctMembership]([ClientMemberKey], [NPI], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_118_1_15_11]
    ON [adw].[FctMembership]([Active], [FctMembershipSkey], [ClientMemberKey], [RwEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_118]
    ON [adw].[FctMembership]([RwEffectiveDate], [Active]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_15_72_13_93]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [ClientMemberKey], [NPI], [ClientKey], [ClientRiskScoreLevel]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_72]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [NPI]);


GO
CREATE STATISTICS [_dta_stat_1219535428_11_12_118_15]
    ON [adw].[FctMembership]([RwEffectiveDate], [RwExpirationDate], [Active], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1219535428_1_15_11_12_118]
    ON [adw].[FctMembership]([FctMembershipSkey], [ClientMemberKey], [RwEffectiveDate], [RwExpirationDate], [Active]);


GO



CREATE TRIGGER [adw].[fctMSSP_lst_UpdatedDate]
ON [adw].[fctMembership]
AFTER UPDATE 
AS
   UPDATE adw.FctMembership
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.FctMembership.FctMembershipSkey = i.FctMembershipSkey
   ;
