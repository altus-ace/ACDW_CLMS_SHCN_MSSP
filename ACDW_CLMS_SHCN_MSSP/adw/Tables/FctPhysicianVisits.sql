CREATE TABLE [adw].[FctPhysicianVisits] (
    [FctPhysicianVisitsSkey] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]            DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [AdiKey]                 INT           NULL,
    [SrcFileName]            VARCHAR (100) NULL,
    [AdiTableName]           VARCHAR (100) NULL,
    [LoadDate]               DATE          NULL,
    [DataDate]               DATE          NULL,
    [ClientKey]              INT           NULL,
    [ClientMemberKey]        VARCHAR (50)  NULL,
    [EffectiveAsOfDate]      DATE          NULL,
    [VisitExamType]          VARCHAR (50)  NULL,
    [SEQ_ClaimID]            VARCHAR (50)  NULL,
    [PrimaryServiceDate]     DATE          NULL,
    [SVCProviderNPI]         VARCHAR (10)  NULL,
    [SVCProviderName]        VARCHAR (100) NULL,
    [SVCProviderSpecialty]   VARCHAR (50)  NULL,
    [PrimaryDiagnosis]       VARCHAR (100) NULL,
    [CPT]                    VARCHAR (10)  NULL,
    [AttribNPI]              VARCHAR (10)  NULL,
    [AttribTIN]              VARCHAR (10)  NULL,
    [SVCProviderType]        VARCHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([FctPhysicianVisitsSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_adwFctPhysicianVisits_Clntmbrkey_PrimSvcDt]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey] ASC, [PrimaryServiceDate] ASC)
    INCLUDE([AttribNPI], [AttribTIN], [SVCProviderNPI], [SVCProviderName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctPhysicianVisits_17_1632776924__K12_K22_K15_K16]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey] ASC, [AttribNPI] ASC, [SEQ_ClaimID] ASC, [PrimaryServiceDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctPhysicianVisits_17_1632776924__K12_K16D_17_18]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey] ASC, [PrimaryServiceDate] DESC)
    INCLUDE([SVCProviderNPI], [SVCProviderName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctPhysicianVisits_17_1632776924__K12_K16D_K22_K17_18]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey] ASC, [PrimaryServiceDate] DESC, [AttribNPI] ASC, [SVCProviderNPI] ASC)
    INCLUDE([SVCProviderName]);


GO
CREATE STATISTICS [_dta_stat_1632776924_22_16]
    ON [adw].[FctPhysicianVisits]([AttribNPI], [PrimaryServiceDate]);


GO
CREATE STATISTICS [_dta_stat_1632776924_12_1]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey], [FctPhysicianVisitsSkey]);


GO
CREATE STATISTICS [_dta_stat_1632776924_12_16_22_17_1_15]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey], [PrimaryServiceDate], [AttribNPI], [SVCProviderNPI], [FctPhysicianVisitsSkey], [SEQ_ClaimID]);


GO
CREATE STATISTICS [_dta_stat_1632776924_12_17_16_22]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey], [SVCProviderNPI], [PrimaryServiceDate], [AttribNPI]);


GO
CREATE STATISTICS [_dta_stat_1632776924_12_22_17_1]
    ON [adw].[FctPhysicianVisits]([ClientMemberKey], [AttribNPI], [SVCProviderNPI], [FctPhysicianVisitsSkey]);


GO
CREATE STATISTICS [_dta_stat_1632776924_16_12_1_15]
    ON [adw].[FctPhysicianVisits]([PrimaryServiceDate], [ClientMemberKey], [FctPhysicianVisitsSkey], [SEQ_ClaimID]);


GO
CREATE STATISTICS [_dta_stat_1632776924_16_12_22_15_17]
    ON [adw].[FctPhysicianVisits]([PrimaryServiceDate], [ClientMemberKey], [AttribNPI], [SEQ_ClaimID], [SVCProviderNPI]);


GO
CREATE STATISTICS [_dta_stat_1632776924_22_12_17]
    ON [adw].[FctPhysicianVisits]([AttribNPI], [ClientMemberKey], [SVCProviderNPI]);


GO
CREATE STATISTICS [_dta_stat_1632776924_1_15]
    ON [adw].[FctPhysicianVisits]([FctPhysicianVisitsSkey], [SEQ_ClaimID]);

