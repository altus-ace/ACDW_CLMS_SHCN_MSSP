
CREATE PROCEDURE [adw].[zz_Load_Pdw_03_LatestEffectiveClmsHeaderV2]
AS 
	/* PURPOSE: Get Latest Claims Header Seq_claims_id 
			 1. take all claims that are deduplicated, and have a seq Claim id
			 2. order by activity_date desc 
			 
			 FOR ECAP: THIS FX is redundant. This is being taken care of at the  DeDupClmsHdr/ClmsKeyList level*/

	DECLARE @LoadDate DATE = GETDATE()
	DECLARE @lLoadDate Date;
	SET @lLoadDate = @LoadDate;

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- AST load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaim'
    DECLARE @DestName VARCHAR(100) = 'ast.pstLatestEffectiveClmsHdr'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
		FROM (SELECT csk.clmSKey, ch.MSSPPartAClaimKey
				, ROW_NUMBER() OVER (PARTITION BY csk.clmSKey, ch.ClaimTypeCD ORDER BY ch.ProcessingDTS desc, ch.AdjustmentTypeCD DESC) LastEffective
				FROM ast.ClaimHeader_02_ClaimSuperKey csk
				JOIN adi.Steward_MSSPPartAClaim ch ON csk.PRVDR_OSCAR_NUM = ch.CMSCertificationNBR
	   				AND csk.BENE_EQTBL_BIC_HICN_NUM = ch.MedicareBeneficiaryID
					AND csk.PRVDR_OSCAR_NUM = ch.CMSCertificationNBR
	   				AND csk.CLM_FROM_DT = ch.ClaimStartDTS
	   				and csk.CLM_THRU_DT = ch.ClaimEndDTS
				JOIN ast.ClaimHeader_01_Deduplicate ddH ON ch.MSSPPartAClaimKey = ddH.SrcAdiKey	   
			) src
			WHERE src.LastEffective = 1;
          
    --EXEC amd.sp_AceEtlAudit_Open 
	--	  @AuditID = @AuditID OUTPUT
    --    , @AuditStatus = @JobStatus
    --    , @JobType = @JobType
    --    , @ClientKey = @ClientKey
    --    , @JobName = @JobName
    --    , @ActionStartTime = @ActionStart
    --    , @InputSourceName = @SrcName
    --    , @DestinationName = @DestName
    --    , @ErrorName = @ErrorName
    --    ;
    CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL, ReplacesAdiKey VARCHAR(50) NOT NULL, PRIMARY KEY (ID, ReplacesAdiKey) );	
    TRUNCATE TABLE ast.ClaimHeader_03_LatestEffectiveClaimsHeaderV2;

    INSERT INTO [ast].[ClaimHeader_03_LatestEffectiveClaimsHeaderV2]
           ([clmSKey],[LatestClaimAdiKey],[LatestClaimID],[ReplacesAdiKey],[ReplacesClaimID],[ProcessDate],[ClaimAdjCode],[LatestClaimRankNum])
    OUTPUT INSERTED.clmSKey, inserted.ReplacesAdiKey INTO #OutputTbl(ID, ReplacesAdiKey)
    SELECT csk.clmSKey, ch.MSSPPartAClaimKey LatestClaimAdiKey, ch.ClaimID AS LastestClaimID
		  , ch.MSSPPartAClaimKey ReplacesClaimAdiKey, ch.ClaimID AS ReplacesClaimID
		  , ch.ProcessingDTS , ch.AdjustmentTypeCD
	       , ROW_NUMBER() OVER (PARTITION BY csk.clmSKey ORDER BY ch.ProcessingDTS desc, ch.AdjustmentTypeCD DESC) LastClaimRank
    FROM ast.ClaimHeader_02_ClaimSuperKey csk
	   JOIN adi.Steward_MSSPPartAClaim ch ON csk.PRVDR_OSCAR_NUM = ch.CMSCertificationNBR
		  AND csk.BENE_EQTBL_BIC_HICN_NUM = ch.MedicareBeneficiaryID
		  AND csk.PRVDR_OSCAR_NUM = ch.CMSCertificationNBR
		  AND csk.CLM_FROM_DT = ch.ClaimStartDTS
		  AND csk.CLM_THRU_DT = ch.ClaimEndDTS
	   JOIN ast.ClaimHeader_01_Deduplicate ddH ON ch.MSSPPartAClaimKey = ddH.SrcAdiKey	;
    
    /* TRANSFORM: Remove ClaimsAdjCode Max = 1. These are the cancelled claims. 
	   These rows will not be loaded, so the Latest adikey and ClaimId will be 0 */
    MERGE [ast].[ClaimHeader_03_LatestEffectiveClaimsHeaderV2] TRG
    USING(    SELECT stg.clmSKey
			 FROM (    SELECT Stg.clmSKey, MAX(stg.ClaimAdjCode) MaxAdjCode
					   FROM ast.[ClaimHeader_03_LatestEffectiveClaimsHeaderV2] stg
					   GROUP BY stg.clmSKey
				    ) stg
			 WHERE stg.MaxAdjCode = 1
			 ) SRC
    ON TRG.clmSkey = SRC.clmSKey 
    WHEN MATCHED THEN
	   UPDATE SET TRG.LatestClaimAdiKey = 0
		  ,TRG.LatestClaimID = 0
    ;

    
    /* TRANSFORM:  Set the Latest Adikey and ClaimID to the lastest calcd values */
    MERGE ast.ClaimHeader_03_LatestEffectiveClaimsHeaderV2 TRG
    USING ( SELECT stg.clmSKey, stg.LatestClaimAdiKey, stg.LatestClaimID
		  FROM ast.ClaimHeader_03_LatestEffectiveClaimsHeaderV2 stg
		  WHERE stg.LatestClaimAdiKey <> 0 -- Cancelled claims Removed from UPDATE SET in previous transform 
			 AND stg.LatestClaimRankNum = 1
		  ) SRC
    ON TRG.clmsKey = SRC.clmsKey
    WHEN MATCHED THEN
	   UPDATE SET TRG.LatestClaimAdiKey = SRC.LatestClaimAdiKey
		  , TRG.LatestClaimID = SRC.LatestCLaimID
    ;
    
    	
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl;
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	--EXEC amd.sp_AceEtlAudit_Close 
     --   @AuditId = @AuditID
     --   , @ActionStopTime = @ActionStart
     --   , @SourceCount = @InpCnt		  
     --   , @DestinationCount = @OutCnt
     --   , @ErrorCount = @ErrCnt
     --   , @JobStatus = @JobStatus
	--   ;
