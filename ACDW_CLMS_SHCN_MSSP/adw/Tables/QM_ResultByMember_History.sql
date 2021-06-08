CREATE TABLE [adw].[QM_ResultByMember_History] (
    [QM_ResultByMbr_HistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]                 INT           NULL,
    [ClientMemberKey]           VARCHAR (50)  NOT NULL,
    [QmMsrId]                   VARCHAR (20)  NOT NULL,
    [QmCntCat]                  VARCHAR (10)  NOT NULL,
    [QMDate]                    DATE          CONSTRAINT [DF_QM_ResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]                DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateBy]                  VARCHAR (50)  DEFAULT (suser_name()) NOT NULL,
    [LastUpdatedDate]           DATETIME      CONSTRAINT [DF_QM_ResultByMbr_History_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (50)  CONSTRAINT [DF_QM_ResultByMbr_History_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AdiKey]                    INT           CONSTRAINT [DF_QM_ResutlByMbr_History_AdiKey] DEFAULT ((0)) NULL,
    [adiTableName]              VARCHAR (150) DEFAULT ('No Table name') NULL,
    [Addressed]                 INT           DEFAULT ((0)) NULL,
    CONSTRAINT [QmResultsByMemberHistory_pk] PRIMARY KEY CLUSTERED ([QM_ResultByMbr_HistoryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_adwQmResultByMemberHistory_QmCntCat]
    ON [adw].[QM_ResultByMember_History]([QmCntCat] ASC)
    INCLUDE([ClientMemberKey], [QMDate]);


GO
CREATE NONCLUSTERED INDEX [ndx_adwQmResultByMemberHistory_ClientMemberKeyQmCntCat]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey] ASC, [QmCntCat] ASC)
    INCLUDE([QMDate]);


GO
CREATE NONCLUSTERED INDEX [ndx_QmResultByMemberHistoryQmCntCatClientKeyCreateDateQmMsrIdClienntMbrKeyQmDate]
    ON [adw].[QM_ResultByMember_History]([QmCntCat] ASC, [ClientKey] ASC, [CreateDate] ASC, [QmMsrId] ASC, [ClientMemberKey] ASC, [QMDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_17_2034874366__K2_K6]
    ON [adw].[QM_ResultByMember_History]([ClientKey] ASC, [QMDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ndxQmResultByMemberHistory]
    ON [adw].[QM_ResultByMember_History]([ClientKey] ASC, [QmMsrId] ASC, [QMDate] ASC, [ClientMemberKey] ASC)
    INCLUDE([QmCntCat]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_17_2034874366__K5_K3_K4_K6]
    ON [adw].[QM_ResultByMember_History]([QmCntCat] ASC, [ClientMemberKey] ASC, [QmMsrId] ASC, [QMDate] ASC);


GO
CREATE STATISTICS [ndx_AdwQmResultByMemberHistory_CmkQmDateClientKey]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QMDate], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_2034874366_4_5]
    ON [adw].[QM_ResultByMember_History]([QmMsrId], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_2034874366_5_7_4]
    ON [adw].[QM_ResultByMember_History]([QmCntCat], [CreateDate], [QmMsrId]);


GO
CREATE STATISTICS [_dta_stat_2034874366_3_4_5]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QmMsrId], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_2034874366_5_2_3]
    ON [adw].[QM_ResultByMember_History]([QmCntCat], [ClientKey], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_2034874366_7_5_2]
    ON [adw].[QM_ResultByMember_History]([CreateDate], [QmCntCat], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_2034874366_3_4_6_2]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QmMsrId], [QMDate], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_2034874366_3_5_2_7]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QmCntCat], [ClientKey], [CreateDate]);


GO
CREATE STATISTICS [_dta_stat_2034874366_5_2_4_7]
    ON [adw].[QM_ResultByMember_History]([QmCntCat], [ClientKey], [QmMsrId], [CreateDate]);


GO
CREATE STATISTICS [_dta_stat_2034874366_6_2_7_4_5]
    ON [adw].[QM_ResultByMember_History]([QMDate], [ClientKey], [CreateDate], [QmMsrId], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_2034874366_3_4_2_5_6]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QmMsrId], [ClientKey], [QmCntCat], [QMDate]);


GO
CREATE STATISTICS [_dta_stat_2034874366_7_4_2_3_5_6]
    ON [adw].[QM_ResultByMember_History]([CreateDate], [QmMsrId], [ClientKey], [ClientMemberKey], [QmCntCat], [QMDate]);


GO
CREATE STATISTICS [_dta_stat_2034874366_6_3_5_4]
    ON [adw].[QM_ResultByMember_History]([QMDate], [ClientMemberKey], [QmCntCat], [QmMsrId]);


GO
CREATE STATISTICS [_dta_stat_2034874366_5_6]
    ON [adw].[QM_ResultByMember_History]([QmCntCat], [QMDate]);

