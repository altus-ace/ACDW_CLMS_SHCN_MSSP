
CREATE PROCEDURE [adw].[Load_Pdw_14_ClmsDiagsCclf4]
AS 
   
   /* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimDiagnosisCode'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Diags'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartAClaimDiagnosisCode cp 		
        JOIN ast.ClaimHeader_02_ClaimSuperKey ck ON ck.PRVDR_OSCAR_NUM		= cp.CMSCertificationNBR
			AND ck.BENE_EQTBL_BIC_HICN_NUM						= cp.MedicareBeneficiaryID --commented it while it ran, output is zero when not commented
			AND ck.CLM_FROM_DT									= cp.ClaimStartDTS
			and ck.CLM_THRU_DT									= cp.ClaimEndDTS
        JOIN ast.pstcDgDeDupUrns  dd		   
			ON cp.MSSPPartAClaimDiagnosisCodeKey = dd.urn --select * from ast.pstcDgDeDupUrns where urn = '4177560' select * FROM adi.Steward_MSSPPartAClaimDiagnosisCode 
        JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr   
			ON ck.clmSKey = lr.clmSKey
				AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
        JOIN adi.Steward_MSSPPartAClaim ch	   
			ON lr.LatestClaimAdiKey = ch.[MSSPPartAClaimKey]		
		;

	EXEC amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @JobStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStart
        , @InputSourceName = @SrcName
        , @DestinationName = @DestName
        , @ErrorName	   = @ErrorName
        ;
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
    INSERT INTO  adw.Claims_Diags
           ([SEQ_CLAIM_ID]
           ,[SUBSCRIBER_ID]
           ,[ICD_FLAG]
           ,[diagNumber]
           ,[diagCode]
           ,[diagPoa]
		   ,LoadDate
		   ,SrcAdiTableName
		   ,SrcAdiKey)
	OUTPUT INSERTED.URN INTO #OutputTbl(ID)
    SELECT cp.ClaimID							AS SEQ_CLAIM_ID   
			,cp.MedicareBeneficiaryID			AS SUBSCRIBER_ID
			,cp.ICDRevisionCD					AS ICD_FLAG   
			,cp.ICDDiagnosisSEQ					AS diagNumber     
			,cp.ICDDiagnosisCD					AS diagCode      
			,cp.PresentOnAdmitCD				AS diagPoa        
			,getdate()							AS LoadDate
			,'Steward_MSSPPartAClaimDiagnosisCode'	AS SrcAdiTableName
			,cp.MSSPPartAClaimDiagnosisCodeKey	AS SrcAdiKey
			-- Implicit: CreatedDate,	CreatedBy,LastUpdatedDate,LastUpdatedBy	
     FROM adi.Steward_MSSPPartAClaimDiagnosisCode cp 		
        JOIN ast.ClaimHeader_02_ClaimSuperKey ck ON ck.PRVDR_OSCAR_NUM		= cp.CMSCertificationNBR
			AND ck.BENE_EQTBL_BIC_HICN_NUM						= cp.MedicareBeneficiaryID --commented it while it ran, output is zero when not commented
			AND ck.CLM_FROM_DT									= cp.ClaimStartDTS
			and ck.CLM_THRU_DT									= cp.ClaimEndDTS
        JOIN ast.pstcDgDeDupUrns  dd		   
			ON cp.MSSPPartAClaimDiagnosisCodeKey = dd.urn --select * from ast.pstcDgDeDupUrns where urn = '4177560' select * FROM adi.Steward_MSSPPartAClaimDiagnosisCode 
        JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr   
			ON ck.clmSKey = lr.clmSKey
				AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
        JOIN adi.Steward_MSSPPartAClaim ch	   
			ON lr.LatestClaimAdiKey = ch.[MSSPPartAClaimKey]		
    ORDER BY cp.ClaimID, cp.ICDDiagnosisSEQ;

	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
		  @AuditId = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;
