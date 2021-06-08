
CREATE PROCEDURE adw.Load_Pdw_13_ClmsProcsCclf3
AS
    --Task 3 Insert Proc: -- Insert to proc    
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimProcedureCode'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Procs'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartAClaimLineItem cl
		JOIN ast.ClaimHeader_02_ClaimSuperKey ck ON ck.PRVDR_OSCAR_NUM = cl.CMSCertificationNBR
			AND ck.BENE_EQTBL_BIC_HICN_NUM	= cl.MedicareBeneficiaryID
            AND ck.CLM_FROM_DT				= cl.ClaimStartDTS
            AND ck.CLM_THRU_DT				= cl.ClaimEndDTS		  
		JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr 
			ON ck.clmSKey = lr.clmSKey
				AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
        JOIN adi.Steward_MSSPPartAClaim ch 
			ON lr.LatestClaimAdiKey = ch.MSSPPartAClaimKey;

	EXEC amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @JobStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStart
        , @InputSourceName = @SrcName
        , @DestinationName = @DestName
        , @ErrorName = @ErrorName
        ;
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
    INSERT INTO adw.Claims_Procs
               (SEQ_CLAIM_ID
				,SUBSCRIBER_ID
				,ProcNumber
				,ProcCode
				,ProcDate
				,LoadDate
				,SrcAdiTableName
				,SrcAdiKey
				-- implicit: ,CreatedDate ,CreatedBy,LastUpdatedDate,LastUpdatedBy
				)	
	OUTPUT Inserted.URN INTO #OutputTbl(ID)
    SELECT cp.ClaimID						AS SEQ_CLAIM_ID
        , cp.MedicareBeneficiaryID			AS subscriberID
        , cp.ICDProcedureSEQ				AS ProcNum
        , cp.ICDProcedureCD					AS ProcCode
        , cp.ICDProcedureDTS				AS ProcDate
		, getdate()							AS LoadDate
		, 'Steward_MSSPPartAClaimProcedureCode' AS SrcAdiTableName
		, MSSPPartAClaimProcedureCodeKey	AS SrcAdiKey
		-- implicit: 	CreatedDate,CreatedBy,LastUpdatedDate,LastUpdatedBy
    FROM adi.Steward_MSSPPartAClaimProcedureCode cp
        JOIN ast.ClaimHeader_02_ClaimSuperKey ck ON ck.[PRVDR_OSCAR_NUM]  = cp.CMSCertificationNBR
    		  AND ck.[BENE_EQTBL_BIC_HICN_NUM]	    = cp.MedicareBeneficiaryID
    		  AND ck.CLM_FROM_DT			    = cp.ClaimStartDTS
    		  and ck.CLM_THRU_DT			    = cp.ClaimEndDTS
        JOIN ast.pstcPrcDeDupUrns  dd 
			ON cp.MSSPPartAClaimProcedureCodeKey = dd.urn
        JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr 
			ON ck.clmSKey = lr.clmSKey
			and lr.LatestClaimAdiKey = lr.ReplacesAdiKey
        JOIN adi.Steward_MSSPPartAClaim ch 
			ON lr.LatestClaimAdiKey = ch.MSSPPartAClaimKey				
    ORDER BY cp.ClaimID, cp.ICDProcedureSEQ;

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
