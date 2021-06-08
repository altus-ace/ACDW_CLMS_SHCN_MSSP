CREATE TABLE [lst].[LstAstTransformStates] (
    [astTransformStateKey]         INT          IDENTITY (1, 1) NOT NULL,
    [astTransformStateCode]        VARCHAR (10) NOT NULL,
    [astTransformStateDescription] VARCHAR (50) NOT NULL,
    [active]                       TINYINT      NOT NULL,
    [createdDate]                  DATETIME     CONSTRAINT [df_lstAstTransformStates_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]                    VARCHAR (50) CONSTRAINT [df_lstAstTransformStates_CreatedBy] DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([astTransformStateKey] ASC)
);

