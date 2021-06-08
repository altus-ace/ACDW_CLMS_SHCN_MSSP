
CREATE VIEW adw.vw_Dashboard_NetworkLeakage
AS

    SELECT 
	   CH.SEQ_CLAIM_ID, 
        CH.SUBSCRIBER_ID,               
        CH.CATEGORY_OF_SVC,               
        CH.ICD_PRIM_DIAG, 
	   ICD_PRIM_DIAG.[ICD-10-CM_CODE_DESCRIPTION] AS ICD_PRIM_DIAG_Desc,            
        CH.PRIMARY_SVC_DATE, 		    
    	   CH.SVC_PROV_NPI,   -- hospital or phy 
        CH.SVC_PROV_FULL_NAME,               
        CH.PROV_SPEC, 
    	   PROV_SPEC.CodeDesc AS PROV_SPEC_Desc,
        CH.PROV_TYPE, 	
        CH.PROVIDER_PAR_STAT,               
        CH.VENDOR_ID, 
        CH.VEND_FULL_NAME,               
        CH.DRG_CODE, 
	   DRG_CODE.DRG_DESC ,
        CH.BILL_TYPE, 
        CH.CLAIM_TYPE, 
        CH.TOTAL_BILLED_AMT, 
        CH.TOTAL_PAID_AMT, 
        CH.CalcdTotalBilledAmount,
    	   CASE WHEN ( PCP.PCP_NPI is null) then 'Out of Network'
    		  ELSE 'In Network'
    		  END AS InNetworkStatus    		           
    FROM adw.Claims_Headers CH
        LEFT JOIN lst.List_PCP Pcp ON  CH.SVC_PROV_NPI = PCP.PCP_NPI
        LEFT JOIN lst.LIST_ICDCCS ICD_PRIM_DIAG ON CH.ICD_PRIM_DIAG = ICD_PRIM_DIAG.[ICD-10-CM_CODE]
        LEFT JOIN lst.LIST_PROV_SPECIALTY_CODES PROV_SPEC ON CH.PROV_SPEC = PROV_SPEC.Code 
	   LEFT JOIN lst.List_DRG DRG_CODE ON CH.DRG_CODE = DRG_CODE.DRG_CODE   
    WHERE CH.CATEGORY_OF_SVC = 'PHYSICIAN'
    
    UNION 
    
    SELECT 
	   CH.SEQ_CLAIM_ID, 
        CH.SUBSCRIBER_ID,               
        CH.CATEGORY_OF_SVC,               
        CH.ICD_PRIM_DIAG, 
        ICD_PRIM_DIAG.[ICD-10-CM_CODE_DESCRIPTION] AS ICD_PRIM_DIAG_Desc,            
    	   CH.PRIMARY_SVC_DATE, 		    
    	   CH.SVC_PROV_NPI,   -- hospital or phy 
        CH.SVC_PROV_FULL_NAME,               
        CH.PROV_SPEC, 
    	   PROV_SPEC.CodeDesc AS PROV_SPEC_Desc,
        CH.PROV_TYPE, 		    
        CH.PROVIDER_PAR_STAT,               
        CH.VENDOR_ID, 
        CH.VEND_FULL_NAME,               
        CH.DRG_CODE, 
	   DRG_CODE.DRG_DESC ,
        CH.BILL_TYPE, 
        CH.CLAIM_TYPE, 
        CH.TOTAL_BILLED_AMT, 
        CH.TOTAL_PAID_AMT, 
        CH.CalcdTotalBilledAmount,
    	   CASE WHEN ( Facility.NPI is null) then 'Out of Network'
    		 ELSE 'In Network'
    		 END AS InNetworkStatus    		          
    FROM adw.Claims_Headers CH
        LEFT JOIN lst.lstPreferredFacility Facility ON CH.SVC_PROV_NPI = Facility.NPI
        LEFT JOIN lst.LIST_ICDCCS ICD_PRIM_DIAG ON CH.ICD_PRIM_DIAG = ICD_PRIM_DIAG.[ICD-10-CM_CODE]
        LEFT JOIN lst.LIST_PROV_SPECIALTY_CODES PROV_SPEC ON CH.PROV_SPEC = PROV_SPEC.Code
	   LEFT JOIN lst.List_DRG DRG_CODE ON CH.DRG_CODE = DRG_CODE.DRG_CODE
    WHERE CH.CATEGORY_OF_SVC IN ('INPATIENT', 'OUTPATIENT')

;
