CREATE TABLE [ast].[Shcn_BNex_MbrsToUpdate] (
    [ShcnBnexMbrsToUpdateKey] INT           IDENTITY (1, 1) NOT NULL,
    [srcFileName]             VARCHAR (100) DEFAULT ('No src File Name provided') NOT NULL,
    [srcAdiKey]               INT           DEFAULT ((0)) NOT NULL,
    [srcAdiTableName]         VARCHAR (100) DEFAULT ('No table provided') NOT NULL,
    [CreatedDate]             DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]               VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [EffYr]                   INT           NULL,
    [EffMth]                  INT           NULL,
    [FctKey]                  INT           NOT NULL,
    [ClientMemberKey]         VARCHAR (50)  NULL,
    [DOD]                     DATE          NULL,
    [Active]                  TINYINT       NULL,
    [Bnex]                    VARCHAR (10)  NULL,
    [CalcExp]                 INT           NOT NULL,
    [CalcActive]              INT           NOT NULL,
    [StatusUpdateFctMember]   TINYINT       DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([ShcnBnexMbrsToUpdateKey] ASC)
);

