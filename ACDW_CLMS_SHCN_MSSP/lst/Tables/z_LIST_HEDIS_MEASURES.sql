CREATE TABLE [lst].[z_LIST_HEDIS_MEASURES] (
    [lstHedisMeasureKey] INT           IDENTITY (1, 1) NOT NULL,
    [MEASURE_ID]         VARCHAR (20)  NULL,
    [MEASURE_NAME]       VARCHAR (100) NULL,
    [VALUE_SET_NAME]     VARCHAR (100) NULL,
    [VALUE_SET_OID]      VARCHAR (100) NULL,
    [ACTIVE]             VARCHAR (2)   NULL,
    [EffectiveDate]      DATE          NULL,
    [ExpirationDate]     DATE          NULL,
    [CreatedDate]        DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]        VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([lstHedisMeasureKey] ASC)
);

