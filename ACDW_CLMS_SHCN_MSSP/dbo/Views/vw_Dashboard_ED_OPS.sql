





CREATE view [dbo].[vw_Dashboard_ED_OPS]
AS
    /* PURPOSE: Get all ED visit details for trailing 12 months */
    /*  VERSION HISTORY
    12/18/2020 GK: Orignal version, doesn't get dates for ER claims and PARAMETER SNIFFING 
	   FROM [adw].[2020_tvf_Get_ERVisits](DATEADD(month, -11,(SELECT MAX(CH.PRIMARY_SVC_DATE)FROM adw.Claims_Headers CH)) ,(SELECT MAX(CH.PRIMARY_SVC_DATE)FROM adw.Claims_Headers CH)) ER
    12/21/2020 GK: Better version: uses ED visit fact but PARAMETER SNIFFing
	   FROM [adw].[2020_tvf_Get_ERVisits](DATEADD(month, -11, (SELECT MAX(EffectiveAsOfDate) FROM adw.FctEDVisits v)), (SELECT MAX(EffectiveAsOfDate) FROM adw.FctEDVisits v)) ER    
    */
    SELECT CH.[SEQ_CLAIM_ID], 
       CH.[SUBSCRIBER_ID],       
       CH.[CATEGORY_OF_SVC], 
       CH.[PAT_CONTROL_NO], 
       CH.[ICD_PRIM_DIAG], 
       CCS.[ICD-10-CM_CODE_DESCRIPTION], 
       CCS.MULTI_CCS_LVL1_LABEL, 
       CCS.MULTI_CCS_LVL2_LABEL, 
       CH.[PRIMARY_SVC_DATE], 
       CH.[SVC_TO_DATE], 
       CH.[CLAIM_THRU_DATE],       
       CH.[SVC_PROV_ID], 
       CH.[SVC_PROV_FULL_NAME], 
       CH.[SVC_PROV_NPI], 
       CH.[PROV_SPEC], 
       CH.[PROV_TYPE],
       CH.[ATT_PROV_ID], 
       CH.[ATT_PROV_FULL_NAME], 
       CH.[ATT_PROV_NPI],
	  CH.[VENDOR_ID], 
       CH.[VEND_FULL_NAME] AS Claims_VEND_NAME, 
       vennpi.LegalBusinessName AS NPPES_VEND_NAME,       
       CH.[DRG_CODE], 
       DRG.DRG_DESC, 
       CH.[BILL_TYPE],       
       CH.[CLAIM_TYPE], 
       CH.[TOTAL_BILLED_AMT], 
       CH.[TOTAL_PAID_AMT], 
       mbr.[ClientMemberKey], 
       mbr.ClientRiskScore, 
       mbr.Contract, 
       mbr.DOB, 
       mbr.FirstName, 
       mbr.LastName, 
       mbr.LOB, 
       mbr.MBI, 
       mbr.NPI, 
       mbr.PcpPracticeTIN, 
       mbr.PlanName, 
       mbr.ProviderChapter, 
       mbr.ProviderFirstName, 
       mbr.ProviderLastName, 
       mbr.ProviderPracticeName
	   ,mbr.AceRiskScore
	   ,mbr.AceRiskScoreLevel
	   ,mbr.ClientRiskScoreLevel
	   ,mbr.RiskScoreUtilization
    FROM adw.[2020_tvf_Get_ERVisits](dateadd(month, -14, getdate()), getdate()) ER
	   LEFT JOIN  adw.Claims_Headers CH
		  ON ER.SEQ_CLAIM_ID = CH.SEQ_CLAIM_ID
	   JOIN adw.FctMembership mbr 
		  ON ER.SUBSCRIBER_ID = mbr.ClientMemberKey 			 
			 AND ((SELECT Max(RwEffectiveDate) from adw.fctMembership) between mbr.RwEffectiveDate and mbr.RwExpirationDate)  
	   LEFT JOIN adw.[2020_tvf_Get_DataFromNPPES] (getdate()) vennpi 		  ON CH.VENDOR_ID = vennpi.NPI	   
	   LEFT JOIN [lst].[List_DRG] DRG on DRG.DRG_CODE = CH.DRG_CODE and DRG.DRG_VER = '37'
	   LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICDCCS] CCS on CCS.[ICD-10-CM_CODE] = CH.ICD_PRIM_DIAG
		  and ccs.EffectiveDate = '2017-01-01'
		  AND ccs.Version = 'ICD10CM'
