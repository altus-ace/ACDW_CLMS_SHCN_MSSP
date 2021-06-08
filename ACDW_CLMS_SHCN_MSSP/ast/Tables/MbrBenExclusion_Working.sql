CREATE TABLE [ast].[MbrBenExclusion_Working] (
    [Skey]                  INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]                INT           NOT NULL,
    [adiTableName]          VARCHAR (100) NULL,
    [CreatedDate]           DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]             VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [MedicareBeneficiaryID] VARCHAR (20)  NULL,
    [PerformanceYearNbr]    INT           NULL,
    [ReportMonthNbr]        INT           NULL,
    [ExcludedFlg]           TINYINT       NULL,
    PRIMARY KEY CLUSTERED ([Skey] ASC)
);

