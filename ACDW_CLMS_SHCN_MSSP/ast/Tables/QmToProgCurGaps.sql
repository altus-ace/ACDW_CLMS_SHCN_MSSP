CREATE TABLE [ast].[QmToProgCurGaps] (
    [QmToProgCurCapKey] INT          IDENTITY (1, 1) NOT NULL,
    [CreatedDate]       DATETIME     DEFAULT (getdate()) NULL,
    [CreatedBy]         VARCHAR (50) DEFAULT (suser_sname()) NULL,
    [srcKey]            INT          DEFAULT ((0)) NOT NULL,
    [SrcTableName]      VARCHAR (50) DEFAULT ('Value Not Set') NOT NULL,
    [ClientMemberKey]   VARCHAR (50) NULL,
    [ClientKey]         INT          NULL,
    [QmMsrId]           VARCHAR (50) NULL,
    [QmCntCat]          VARCHAR (5)  NULL,
    [Addressed]         INT          DEFAULT ((0)) NULL,
    [CalcQmCntCat]      VARCHAR (5)  NULL,
    [QmDate]            DATE         NULL,
    [RecStatus]         VARCHAR (1)  NULL,
    [RecStatusDate]     DATE         NULL,
    [SendFlg]           INT          DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([QmToProgCurCapKey] ASC)
);

