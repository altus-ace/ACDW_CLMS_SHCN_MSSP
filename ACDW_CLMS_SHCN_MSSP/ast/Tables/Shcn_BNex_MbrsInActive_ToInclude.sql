CREATE TABLE [ast].[Shcn_BNex_MbrsInActive_ToInclude] (
    [EffYr]           INT          NULL,
    [EffMth]          INT          NULL,
    [FctKey]          INT          NOT NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [DOD]             DATE         NULL,
    [Active]          TINYINT      NULL,
    [Bnex]            VARCHAR (10) NULL,
    [CalcExp]         INT          NOT NULL,
    [CalcActive]      INT          NOT NULL
);

