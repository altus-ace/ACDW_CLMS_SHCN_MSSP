CREATE TABLE [adw].[FctMEKPIByNPI] (
    [FctFctMEKpiNPIKey] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]       DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [AdiKey]            INT           NULL,
    [SrcFileName]       VARCHAR (100) NULL,
    [AdwTableName]      VARCHAR (100) NULL,
    [LoadDate]          DATE          DEFAULT (getdate()) NULL,
    [DataDate]          DATE          NULL,
    [EffectiveAsOfDate] DATE          NULL,
    [KPI_ID]            INT           NULL,
    [KPI]               VARCHAR (50)  NULL,
    [KPIEffYear]        INT           NULL,
    [KPIEffMth]         INT           NULL,
    [AttribPod]         VARCHAR (50)  NULL,
    [AttribNPI]         INT           NULL,
    [AttribNPIName]     VARCHAR (100) NULL,
    [AttribTIN]         INT           NULL,
    [AttribTINName]     VARCHAR (100) NULL,
    [KPIValue]          INT           NULL,
    [KPIValue2]         VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([FctFctMEKpiNPIKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMEKPIByNPI_17_2118350661__K11]
    ON [adw].[FctMEKPIByNPI]([EffectiveAsOfDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMEKPIByNPI_17_2118350661__K12_K11_K17_K14_K15_K21]
    ON [adw].[FctMEKPIByNPI]([KPI_ID] ASC, [EffectiveAsOfDate] ASC, [AttribNPI] ASC, [KPIEffYear] ASC, [KPIEffMth] ASC, [KPIValue] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMEKPIByNPI_17_2118350661__K12_K11_K17_K14_K15_K21_K18_K19_K20]
    ON [adw].[FctMEKPIByNPI]([KPI_ID] ASC, [EffectiveAsOfDate] ASC, [AttribNPI] ASC, [KPIEffYear] ASC, [KPIEffMth] ASC, [KPIValue] ASC, [AttribNPIName] ASC, [AttribTIN] ASC, [AttribTINName] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMEKPIByNPI_17_2118350661__K12_K17_K14_K15_K11_K18_K19_K20_K21]
    ON [adw].[FctMEKPIByNPI]([KPI_ID] ASC, [AttribNPI] ASC, [KPIEffYear] ASC, [KPIEffMth] ASC, [EffectiveAsOfDate] ASC, [AttribNPIName] ASC, [AttribTIN] ASC, [AttribTINName] ASC, [KPIValue] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMEKPIByNPI_17_2118350661__K11_K12_K15_K14_K17_K18_K19_K20_K21_1_2_3_4_5_6_7_8_9_10_13_22]
    ON [adw].[FctMEKPIByNPI]([EffectiveAsOfDate] ASC, [KPI_ID] ASC, [KPIEffMth] ASC, [KPIEffYear] ASC, [AttribNPI] ASC, [AttribNPIName] ASC, [AttribTIN] ASC, [AttribTINName] ASC, [KPIValue] ASC)
    INCLUDE([FctFctMEKpiNPIKey], [CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [AdiKey], [SrcFileName], [AdwTableName], [LoadDate], [DataDate], [KPI], [KPIValue2]);


GO
CREATE STATISTICS [_dta_stat_2118350661_11_12_14]
    ON [adw].[FctMEKPIByNPI]([EffectiveAsOfDate], [KPI_ID], [KPIEffYear]);


GO
CREATE STATISTICS [_dta_stat_2118350661_11_14_15_17_18_19_20_21]
    ON [adw].[FctMEKPIByNPI]([EffectiveAsOfDate], [KPIEffYear], [KPIEffMth], [AttribNPI], [AttribNPIName], [AttribTIN], [AttribTINName], [KPIValue]);


GO
CREATE STATISTICS [_dta_stat_2118350661_11_14_15_17_21]
    ON [adw].[FctMEKPIByNPI]([EffectiveAsOfDate], [KPIEffYear], [KPIEffMth], [AttribNPI], [KPIValue]);


GO
CREATE STATISTICS [_dta_stat_2118350661_14_17_15_11_12_18_19_20_21]
    ON [adw].[FctMEKPIByNPI]([KPIEffYear], [AttribNPI], [KPIEffMth], [EffectiveAsOfDate], [KPI_ID], [AttribNPIName], [AttribTIN], [AttribTINName], [KPIValue]);


GO
CREATE STATISTICS [_dta_stat_2118350661_15_17]
    ON [adw].[FctMEKPIByNPI]([KPIEffMth], [AttribNPI]);


GO
CREATE STATISTICS [_dta_stat_2118350661_17_11]
    ON [adw].[FctMEKPIByNPI]([AttribNPI], [EffectiveAsOfDate]);


GO
CREATE STATISTICS [_dta_stat_2118350661_17_11_12_15]
    ON [adw].[FctMEKPIByNPI]([AttribNPI], [EffectiveAsOfDate], [KPI_ID], [KPIEffMth]);


GO
CREATE STATISTICS [_dta_stat_2118350661_14_15_11_12_21_19_20_18]
    ON [adw].[FctMEKPIByNPI]([KPIEffYear], [KPIEffMth], [EffectiveAsOfDate], [KPI_ID], [KPIValue], [AttribTIN], [AttribTINName], [AttribNPIName]);


GO
CREATE STATISTICS [_dta_stat_2118350661_19_20_18_14_15_11_12]
    ON [adw].[FctMEKPIByNPI]([AttribTIN], [AttribTINName], [AttribNPIName], [KPIEffYear], [KPIEffMth], [EffectiveAsOfDate], [KPI_ID]);

