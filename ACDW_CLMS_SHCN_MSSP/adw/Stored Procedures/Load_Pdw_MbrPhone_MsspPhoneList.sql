CREATE PROCEDURE [adw].[Load_Pdw_MbrPhone_MsspPhoneList]
AS 
BEGIN

   /* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- SELECT * FROM aceMetaData.lst.ListValues    
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPhonelist'
    DECLARE @DestName VARCHAR(100) = 'adw.MbrPhone'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt =  COUNT(*)
    FROM (SELECT   1 as RowCnt        
		  FROM adi.Steward_MSSPPhonelist PhoneList
		      JOIN lst.lstPhoneCarrierType PhoneCarrierType 
		  	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
		      JOIN lst.lstPhoneType PhoneType 
		  	   ON PhoneType.PhoneTypeCode = 'H'
		  WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
		      AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone)),'') <> ''
		      AND PhoneList.status = 0
		  UNION ALL
		  SELECT   
		     1 AS RowCnt
		  FROM adi.Steward_MSSPPhonelist PhoneList
		      JOIN lst.lstPhoneCarrierType PhoneCarrierType 
		  	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
		      JOIN lst.lstPhoneType PhoneType 
		  	   ON PhoneType.PhoneTypeCode = 'M'
		  WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
		      AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone2)),'') <> ''
		      AND PhoneList.status = 0
		  UNION ALL
		  SELECT   
		      1 AS RowCnt
		  FROM adi.Steward_MSSPPhonelist PhoneList
		      JOIN lst.lstPhoneCarrierType PhoneCarrierType 
		  	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
		      JOIN lst.lstPhoneType PhoneType 
		  	   ON PhoneType.PhoneTypeCode = 'W'
		  WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
		      AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone3)),'') <> ''
		      AND PhoneList.status = 0
	   ) src ;   

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
    CREATE TABLE #OutputTbl (ID int PRIMARY KEY NOT NULL, AdiKey INT);	


    /* 2 Log FACT LOAD */     
    BEGIN TRY         
	   BEGIN TRAN LoadMbrPhone      
        INSERT INTO adw.MbrPhone (mbrLoadkey, EffectiveDate, ExpirationDate, CarrierType, IsPrimary, MbrMemberKey, PhoneNumber, PhoneType
				, SrcAdiKey, SrcAdiTableName, LoadDate, DataDate)
        /* select these insert into adw.MbrPhone */
        --OUTPUT inserted.mbrPhoneKey, inserted.SrcAdiKey INTO #OutputTbl(ID, AdiKey)
        SELECT 
            0								   AS mbrLoadKey     	
            , '1/1/2020'						   AS	EffectiveDate  	
            , '12/31/2099'						   AS  ExpirationDate 	
            ,PhoneCarrierType.lstPhoneCarrierTypeKey    AS  CarrierType    	
            , 0								   AS IsPrimary      	
            , PhoneList.incoming_client			   AS mbrMemberKey   	
            , PhoneList.subj_phone AS mbrPhone	-- What type based on the column being pivoted out
            , PhoneType.lstPhoneTypeKey AS PhoneType      	
    		  , PhoneList.MSSPPhonelistKey SrcAdiKey
    		  , 'Steward_MSSPPhonelist' AS SrcAdiTableName
		  , GETDATE() AS LoadDate
		  , PhoneList.DataDate AS DataDate
        FROM adi.Steward_MSSPPhonelist PhoneList
            JOIN lst.lstPhoneCarrierType PhoneCarrierType 
        	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
            JOIN lst.lstPhoneType PhoneType 
        	   ON PhoneType.PhoneTypeCode = 'H'
        WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
            AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone)),'') <> ''
            AND PhoneList.status = 0
        UNION ALL
        SELECT   
            0								   AS mbrLoadKey     	
            , '1/1/2020'						   AS	EffectiveDate  	
            , '12/31/2099'						   AS  ExpirationDate 	
            ,PhoneCarrierType.lstPhoneCarrierTypeKey    AS  CarrierType    	
            , 0								   AS IsPrimary      	
            , PhoneList.incoming_client			   AS mbrMemberKey   	
            , PhoneList.subj_phone2 AS mbrPhone	-- What type based on the column being pivoted out
            , PhoneType.lstPhoneTypeKey AS PhoneType    
    		  , PhoneList.MSSPPhonelistKey SrcAdiKey
    		  , 'Steward_MSSPPhonelist' AS SrcAdiTableName  	
		  , GETDATE() AS LoadDate
		  , PhoneList.DataDate AS DataDate
        FROM adi.Steward_MSSPPhonelist PhoneList
            JOIN lst.lstPhoneCarrierType PhoneCarrierType 
        	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
            JOIN lst.lstPhoneType PhoneType 
        	   ON PhoneType.PhoneTypeCode = 'M'
        WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
            AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone2)),'') <> ''
            AND PhoneList.status = 0
        UNION ALL
        SELECT   
            0								   AS mbrLoadKey     	
            , '1/1/2020'						   AS	EffectiveDate  	
            , '12/31/2099'						   AS  ExpirationDate 	
            ,PhoneCarrierType.lstPhoneCarrierTypeKey    AS  CarrierType    	
            , 0								   AS IsPrimary      	
            , PhoneList.incoming_client			   AS mbrMemberKey   	
            , PhoneList.subj_phone3 AS mbrPhone	-- What type based on the column being pivoted out
            , PhoneType.lstPhoneTypeKey AS PhoneType    
    		  , PhoneList.MSSPPhonelistKey SrcAdiKey
    		  , 'Steward_MSSPPhonelist' AS SrcAdiTableName  	
		  , GETDATE() AS LoadDate
		  , PhoneList.DataDate AS DataDate
        FROM adi.Steward_MSSPPhonelist PhoneList
            JOIN lst.lstPhoneCarrierType PhoneCarrierType 
        	   ON PhoneCarrierType.PhoneCarrierTypeCode = 'NK'
            JOIN lst.lstPhoneType PhoneType 
        	   ON PhoneType.PhoneTypeCode = 'W'
        WHERE ISNULL(PhoneList.incoming_client, '')  <> ''
            AND ISNULL(RTRIM(LTRIM(PhoneList.subj_phone3)),'') <> ''
            AND PhoneList.status = 0;
        /* 3 update old records setting the RowExpirationdate  */      
        
	   COMMIT TRAN LoadMbrPhone ;
	   
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
		  ROLLBACK TRANSACTION          
		  END    	   
	   IF (XACT_STATE()) = 1      
		  BEGIN      
		  COMMIT TRANSACTION    ;         
	   END       
	   /* write error log close */          
	   SET @ActionStart = getdate();              	   
	   SELECT @OutCnt= 0;      
	   SET @ErrCnt = @InpCnt;      
	   SET @JobStatus = 3 -- error      
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
		  @AuditId = @AuditID      
		  , @ActionStopTime = @ActionStart      
		  , @SourceCount = @InpCnt          
		  , @DestinationCount = @OutCnt      
		  , @ErrorCount = @ErrCnt      
		  , @JobStatus = @JobStatus      
		  ;      
	   ;THROW      
    END CATCH        
    
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
    /* Update adi: status = 1*/      
    BEGIN TRY      
	   BEGIN TRAN      
	   UPDATE adiData      
		  SET status = 1
	   FROM adi.Steward_MSSPPhonelist adiData         
		  --JOIN #OutputTbl OutTable ON adiData.MSSPPhonelistKey = OutTable.AdiKey;      update all rows regardless of if they where used.
	   COMMIT TRAN      
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
			 ROLLBACK TRANSACTION      
			 ;THROW
		  END    
	   IF (XACT_STATE()) = 1      
		  BEGIN      
			 COMMIT TRANSACTION;         
		  END       
    ;THROW      
    END CATCH;
 END;

