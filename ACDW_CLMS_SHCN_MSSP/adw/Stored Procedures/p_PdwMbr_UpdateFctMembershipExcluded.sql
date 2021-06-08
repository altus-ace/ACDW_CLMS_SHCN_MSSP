CREATE PROCEDURE adw.p_PdwMbr_UpdateFctMembershipExcluded( @LoadDate DATE)
AS 
    SET NOCOUNT ON
    SET XACT_ABORT ON
  /* Load BENEX Process  
	   1. document in profile addition of this function to process BENEX
	       PROCEDURE adw.p_PdwMbr_UpdateFctMembershipExcluded( @LoadDate DATE)  -- loadDate is the 15th of the month being loadeed
	   2.  create staging table if it doesn't exist 
	   3. TRUNCATE TABLE stging
	   4. load working data from quarterly and monthly sources
	   5. UPdate fctMembership where exclusion is set, and set active = 0
	   6. log : count rows updated and write to summary log, this should also send data to the multi-source lineage log		  
    */
    --declare @loaddate date = '1/15/2021'

     /* 2 Log LOAD */        
    --SELECT * FROM AceMetaData.lst.ListTypes
    --SELECT * FROM AceMetaData.lst.ListValues
    DECLARE @AuditID INT ;    
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed, 3 fail
    DECLARE @JobType SmallInt = 12	   -- 5 ETLData, 6 ExportData, 7 adi, 8 adw, 9ast 10 ast trans, 11 st valid, 12 adw trans
    DECLARE @ClientKey INT	=   16 -- SHCN_MSSP
    DECLARE @JobName VARCHAR(200) = OBJECT_NAME(@@PROCID)  -- if it is the procedure name
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + '.adi.Steward_MSSPBeneficiaryExclusion';    
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.adw.fctMembership';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided'	;
    DECLARE @SourceCount int;     
    DECLARE @DestinationCount int;	     
    DECLARE @ErrorCount int = 0
    /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME;
    Declare @Output table (ID INT PRIMARY KEY NOT NULL)

    /* create staging table if it doesn't exist */
    IF OBJECT_ID('ast.MbrBenExclusion_Working', 'U') IS NULL 
	   CREATE TABLE ast.MbrBenExclusion_Working (
	       Skey INT NOT NULL PRIMARY KEY IDENTITY(1,1) 
	       , adiKey iNT NOT NULL
	       , adiTableName VARCHAR(100)
	       , CreatedDate DATETIME DEFAULT(getDate())
	       , CreatedBy VARCHAR(50) DEFAULT(SYSTEM_USER)
	       , MedicareBeneficiaryID VARCHAR(20)
	       , PerformanceYearNbr INT
	       , ReportMonthNbr INT
	       , ExcludedFlg tinyINT 
	       );

    TRUNCATE TABLE ast.MbrBenExclusion_Working;
    
    BEGIN TRY
	   BEGIN TRAN UpdateFctMemberBenEx
	   
        /* get exclustions from 2 sources */
        INSERT INTO ast.MbrBenExclusion_Working(MedicareBeneficiaryID, PerformanceYearNbr, ReportMonthNbr, ExcludedFlg, adiKey, adiTableName)
        SELECT src.MedicareBeneficiaryID, src.YearNbr AS PerformanceYearNBR, src.QuarterNbr AS ReportMonthNBR, src.ExcludedFLG , adiKey, adiTableName
        FROM ( SELECT YearNbr, QuarterNbr, be.MedicareBeneficiaryID, be.ExcludedFLG, be.MSSPQtrExclusionsBNEXKey adiKey, 'Steward_MSSPQtrExclusionsBNEX' AdiTableName
    	   	  , ROW_NUMBER() OVER(PARTITION BY be.MedicareBeneficiaryID ORDER BY BE.YearNbr ASC,  QuarterNbr ASC) ARN
    		  FROM adi.Steward_MSSPQtrExclusionsBNEX be
    		  WHERE be.ExcludedFLG = 1
    		  ) src
        WHERE src.ARN = 1;
        
       /* get a set of Exclusions, load into working table */
        INSERT INTO ast.MbrBenExclusion_Working(MedicareBeneficiaryID, PerformanceYearNbr, ReportMonthNbr, ExcludedFlg, adiKey, adiTableName)
        SELECT src.MedicareBeneficiaryID, src.PerformanceYearNBR, src.ReportMonthNBR, 1 ExcludedFLG, adiKey, adiTableName
        FROM (SELECT distinct be.MedicareBeneficiaryID, DataDate, PerformanceYearNBR, ReportMonthNBR, Reason01CD 
        	   , be.MSSPBeneficiaryExclusionKey AdiKey, 'Steward_MSSPBeneficiaryExclusion' adiTableName
        	   , ROW_NUMBER() OVER (PARTITION BY be.MedicareBeneficiaryID ORDER BY BE.PerformanceYearNbr ASC, ReportMonthNbr ASC) ARN
            FROM adi.Steward_MSSPBeneficiaryExclusion be
            where be.Reason01CD = 'BD'
            ) src 
        WHERE src.ARN = 1;
        COMMIT TRAN UpdateFctMemberBenEx        
    END TRY
    BEGIN CATCH
	   SELECT ERROR_MESSAGE()
        IF @@TRANCOUNT>0 
		  ROLLBACK
    END CATCH;
   
    SELECT @SourceCount = COUNT(distinct w.MedicareBeneficiaryID) FROM ast.MbrBenExclusion_Working w ;
    EXEC amd.sp_AceEtlAudit_Open
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @AuditStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStartTime
        , @InputSourceName = @InputSourceName
        , @DestinationName = @DestinationName
        , @ErrorName = @ErrorName      
	   ; 
    BEGIN TRY
	   BEGIN TRAN UpdateFctMemberBenEx        
	   --SELECT w.MedicareBeneficiaryID  , w.ExcludedFlg, mbr.FctMembershipSkey, mbr.Excluded, mbr.Active
        UPDATE mbr set mbr.Excluded = w.ExcludedFlg ,mbr.Active = 0 -- deactivate members 
	   OUTPUT INSERTED.FctMembershipSkey INTO @Output
	   FROM ast.MbrBenExclusion_Working w
		  JOIN adw.FctMembership mbr 
    		  ON w.MedicareBeneficiaryID = mbr.ClientMemberKey	
	   	  AND @LoadDate BETWEEN mbr.RwEffectiveDate and mbr.RwExpirationDate
	   ;
    COMMIT TRAN UpdateFctMemberBenEx        
    END TRY
    BEGIN CATCH
	   SELECT ERROR_MESSAGE()
        IF @@TRANCOUNT>0 
		  ROLLBACK
    END CATCH;

    SET @ActionStopTime = getdate();	   
    SET @AuditStatus = 2;
    SELECT @DestinationCount = COUNT(id) FROM @Output;

    EXEC amd.sp_AceEtlAudit_Close 
	   @AuditId = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @AuditStatus
		  ;
    

