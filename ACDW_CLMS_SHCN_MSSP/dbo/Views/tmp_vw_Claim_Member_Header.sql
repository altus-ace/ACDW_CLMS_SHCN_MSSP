/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW dbo.tmp_vw_Claim_Member_Header
AS
SELECT TOP (1000) [SEQ_CLAIM_ID]
      ,[SUBSCRIBER_ID]
      ,[CLAIM_NUMBER]
      ,[CATEGORY_OF_SVC]
      ,[ICD_PRIM_DIAG]
      ,[PRIMARY_SVC_DATE]
      ,[SVC_TO_DATE]
      ,[SVC_PROV_NPI]
      ,[PROV_SPEC]
      ,[PROV_TYPE]
      ,[DRG_CODE]
      ,[BILL_TYPE]
      ,[CLAIM_TYPE]
      ,[TOTAL_PAID_AMT]
      ,[DISCHARGE_DISPO]
  FROM [ACDW_CLMS_SHCN_MSSP].[adw].[Claims_Headers]