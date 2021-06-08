CREATE TABLE [lst].[lst_Metric_Calculation] (
    [VerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [MetricID]        VARCHAR (50)  NULL,
    [MetricDesc]      VARCHAR (50)  NOT NULL,
    [SQLStatement]    VARCHAR (MAX) NOT NULL,
    [ProdTable]       VARCHAR (50)  NOT NULL,
    [TestTable]       VARCHAR (50)  NOT NULL,
    [Active]          VARCHAR (1)   NULL,
    [EffectiveDate]   DATE          DEFAULT (getdate()) NULL,
    [ExpirationDate]  DATE          DEFAULT ('2099-12-31') NULL,
    [CreatedDate]     DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([VerKey] ASC)
);

