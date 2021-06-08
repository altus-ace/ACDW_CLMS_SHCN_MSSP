
CREATE PROCEDURE [adw].[zz_Load_Pdw_02_ClaimsSuperKeyV2]
/* PURPOSE:  Create a ClaimNumber. : list of business key fields and the calculated seq_claim_id 
		  We also do filtering for "ace valid cliams" here

		  THIS IS AT THE GRAIN OF THE DETAIL
    */
AS 
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
    DECLARE @DestName VARCHAR(100) = 'ast.pstCclfClmKeyList'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartAClaim S
		JOIN ast.ClaimHeader_01_Deduplicate ddH ON s.MSSPPartAClaimKey = ddH.SrcAdiKey ; -- count all rows 
          
--    EXEC amd.sp_AceEtlAudit_Open 
--        @AuditID = @AuditID OUTPUT
--        , @AuditStatus = @JobStatus
--        , @JobType = @JobType
--        , @ClientKey = @ClientKey
--        , @JobName = @JobName
--        , @ActionStartTime = @ActionStart
--        , @InputSourceName = @SrcName
--        , @DestinationName = @DestName
--        , @ErrorName = @ErrorName
--        ;
	CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL PRIMARY KEY);	

    TRUNCATE TABLE ast.ClaimHeader_02_ClaimSuperKeyV2;
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.ClaimHeader_02_ClaimSuperKeyV2(
	   clmSKey
	   , PRVDR_OSCAR_NUM
	   , BENE_EQTBL_BIC_HICN_NUM
	   , CLM_FROM_DT
	   , CLM_THRU_DT
	   , ClaimTypeCode
	   , LoadDate)
	OUTPUT Inserted.clmsKey INTO #OutputTbl(ID)
    SELECT distinct 
		--S.CMSCertificationNBR +'.'+S.MedicareBeneficiaryID+'.'+convert(varchar(10), S.ClaimStartDTS,101)+'.'+CONVERT(varchar(10), S.ClaimEndDTS,101) AS clmBigKey
		S.CMSCertificationNBR +S.MedicareBeneficiaryID+convert(char(8), S.ClaimStartDTS, 112)+CONVERT(char(8), S.ClaimEndDTS,112)+S.ClaimTypeCD AS clmBigKey
	   ,S.CMSCertificationNBR 
	   , s.MedicareBeneficiaryID
	   ,S.ClaimStartDTS
	   ,S.ClaimEndDTS --, S.UmbrellaHealthInsuranceClaimNBR	   , s.claimID
	   , S.ClaimTypeCD
	   ,GetDate()
    FROM adi.Steward_MSSPPartAClaim S
		JOIN ast.ClaimHeader_01_Deduplicate ddH ON s.MSSPPartAClaimKey = ddH.SrcAdiKey  -- 375849
    
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
--	EXEC amd.sp_AceEtlAudit_Close 
--        @AuditId = @AuditID
--        , @ActionStopTime = @ActionStart
--        , @SourceCount = @InpCnt		  
--        , @DestinationCount = @OutCnt
--        , @ErrorCount = @ErrCnt
--        , @JobStatus = @JobStatus
--	   ;
