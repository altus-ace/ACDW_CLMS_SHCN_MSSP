CREATE TYPE [dbo].[ntfFailedLogTable] AS TABLE (
    [BusinessRuleKey] INT           NULL,
    [RuleOutCome]     VARCHAR (20)  NULL,
    [AdiTableName]    VARCHAR (100) NULL,
    [AdiKey]          INT           NULL,
    [astTableName]    VARCHAR (100) NULL,
    [astTableKey]     INT           NULL);

