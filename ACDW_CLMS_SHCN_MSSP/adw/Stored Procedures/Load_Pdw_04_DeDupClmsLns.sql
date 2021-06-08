


CREATE PROCEDURE [adw].[Load_Pdw_04_DeDupClmsLns]
AS 
    /* PURPOSE: -- 4. de dup claims details
	    this is ready to be refactored 
		Is it not supposed to be a one to many relationship? this seems to be a one to one relationship....
	   
	   */
	DECLARE @DataDate DATE;

	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'ast.pstcLnsDeDupUrns'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM (SELECT cl.MSSPPartAClaimLineItemKey, cl.OriginalFileName, cl.DataDate--, cl.CUR_CLM_UNIQ_ID , cl.clm_line_Num
				, ROW_NUMBER() OVER (PARTITION BY cl.ClaimID, cl.LineNBR ORDER BY cl.DataDate, cl.OriginalFileName ASC) arn	   
			FROM adi.Steward_MSSPPartAClaimLineItem cl			
				JOIN adi.Steward_MSSPPartAClaim ch 
					ON cl.ClaimID = ch.ClaimID
				JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader 
					ON ch.MSSPPartAClaimKey = LatestEffectiveCHeader.LatestClaimAdiKey
						and LatestEffectiveCHeader.LatestClaimAdiKey = LatestEffectiveCHeader.ReplacesAdiKey						
				) s
    WHERE s.arn = 1;
	
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

    TRUNCATE TABLE ast.pstcLnsDeDupUrns;

    INSERT INTO ast.pstcLnsDeDupUrns (URN)
	OUTPUT INSERTED.URN INTO #OutputTbl(ID)
    SELECT s.MSSPPartAClaimLineItemKey AS URN	
    FROM (SELECT cl.MSSPPartAClaimLineItemKey, cl.OriginalFileName, cl.DataDate--, cl.CUR_CLM_UNIQ_ID , cl.clm_line_Num
				, ROW_NUMBER() OVER (PARTITION BY cl.ClaimID, cl.LineNBR ORDER BY cl.DataDate, cl.OriginalFileName ASC) arn	   
			FROM adi.Steward_MSSPPartAClaimLineItem cl			
				JOIN adi.Steward_MSSPPartAClaim ch 
					ON cl.ClaimID = ch.ClaimID
				JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader		
					ON ch.MSSPPartAClaimKey = LatestEffectiveCHeader.LatestClaimAdiKey
						and LatestEffectiveCHeader.LatestClaimAdiKey = LatestEffectiveCHeader.ReplacesAdiKey
				) s
    WHERE s.arn = 1;


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
