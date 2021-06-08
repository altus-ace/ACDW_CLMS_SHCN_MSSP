



CREATE  FUNCTION [adw].[z_2020_tvf_Get_MemberClaimInfo]
(

 @PrimSvcDate_Start VARCHAR(20), 
 @PrimSvcDate_End   VARCHAR(20)
)
RETURNS TABLE
AS RETURN
(
		SELECT hdr.[SEQ_CLAIM_ID]
			  ,hdr.[SUBSCRIBER_ID]
			  ,hdr.[CATEGORY_OF_SVC]
			  ,hdr.[ICD_PRIM_DIAG]
			  ,hdr.[PRIMARY_SVC_DATE]
			  ,hdr.[SVC_TO_DATE]
			  ,hdr.[IRS_TAX_ID]
			  ,hdr.[DRG_CODE]
			  ,hdr.[ADMISSION_DATE]
			  ,hdr.[DISCHARGE_DISPO]
			  ,hdr.[TOTAL_BILLED_AMT]
			  ,hdr.[TOTAL_PAID_AMT]
			  ,hdr.[SVC_PROV_NPI]
			  ,hdr.[ATT_PROV_NPI]
			  ,hdr.[VENDOR_ID]
			  ,hdr.[VEND_FULL_NAME]
			  ,hdr.[CMS_CertificationNumber]
			  ,hdr.[CLAIM_TYPE]
  			  ,hdr.[BILL_TYPE]	-- three-digit codes located on the UB-04 claim form that describe the type of bill a provider is submitting to a payer, such as Medicaid or an insurance company
			  ,LEFT(hdr.BILL_TYPE,1) AS cBILL_TYPE_1	
			  ,hdr.[CLAIM_STATUS]
			  ,hdr.[PROCESSING_STATUS]
			  ,CASE WHEN DATEDIFF(dd, hdr.PRIMARY_SVC_DATE, hdr.SVC_TO_DATE) = 0 THEN 1 ELSE DATEDIFF(dd, hdr.PRIMARY_SVC_DATE, hdr.SVC_TO_DATE) END AS LOS
			  ,ROW_NUMBER () OVER (PARTITION BY hdr.SUBSCRIBER_ID ORDER BY hdr.PRIMARY_SVC_DATE )  AS tRowNum
		FROM [adw].[Claims_Headers] hdr
		WHERE hdr.[CLAIM_TYPE]		IN ('10','20','30','50','60','61')
			AND CONVERT(DATETIME, hdr.PRIMARY_SVC_DATE)	>= 	@PrimSvcDate_Start
			AND CONVERT(DATETIME, hdr.PRIMARY_SVC_DATE)	<=  @PrimSvcDate_End
)

/***
Usage: 
SELECT *
FROM [adw].[z_2020_tvf_Get_MemberClaimInfo] ('01/01/2020','01/31/2020')
WHERE CLAIM_TYPE = '60'

***/

