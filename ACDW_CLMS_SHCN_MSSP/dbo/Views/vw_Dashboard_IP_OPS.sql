




CREATE View [dbo].[vw_Dashboard_IP_OPS]

AS
    /* PURPOSE: Get all IP visit details for trailing 12 months */
    /*  VERSION HISTORY
    12/18/2020 GK: Orignal version, doesn't get dates for ER claims and PARAMETER SNIFFING 
	   FROM [adw].[2020_tvf_Get_ipVisits](DATEADD(month, -11,(SELECT MAX(CH.PRIMARY_SVC_DATE)FROM adw.Claims_Headers CH)) ,(SELECT MAX(CH.PRIMARY_SVC_DATE)FROM adw.Claims_Headers CH)) ER
    12/21/2020: changed to use getdate and getdate = - 12 months to eliminate parameter sniffing on tvf 
    */
    Select 
	   CH.[SEQ_CLAIM_ID]
	   ,CH.[SUBSCRIBER_ID]	
	   ,CH.[CATEGORY_OF_SVC]
		   ,CH.[PAT_CONTROL_NO]
		   ,CH.[ICD_PRIM_DIAG]
		   ,CCS.[ICD-10-CM_CODE_DESCRIPTION]
		   ,CCS.MULTI_CCS_LVL1_LABEL
		   ,CCS.MULTI_CCS_LVL2_LABEL
		   ,CH.[PRIMARY_SVC_DATE]
		   ,CH.[SVC_TO_DATE]
		   ,CH.[CLAIM_THRU_DATE]
		   ,CH.[SVC_PROV_ID]
		   ,CH.[SVC_PROV_FULL_NAME]
		   ,CH.[SVC_PROV_NPI]
		   ,CH.[PROV_SPEC]
		   ,CH.[PROV_TYPE]
		 , CH.[ATT_PROV_ID]
		 , CH.[ATT_PROV_FULL_NAME]
		 , CH.[ATT_PROV_NPI]
		, CH.[VENDOR_ID]
		, CH.[VEND_FULL_NAME] as Claims_VEND_NAME 
		,vennpi.LegalBusinessName
	    , CH.[DRG_CODE]
		, DRG.DRG_DESC
		, CH.[BILL_TYPE]
		, CH.[CLAIM_TYPE]
		,CASE WHEN LEFT(RIGHT(IP.[CMS_CertificationNumber],4),2) IN ('20','21','22') AND IP.Claim_Type in ('60','61') THEN 'LTAC' 
			    WHEN LEFT(RIGHT(IP.[CMS_CertificationNumber],4),2) IN ('13') AND IP.Claim_Type in ('60','61') THEN 'IP-CAH' 
			    WHEN LEFT(RIGHT(IP.[CMS_CertificationNumber],4),2) IN ('00','01','02','03','04','05','06','07','08') AND ip.Claim_Type in ('60','61') THEN 'ACUTE' 		
				WHEN IP.CLAIM_TYPE in ('60','61')
				AND (RIGHT(LEFT(IP.[CMS_CertificationNumber],3),1) IN ('R','T') 
				OR RIGHT(IP.[CMS_CertificationNumber],4) IN 
				('3025','3035','3045','3055','3065','3075','3085','3095'
				,'3026','3036','3046','3056','3066','3076','3086','3096'
				,'3027','3037','3047','3057','3067','3077','3087','3097'
				,'3028','3038','3048','3058','3068','3078','3088','3098'
				,'3029','3039','3049','3059','3069','3079','3089','3099'
				,'3030','3040','3050','3060','3070','3080','3090'	
				,'3031','3041','3051','3061','3071','3081','3091'	
				,'3032','3042','3052','3062','3072','3082','3092'	
				,'3033','3043','3053','3063','3073','3083','3093'	
				,'3034','3044','3054','3064','3074','3084','3094'))	
				THEN 'IRF' 
				WHEN IP.CLAIM_TYPE in ('50') THEN 'HOSPICE'
				WHEN IP.CLAIM_TYPE IN ('20','30') THEN 'SNF'
				ELSE 'OTHER' END as InstType
		, CH.[TOTAL_BILLED_AMT]
		, CH.[TOTAL_PAID_AMT] 
		, mbr.[ClientMemberKey]
		, mbr.ClientRiskScore
		, mbr.Contract
		, mbr.DOB
		, mbr.FirstName
		, mbr.LastName
		, mbr.LOB
		, mbr.MBI
		, mbr.NPI
		, mbr.PcpPracticeTIN
		, mbr.PlanName
		, mbr.ProviderChapter
		, mbr.ProviderFirstName
		, mbr.ProviderLastName
		, mbr.ProviderPracticeName
		,mbr.AceRiskScore
	    ,mbr.AceRiskScoreLevel
	    ,mbr.ClientRiskScoreLevel
	    ,mbr.RiskScoreUtilization
	--from [adw].[2020_tvf_Get_IPVisits]  (DATEADD(month,-11, (SELECT MAX(CH.PRIMARY_SVC_DATE) FROM adw.Claims_Headers CH)) , (SELECT MAX(CH.PRIMARY_SVC_DATE) FROM adw.Claims_Headers CH )) IP
	FROM [adw].[2020_tvf_Get_IPVisits] (DATEADD(month,-14, getdate()), GETDATE() ) IP
    	   LEFT JOIN  adw.Claims_Headers CH
		  ON IP.SEQ_CLAIM_ID = CH.SEQ_CLAIM_ID
	   JOIN adw.FctMembership mbr 
		ON IP.SUBSCRIBER_ID = mbr.ClientMemberKey 
		  and (getdate() between mbr.RwEffectiveDate and mbr.RwExpirationDate)
	   LEFT JOIN adw.[2020_tvf_Get_DataFromNPPES] (getdate()) vennpi
		ON CH.VENDOR_ID = vennpi.NPI
	   LEFT JOIN [lst].[List_DRG] DRG on DRG.DRG_CODE = CH.DRG_CODE and DRG.DRG_VER = '37'
	   LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICDCCS] CCS on CCS.[ICD-10-CM_CODE] = CH.ICD_PRIM_DIAG
		  and ccs.EffectiveDate = '2017-01-01'
		  AND ccs.Version = 'ICD10CM'
