CREATE TABLE [adw].[Claims_Procs] (
    [URN]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]    VARCHAR (50)  NULL,
    [SUBSCRIBER_ID]   VARCHAR (50)  NULL,
    [ProcNumber]      SMALLINT      NULL,
    [ProcCode]        VARCHAR (20)  NULL,
    [ProcDate]        VARCHAR (50)  NULL,
    [LoadDate]        DATETIME      NOT NULL,
    [SrcAdiTableName] VARCHAR (100) NULL,
    [SrcAdiKey]       INT           NOT NULL,
    [CreatedDate]     DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Procs] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NdxCP_SubscriberID]
    ON [adw].[Claims_Procs]([SUBSCRIBER_ID] ASC)
    INCLUDE([URN], [SEQ_CLAIM_ID], [ProcNumber], [ProcCode], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [NdxCP_ProcNum]
    ON [adw].[Claims_Procs]([ProcNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsProc_SeqClaimID]
    ON [adw].[Claims_Procs]([SEQ_CLAIM_ID] ASC)
    INCLUDE([URN], [SUBSCRIBER_ID], [ProcNumber], [ProcCode], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsProc_ProcCode]
    ON [adw].[Claims_Procs]([ProcCode] ASC)
    INCLUDE([URN], [SEQ_CLAIM_ID], [SUBSCRIBER_ID], [ProcNumber], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Procs_17_809105973__K5_K2]
    ON [adw].[Claims_Procs]([ProcCode] ASC, [SEQ_CLAIM_ID] ASC);


GO
CREATE STATISTICS [_dta_stat_482100758_5_2]
    ON [adw].[Claims_Procs]([ProcCode], [SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_482100758_2_5]
    ON [adw].[Claims_Procs]([SEQ_CLAIM_ID], [ProcCode]);


GO
CREATE STATISTICS [_dta_stat_809105973_5_2_6]
    ON [adw].[Claims_Procs]([ProcCode], [SEQ_CLAIM_ID], [ProcDate]);


GO
CREATE STATISTICS [_dta_stat_809105973_6_2]
    ON [adw].[Claims_Procs]([ProcDate], [SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_809105973_6_5]
    ON [adw].[Claims_Procs]([ProcDate], [ProcCode]);


GO

CREATE TRIGGER adw.ClaimsProcs_AfterUpdate
ON adw.Claims_Procs
AFTER UPDATE 
AS
   UPDATE adw.Claims_Procs
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Procs.URN = i.URN;
