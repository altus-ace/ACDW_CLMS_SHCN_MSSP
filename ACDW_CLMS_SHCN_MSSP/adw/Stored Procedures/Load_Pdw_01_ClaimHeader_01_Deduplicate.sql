CREATE PROCEDURE [adw].[Load_Pdw_01_ClaimHeader_01_Deduplicate]
AS
	-- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
	-- Ensure records loaded tallies with cclf1 records (validation)
    DECLARE @DataDate DATE;

    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaim'
    DECLARE @DestName VARCHAR(100) = 'ast.PstDeDupClmsHdr'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @DataDate = MAX(DataDate)
	    FROM adi.Steward_MSSPPartAClaim;
	
    SELECT @InpCnt = COUNT(*) 
	FROM (SELECT ch.MSSPPartAClaimKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
	    FROM adi.Steward_MSSPPartAClaim ch
	    WHERE ch.DataDate <= @DataDate
	    ) s
	WHERE s.arn = 1
	      AND DataDate <= @DataDate; -- count all rows 

	SELECT @InpCnt, @DataDate
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

	TRUNCATE TABLE ast.ClaimHeader_01_Deduplicate;
	
	-- start tran
	
	INSERT INTO ast.ClaimHeader_01_Deduplicate(SrcAdiKey, SeqClaimId, OriginalFileName, LoadDate)
	OUTPUT inserted.SrcAdiKey INTO #OutputTbl(ID)
	SELECT s.MSSPPartAClaimKey, s.ClaimID, s.OriginalFileName, s.datadate
	FROM (SELECT ch.MSSPPartAClaimKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
	    FROM adi.Steward_MSSPPartAClaim ch
	    WHERE ch.DataDate <= @DataDate
	    ) s
	WHERE s.arn = 1
	      AND DataDate <= @DataDate;

    SELECT @OutCnt = COUNT(*) FROM #OutputTbl;
    SET @ActionStart  = GETDATE();
    SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;
