Create PROCEDURE adw.p_AceValidate_CompareCountByCatSvcBYYearMonthAdiAdw
AS 

    DECLARE @MaxPrimSvcDate Date ;
    
    SELECT  @MaxPrimSvcDate =  Max(c.PRIMARY_SVC_DATE) 
    FROM adw.Claims_Headers c;
    
    Declare @Year INT = year(@MaxPrimSvcDate);
    DECLARE @Month TINYINT  = Month(@MaxPrimSvcDate);
    
    SELECT @MaxPrimSvcDate MaxPrimarySvcDate;
    
    
    SELECT 'ClaimsModel' Source,  YEAR(PRIMARY_SVC_DATE) as PrimSvcYear, MONTH(PRIMARY_SVC_DATE) as PrimSvcMth, CATEGORY_OF_SVC as CatOfSvc, COUNT(SEQ_CLAIM_ID) as CntSeqClaimID
    FROM [adw].[Claims_Headers]
           WHERE YEAR(PRIMARY_SVC_DATE) = @Year and Month(PRIMARY_SVC_DATE) = @Month
           GROUP BY YEAR(PRIMARY_SVC_DATE), MONTH(PRIMARY_SVC_DATE), CATEGORY_OF_SVC
           ORDER BY YEAR(PRIMARY_SVC_DATE), MONTH(PRIMARY_SVC_DATE), CATEGORY_OF_SVC
    
    SELECT 'Adi Tables' Source, src.PrimarySvsYear, src.PrimSvcMth, src.CATEGORY_OF_SVC, count(src.ClaimID) as cntSeqClaimID
    FROM (
        select YEAR(c.ClaimStartDTS) AS PrimarySvsYear, Month(c.ClaimStartDTS) AS PrimSvcMth, 
            CASE c.ClaimTypeCD 																
        			WHEN '10' THEN 'OTHER'															
        			WHEN '20' THEN 'OTHER'															
        			WHEN '30' THEN 'OTHER'															
        			WHEN '40' THEN 'OUTPATIENT'														
        			WHEN '50' THEN 'HOSPICE'														
        			WHEN '60' THEN 'INPATIENT'														
        			WHEN '70' THEN 'PHYSICIAN'														
        			WHEN '71' THEN 'PHYSICIAN'														
        			WHEN '72' THEN 'PHYSICIAN'														
        			WHEN '81' THEN 'PHYSICIAN DME'													
        			WHEN '81' THEN 'PHYSICIAN DME'	
        			ELSE c.ClaimTypeCD	END 						AS	CATEGORY_OF_SVC        		
            , c.ClaimID
        from ADI.Steward_MSSPPartAClaim c
        WHERE YEAR(c.ClaimStartDTS) = @Year and Month(c.ClaimStartDTS) = @Month
        UNION all
        select YEAR(c.PrescriptionFillDTS) AS PrimarySvsYear, Month(c.PrescriptionFillDTS) AS PrimSvcMth,
            CASE c.ClaimTypeCD 																
        			WHEN '10' THEN 'OTHER'															
        			WHEN '20' THEN 'OTHER'															
        			WHEN '30' THEN 'OTHER'															
        			WHEN '40' THEN 'OUTPATIENT'														
        			WHEN '50' THEN 'HOSPICE'														
        			WHEN '60' THEN 'INPATIENT'														
        			WHEN '70' THEN 'PHYSICIAN'														
        			WHEN '71' THEN 'PHYSICIAN'														
        			WHEN '72' THEN 'PHYSICIAN'														
        			WHEN '81' THEN 'PHYSICIAN DME'													
        			WHEN '81' THEN 'PHYSICIAN DME'	
        			ELSE c.ClaimTypeCD	END 						AS	CATEGORY_OF_SVC        		
            , c.ClaimID    	   
        from ADI.Steward_MSSPPartDClaimLineItem c    
        WHERE YEAR(c.PrescriptionFillDTS) = @Year and Month(c.PrescriptionFillDTS) = @Month       
        Union all
        select YEAR(c.ClaimStartDTS) AS PrimarySvsYear, Month(c.ClaimStartDTS) AS PrimSvcMth, 
            CASE c.ClaimTypeCD 																
        			WHEN '10' THEN 'OTHER'															
        			WHEN '20' THEN 'OTHER'															
        			WHEN '30' THEN 'OTHER'															
        			WHEN '40' THEN 'OUTPATIENT'														
        			WHEN '50' THEN 'HOSPICE'														
        			WHEN '60' THEN 'INPATIENT'														
        			WHEN '70' THEN 'PHYSICIAN'														
        			WHEN '71' THEN 'PHYSICIAN'														
        			WHEN '72' THEN 'PHYSICIAN'														
        			WHEN '81' THEN 'PHYSICIAN DME'													
        			WHEN '81' THEN 'PHYSICIAN DME'	
        			ELSE c.ClaimTypeCD	END 						AS	CATEGORY_OF_SVC        		
            , c.ClaimID    
        from ADI.Steward_MSSPPartBPhysicianClaimLineItem c
        WHERE YEAR(c.ClaimStartDTS) = @Year and Month(c.ClaimStartDTS) = @Month
    ) src
    GROUP BY src.PrimarySvsYear, src.PrimSvcMth, src.CATEGORY_OF_SVC
    ORDER BY src.PrimarySvsYear, src.PrimSvcMth, src.CATEGORY_OF_SVC
    
