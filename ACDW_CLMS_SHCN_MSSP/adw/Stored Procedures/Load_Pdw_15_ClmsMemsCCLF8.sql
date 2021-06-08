---DONT RUN SP UNTIL VALIDATION FROM ADI
CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8]
AS -- insert Claims.Members

	/* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- Adw load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPBeneficiaryDemographic'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Member'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPBeneficiaryDemographic m    
        JOIN (SELECT src.MedicareBeneficiaryID, src.MSSPBeneficiaryDemographicKey
			 FROM (SELECT c.MedicareBeneficiaryID, c.MSSPBeneficiaryDemographicKey
				    , row_Number() OVER (PARTITION BY c.MedicareBeneficiaryID ORDER BY c.DataDate DESC) arn
				    FROM adi.Steward_MSSPBeneficiaryDemographic c 
				    ) src
			 WHERE src.arn = 1
		  ) s ON m.MSSPBeneficiaryDemographicKey = s.MSSPBeneficiaryDemographicKey;

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
	CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL PRIMARY KEY);	

    INSERT INTO adw.Claims_Member
           (SUBSCRIBER_ID
		   , IsActiveMember
           ,DOB
           ,MEMB_LAST_NAME
           ,MEMB_MIDDLE_INITIAL
           ,MEMB_FIRST_NAME        
		   ,MEDICAID_NO
		   ,MEDICARE_NO
           ,Gender
           ,MEMB_ZIP
		   ,COMPANY_CODE
		   ,LINE_OF_BUSINESS_DESC
		   ,SrcAdiTableName
		   ,SrcAdiKey
		   ,LoadDate
		   )
	OUTPUT inserted.SUBSCRIBER_ID INTO #OutputTbl(ID)
    SELECT 
	   m.MedicareBeneficiaryID				AS SUBSCRIBER_ID		    
		,1									AS IsActiveMember
		,m.BirthDTS							AS DOB				  	   
		,m.LastNM							AS MEMB_LAST_NAME		    
		,m.MiddleNM							AS MEMB_MIDDLE_INITIAL	    
		,m.FirstNM							AS MEMB_FIRST_NAME	    
		, ''								AS MEDICAID_NO
		, m.HealthInsuranceClaimNBR			AS MEDICARE_NO
		,m.SexCD							AS GENDER			    
		,m.ZipCD							AS MEMB_ZIP			    
		,''									AS COMPANY_CODE
		,''									AS LINE_OF_BUSINESS_DESC
		,'Steward_MSSPBeneficiaryDemographic' AS SrcAdiTableName
		, m.MSSPBeneficiaryDemographicKey	AS SrcAdiKey
		, GetDate()							AS LoadDate
		-- implicit: CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy
    FROM adi.Steward_MSSPBeneficiaryDemographic m    
        JOIN (SELECT src.MedicareBeneficiaryID, src.MSSPBeneficiaryDemographicKey
			 FROM (SELECT c.MedicareBeneficiaryID, c.MSSPBeneficiaryDemographicKey
				    , row_Number() OVER (PARTITION BY c.MedicareBeneficiaryID ORDER BY c.DataDate DESC) arn
				    FROM adi.Steward_MSSPBeneficiaryDemographic c 
				    ) src
			 WHERE src.arn = 1
		  ) s ON m.MSSPBeneficiaryDemographicKey = s.MSSPBeneficiaryDemographicKey
	;

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
