CREATE TABLE [adw].[FctAWVVisits] (
    [FctAWVVisitsSkey]     INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]            VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]      DATETIME      DEFAULT (getdate()) NULL,
    [LastUpdatedBy]        VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [AdiKey]               INT           NULL,
    [SrcFileName]          VARCHAR (100) NULL,
    [LoadDate]             DATE          NULL,
    [DataDate]             DATE          NULL,
    [ClientKey]            INT           NULL,
    [ClientMemberKey]      VARCHAR (50)  NULL,
    [EffectiveAsOfDate]    DATE          NULL,
    [ClaimID]              VARCHAR (50)  NULL,
    [PrimaryServiceDate]   DATE          NULL,
    [AWVType]              VARCHAR (20)  NULL,
    [AWVCode]              VARCHAR (10)  NULL,
    [SVCProviderNPI]       VARCHAR (20)  NULL,
    [SVCProviderName]      VARCHAR (100) NULL,
    [SVCProviderSpecialty] VARCHAR (50)  NULL,
    [LastAWVKey]           INT           NULL,
    [LastAWVDate]          DATE          NULL,
    [LastAWVNPI]           VARCHAR (10)  NULL,
    [AttribNPI]            VARCHAR (10)  NULL,
    [AttribTIN]            VARCHAR (10)  NULL,
    CONSTRAINT [FctAWVVisitsSkey_pk] PRIMARY KEY CLUSTERED ([FctAWVVisitsSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctAWVVisits_17_1161823251__K11_1]
    ON [adw].[FctAWVVisits]([ClientMemberKey] ASC)
    INCLUDE([FctAWVVisitsSkey]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctAWVVisits_17_1161823251__K11_K14D_1_17]
    ON [adw].[FctAWVVisits]([ClientMemberKey] ASC, [PrimaryServiceDate] DESC)
    INCLUDE([FctAWVVisitsSkey], [SVCProviderNPI]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctAWVVisits_17_1161823251__K12_K10_K11_K14_K23_K24]
    ON [adw].[FctAWVVisits]([EffectiveAsOfDate] ASC, [ClientKey] ASC, [ClientMemberKey] ASC, [PrimaryServiceDate] ASC, [AttribNPI] ASC, [AttribTIN] ASC);


GO
CREATE STATISTICS [_dta_stat_1161823251_14_10_11_23_24]
    ON [adw].[FctAWVVisits]([PrimaryServiceDate], [ClientKey], [ClientMemberKey], [AttribNPI], [AttribTIN]);


GO
CREATE STATISTICS [_dta_stat_1161823251_12_11]
    ON [adw].[FctAWVVisits]([EffectiveAsOfDate], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1161823251_10_11_12_14_23_24]
    ON [adw].[FctAWVVisits]([ClientKey], [ClientMemberKey], [EffectiveAsOfDate], [PrimaryServiceDate], [AttribNPI], [AttribTIN]);

