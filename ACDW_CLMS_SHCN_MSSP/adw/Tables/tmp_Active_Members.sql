CREATE TABLE [adw].[tmp_Active_Members] (
    [URN]                   INT            IDENTITY (1, 1) NOT NULL,
    [ClientKey]             INT            NOT NULL,
    [ACE_ID]                VARCHAR (50)   NOT NULL,
    [ClientMemberKey]       VARCHAR (50)   NOT NULL,
    [AltMemberID]           VARCHAR (50)   NOT NULL,
    [Product]               VARCHAR (50)   NULL,
    [MainPlan]              VARCHAR (50)   NULL,
    [SubPlan]               VARCHAR (100)  NULL,
    [FirstName]             VARCHAR (50)   NULL,
    [LastName]              VARCHAR (50)   NULL,
    [Gender]                VARCHAR (1)    NULL,
    [Member_Address]        VARCHAR (100)  NULL,
    [Member_Address2]       VARCHAR (50)   NULL,
    [Member_City]           VARCHAR (100)  NULL,
    [Member_State]          VARCHAR (20)   NULL,
    [Member_Phone]          VARCHAR (25)   NULL,
    [Member_Phone2]         VARCHAR (25)   NULL,
    [Member_Zip]            VARCHAR (5)    NULL,
    [Member_Pod]            VARCHAR (5)    NULL,
    [DOB]                   DATE           NULL,
    [DOD]                   DATE           NULL,
    [CurrentAge]            INT            NULL,
    [Exclusion]             VARCHAR (1)    DEFAULT ('N') NULL,
    [Mbr_Type]              VARCHAR (1)    NULL,
    [Lst12Mths_AWV]         INT            DEFAULT ((0)) NULL,
    [Lst12Mths_PCP]         INT            DEFAULT ((0)) NULL,
    [Lst12Mths_Specialist]  INT            DEFAULT ((0)) NULL,
    [Lst12Mths_IP]          INT            DEFAULT ((0)) NULL,
    [Lst12Mths_ER]          INT            DEFAULT ((0)) NULL,
    [Lst12Mths_RA]          INT            DEFAULT ((0)) NULL,
    [CurrentGaps]           INT            DEFAULT ((0)) NULL,
    [ContractedGaps]        INT            DEFAULT ((0)) NULL,
    [AHRGaps]               INT            DEFAULT ((0)) NULL,
    [Demo_RiskScore]        DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [HCC_RiskScore]         DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [Churn_RiskScore]       DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [MEngagement_RiskScore] DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [PEngagement_RiskScore] DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [Alt1_RiskScore]        DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [Alt2_RiskScore]        DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [Tot_RiskScore]         DECIMAL (5, 4) DEFAULT ((0.00)) NULL,
    [Tot_RiskBand]          INT            DEFAULT ((0)) NULL,
    [AgeBand]               INT            DEFAULT ((0)) NULL,
    [MortalityFlg]          INT            DEFAULT ((0)) NULL,
    [TIN]                   VARCHAR (50)   NULL,
    [TIN_NAME]              VARCHAR (100)  NULL,
    [NPI]                   VARCHAR (50)   NULL,
    [NPI_NAME]              VARCHAR (100)  NULL,
    [MBR_YEAR]              INT            DEFAULT (datepart(year,getdate())) NULL,
    [MBR_QTR]               INT            DEFAULT (datepart(quarter,getdate())) NULL,
    [MBR_MTH]               INT            DEFAULT (datepart(month,getdate())) NULL,
    [LOAD_DATE]             DATE           DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]             VARCHAR (50)   DEFAULT (suser_sname()) NULL,
    [CreateDate]            DATETIME2 (7)  DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]              VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [LastUpdateDate]        DATETIME2 (7)  DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdateBy]          VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [AdiTableName]          VARCHAR (100)  NULL,
    [SrcFileName]           VARCHAR (100)  NULL,
    [EffectiveDate]         DATE           DEFAULT (dateadd(day,(1),eomonth(getdate(),(-1)))) NULL,
    [ExpirationDate]        DATE           DEFAULT (eomonth(getdate())) NULL
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_tmp_Active_Members_25_1765581328__K4_K20_K52_11]
    ON [adw].[tmp_Active_Members]([ClientMemberKey] ASC, [DOB] ASC, [LOAD_DATE] ASC)
    INCLUDE([Gender]);


GO
CREATE NONCLUSTERED INDEX [ndx_Client]
    ON [adw].[tmp_Active_Members]([ClientKey] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_ClientAndMember]
    ON [adw].[tmp_Active_Members]([ClientKey] ASC, [ACE_ID] ASC, [ClientMemberKey] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_ClientMemberAge]
    ON [adw].[tmp_Active_Members]([ClientKey] ASC, [ClientMemberKey] ASC, [CurrentAge] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_ClientMemberNPI]
    ON [adw].[tmp_Active_Members]([ClientKey] ASC, [ClientMemberKey] ASC, [NPI] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_ClientMemberTIN]
    ON [adw].[tmp_Active_Members]([ClientKey] ASC, [ClientMemberKey] ASC, [TIN] ASC);


GO
CREATE STATISTICS [_dta_stat_1765581328_1]
    ON [adw].[tmp_Active_Members]([URN]);


GO
CREATE STATISTICS [_dta_stat_1765581328_20_11]
    ON [adw].[tmp_Active_Members]([DOB], [Gender]);


GO
CREATE STATISTICS [_dta_stat_1765581328_20_4]
    ON [adw].[tmp_Active_Members]([DOB], [ClientMemberKey]);


GO
CREATE STATISTICS [_dta_stat_1765581328_4_2_20_52]
    ON [adw].[tmp_Active_Members]([ClientMemberKey], [ClientKey], [DOB], [LOAD_DATE]);


GO
CREATE STATISTICS [_dta_stat_1765581328_4_20_11]
    ON [adw].[tmp_Active_Members]([ClientMemberKey], [DOB], [Gender]);


GO
CREATE STATISTICS [_dta_stat_1765581328_4_20_52_11]
    ON [adw].[tmp_Active_Members]([ClientMemberKey], [DOB], [LOAD_DATE], [Gender]);

