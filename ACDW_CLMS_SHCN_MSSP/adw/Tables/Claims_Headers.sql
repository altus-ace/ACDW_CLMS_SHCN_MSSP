CREATE TABLE [adw].[Claims_Headers] (
    [SEQ_CLAIM_ID]            VARCHAR (50)  NOT NULL,
    [SUBSCRIBER_ID]           VARCHAR (50)  NULL,
    [CLAIM_NUMBER]            VARCHAR (50)  NULL,
    [CATEGORY_OF_SVC]         VARCHAR (50)  NULL,
    [PAT_CONTROL_NO]          VARCHAR (50)  NULL,
    [ICD_PRIM_DIAG]           VARCHAR (10)  NULL,
    [PRIMARY_SVC_DATE]        DATE          NULL,
    [SVC_TO_DATE]             DATE          NULL,
    [CLAIM_THRU_DATE]         DATE          NULL,
    [POST_DATE]               DATETIME      NULL,
    [CHECK_DATE]              DATETIME      NULL,
    [CHECK_NUMBER]            VARCHAR (20)  NULL,
    [DATE_RECEIVED]           DATETIME      NULL,
    [ADJUD_DATE]              DATETIME      NULL,
    [CMS_CertificationNumber] VARCHAR (12)  NULL,
    [SVC_PROV_ID]             VARCHAR (20)  NULL,
    [SVC_PROV_FULL_NAME]      VARCHAR (250) NULL,
    [SVC_PROV_NPI]            VARCHAR (20)  NULL,
    [PROV_SPEC]               VARCHAR (20)  NULL,
    [PROV_TYPE]               VARCHAR (20)  NULL,
    [PROVIDER_PAR_STAT]       VARCHAR (20)  NULL,
    [ATT_PROV_ID]             VARCHAR (50)  NULL,
    [ATT_PROV_FULL_NAME]      VARCHAR (250) NULL,
    [ATT_PROV_NPI]            VARCHAR (20)  NULL,
    [REF_PROV_ID]             VARCHAR (20)  NULL,
    [REF_PROV_FULL_NAME]      VARCHAR (250) NULL,
    [VENDOR_ID]               VARCHAR (20)  NULL,
    [VEND_FULL_NAME]          VARCHAR (250) NULL,
    [IRS_TAX_ID]              VARCHAR (20)  NULL,
    [DRG_CODE]                VARCHAR (20)  NULL,
    [BILL_TYPE]               VARCHAR (20)  NULL,
    [ADMISSION_DATE]          DATE          NULL,
    [AUTH_NUMBER]             VARCHAR (50)  NULL,
    [ADMIT_SOURCE_CODE]       VARCHAR (20)  NULL,
    [ADMIT_HOUR]              VARCHAR (20)  NULL,
    [DISCHARGE_HOUR]          VARCHAR (20)  NULL,
    [PATIENT_STATUS]          VARCHAR (20)  NULL,
    [CLAIM_STATUS]            VARCHAR (20)  NULL,
    [PROCESSING_STATUS]       VARCHAR (20)  NULL,
    [CLAIM_TYPE]              VARCHAR (20)  NULL,
    [TOTAL_BILLED_AMT]        MONEY         NULL,
    [TOTAL_PAID_AMT]          MONEY         NULL,
    [SrcAdiTableName]         VARCHAR (100) NULL,
    [SrcAdiKey]               INT           NOT NULL,
    [LoadDate]                DATETIME      NOT NULL,
    [CreatedDate]             DATETIME      CONSTRAINT [DF__Claims_He__Creat__01142BA1] DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]               VARCHAR (50)  CONSTRAINT [DF__Claims_He__Creat__02084FDA] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]         DATETIME      CONSTRAINT [DF__Claims_He__LastU__02FC7413] DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]           VARCHAR (50)  CONSTRAINT [DF__Claims_He__LastU__03F0984C] DEFAULT (suser_sname()) NOT NULL,
    [CalcdTotalBilledAmount]  MONEY         DEFAULT ((0)) NULL,
    [BENE_PTNT_STUS_CD]       INT           NULL,
    [DISCHARGE_DISPO]         INT           NULL,
    CONSTRAINT [PK_Claims_Headers_SeqClaimId] PRIMARY KEY CLUSTERED ([SEQ_CLAIM_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_ClaimsHeaderSeqClaimIdDrgCodePrimarySvcDate]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC, [DRG_CODE] ASC, [PRIMARY_SVC_DATE] ASC)
    INCLUDE([SUBSCRIBER_ID], [CATEGORY_OF_SVC], [SVC_TO_DATE], [CLAIM_THRU_DATE], [PROV_SPEC], [VEND_FULL_NAME], [IRS_TAX_ID], [BILL_TYPE], [ADMISSION_DATE], [CLAIM_TYPE], [TOTAL_BILLED_AMT], [TOTAL_PAID_AMT]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SubscriberID]
    ON [adw].[Claims_Headers]([SUBSCRIBER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NDX_ClmsHdr_SubID_PrimSvcDt]
    ON [adw].[Claims_Headers]([SUBSCRIBER_ID] ASC, [PRIMARY_SVC_DATE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [ADMISSION_DATE]);


GO
CREATE NONCLUSTERED INDEX [ndx_ClmHdr_ClaimType]
    ON [adw].[Claims_Headers]([CLAIM_TYPE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [CATEGORY_OF_SVC], [ICD_PRIM_DIAG], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [CMS_CertificationNumber], [SVC_PROV_NPI], [ATT_PROV_NPI], [VENDOR_ID], [VEND_FULL_NAME], [IRS_TAX_ID], [DRG_CODE], [BILL_TYPE], [ADMISSION_DATE], [TOTAL_BILLED_AMT], [TOTAL_PAID_AMT], [DISCHARGE_DISPO]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_DrgCode]
    ON [adw].[Claims_Headers]([DRG_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHeader_ProvSpec]
    ON [adw].[Claims_Headers]([PROV_SPEC] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [CATEGORY_OF_SVC], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [CLAIM_THRU_DATE], [ADMISSION_DATE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SeqClmId]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC)
    INCLUDE([SUBSCRIBER_ID], [PRIMARY_SVC_DATE], [CLAIM_THRU_DATE], [PROV_SPEC], [ADMISSION_DATE], [CATEGORY_OF_SVC], [SVC_TO_DATE]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_17_1255727576__K1_K7_K2_K30]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC, [PRIMARY_SVC_DATE] ASC, [SUBSCRIBER_ID] ASC, [DRG_CODE] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_17_1255727576__K7_K1_K30_K2]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE] ASC, [SEQ_CLAIM_ID] ASC, [DRG_CODE] ASC, [SUBSCRIBER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_17_1255727576__K7_K1_K30_2_4_8_9_19_28_29_31_32_40_41_42]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE] ASC, [SEQ_CLAIM_ID] ASC, [DRG_CODE] ASC)
    INCLUDE([SUBSCRIBER_ID], [CATEGORY_OF_SVC], [SVC_TO_DATE], [CLAIM_THRU_DATE], [PROV_SPEC], [VEND_FULL_NAME], [IRS_TAX_ID], [BILL_TYPE], [ADMISSION_DATE], [CLAIM_TYPE], [TOTAL_BILLED_AMT], [TOTAL_PAID_AMT]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_17_1255727576__K1_K8_K40_K7_K2_18_19]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC, [SVC_TO_DATE] ASC, [CLAIM_TYPE] ASC, [PRIMARY_SVC_DATE] ASC, [SUBSCRIBER_ID] ASC)
    INCLUDE([SVC_PROV_NPI], [PROV_SPEC]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_17_1255727576__K1_K2_K7_K8_K40_18_19]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC, [SUBSCRIBER_ID] ASC, [PRIMARY_SVC_DATE] ASC, [SVC_TO_DATE] ASC, [CLAIM_TYPE] ASC)
    INCLUDE([SVC_PROV_NPI], [PROV_SPEC]);


GO
CREATE STATISTICS [_dta_stat_130099504_9_2]
    ON [adw].[Claims_Headers]([CLAIM_THRU_DATE], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1853249657_1_7_8_29_2]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [DRG_CODE], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1853249657_1_29_2_7]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [DRG_CODE], [SUBSCRIBER_ID], [PRIMARY_SVC_DATE]);


GO
CREATE STATISTICS [_dta_stat_1853249657_1_7_31_29]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [ADMISSION_DATE], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1853249657_1_7_2_8]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [SUBSCRIBER_ID], [SVC_TO_DATE]);


GO
CREATE STATISTICS [_dta_stat_1853249657_31_1]
    ON [adw].[Claims_Headers]([ADMISSION_DATE], [SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_1853249657_7_29_1_2_31_8]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE], [DRG_CODE], [SEQ_CLAIM_ID], [SUBSCRIBER_ID], [ADMISSION_DATE], [SVC_TO_DATE]);


GO
CREATE STATISTICS [_dta_stat_1853249657_8_1]
    ON [adw].[Claims_Headers]([SVC_TO_DATE], [SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_1255727576_7_2_30]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE], [SUBSCRIBER_ID], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_1_8_30_40]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [SVC_TO_DATE], [DRG_CODE], [CLAIM_TYPE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_8_7_2]
    ON [adw].[Claims_Headers]([SVC_TO_DATE], [PRIMARY_SVC_DATE], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1255727576_8_40_7_18_2]
    ON [adw].[Claims_Headers]([SVC_TO_DATE], [CLAIM_TYPE], [PRIMARY_SVC_DATE], [SVC_PROV_NPI], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1255727576_7_8_30_40]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE], [SVC_TO_DATE], [DRG_CODE], [CLAIM_TYPE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_40_1_7_8_30]
    ON [adw].[Claims_Headers]([CLAIM_TYPE], [SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_1_8_40_7_18_2]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [SVC_TO_DATE], [CLAIM_TYPE], [PRIMARY_SVC_DATE], [SVC_PROV_NPI], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1255727576_1_30_2_18_27_7_8]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [DRG_CODE], [SUBSCRIBER_ID], [SVC_PROV_NPI], [VENDOR_ID], [PRIMARY_SVC_DATE], [SVC_TO_DATE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_2_8_40_7]
    ON [adw].[Claims_Headers]([SUBSCRIBER_ID], [SVC_TO_DATE], [CLAIM_TYPE], [PRIMARY_SVC_DATE]);


GO
CREATE STATISTICS [_dta_stat_1255727576_1_2_18_7_8]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [SVC_PROV_NPI], [PRIMARY_SVC_DATE], [SVC_TO_DATE]);


GO
CREATE TRIGGER adw.ClaimsHeaders_AfterUpdate
ON adw.Claims_Headers
AFTER UPDATE 
AS
   UPDATE adw.Claims_Headers
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Headers.SEQ_CLAIM_ID = i.SEQ_CLAIM_ID;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'based on the Claim Type', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Headers', @level2type = N'COLUMN', @level2name = N'CATEGORY_OF_SVC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique Patient Identifier Number', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Headers', @level2type = N'COLUMN', @level2name = N'PAT_CONTROL_NO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'From CMS Provider specialty List', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Headers', @level2type = N'COLUMN', @level2name = N'PROV_SPEC';

