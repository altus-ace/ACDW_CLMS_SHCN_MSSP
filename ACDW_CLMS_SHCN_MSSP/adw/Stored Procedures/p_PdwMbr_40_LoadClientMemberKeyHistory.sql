CREATE PROCEDURE adw.p_PdwMbr_40_LoadClientMemberKeyHistory
AS 
BEGIN
    declare @DEBUG TINYINT = 0 ;
    --SET @DEBUG = 1;
    IF OBJECT_ID('ast.tmpCH') IS NOT NULL
        DROP TABLE ast.tmpCH;
    IF OBJECT_ID('ast.tmpFinal') IS NOT NULL
        DROP TABLE ast.tmpFinal;
    --Insert temp population
    BEGIN TRY      
	   BEGIN TRAN 	    
	   -- insert data into tmp table
	   SELECT DISTINCT h.SUBSCRIBER_ID, m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender
	      	,MIN(PRIMARY_SVC_DATE) as MinDate, MAX(PRIMARY_SVC_DATE) as MaxDate
	   INTO ast.tmpCH
	   FROM adw.Claims_Headers h
	      JOIN adw.Claims_Member m
	      ON h.SUBSCRIBER_ID = m.SUBSCRIBER_ID
	   GROUP BY h.SUBSCRIBER_ID, m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender
	   HAVING MAX(PRIMARY_SVC_DATE) >= '01-01-2019'
	  
	   IF @DEBUG = 1  -- review set of dup member differnt subscriber ID
	   BEGIN
	      SELECT m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender, COUNT(SUBSCRIBER_ID)
	      FROM ast.tmpCH m
	      GROUP BY m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender
	      HAVING COUNT(SUBSCRIBER_ID) > 1
	   END
    	   
	   COMMIT TRAN;        	    
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
	/*
	   /* write error log close */          
	   SET @ActionStop = getdate();              
	   /* get InpCnt  */
	   --SELECT @InpCnt = COUNT(*) FROM SOURCE ;      
	   SELECT @OutCnt = 0;      
	   SET @ErrCnt = @InpCnt;      
	   SET @JobStatus = 3 -- error      
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
		  @AuditId = @AuditID      
		  , @ActionStopTime = @ActionStop
		  , @SourceCount = @InpCnt          
		  , @DestinationCount = @OutCnt
		  , @ErrorCount = @ErrCnt      
		  , @JobStatus = @JobStatus      
		  ;      
		  */
	   ;THROW      
    END CATCH       
    -- insert working duplicates 
    BEGIN TRY
	   BEGIN TRAN
	   SELECT cur.*, prv.CurClientMasterKey AS PrevClientMasterKey, prv.MinDate as PrevMinDate, prv.MaxDate as PrevMaxDate 
	   INTO ast.tmpFinal
	   FROM (
    		  SELECT SUBSCRIBER_ID as CurClientMasterKey, MEMB_LAST_NAME, MEMB_FIRST_NAME, DOB, Gender, MinDate, MaxDate 
    		  FROM (SELECT m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender, m.MinDate, m.MaxDate, m.SUBSCRIBER_ID
    		  		    , ROW_NUMBER() OVER(PARTITION BY m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender ORDER BY m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender, m.MaxDate DESC) as RN
        		  	FROM ast.tmpCH m  ) a
    		  WHERE a.RN = 2) prv
	   LEFT JOIN( 
    		  SELECT SUBSCRIBER_ID as CurClientMasterKey, MEMB_LAST_NAME, MEMB_FIRST_NAME, DOB, Gender, MinDate, MaxDate 
    		  FROM (SELECT m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender, m.MinDate, m.MaxDate, m.SUBSCRIBER_ID
    				, ROW_NUMBER() OVER(PARTITION BY m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender ORDER BY m.MEMB_LAST_NAME, m.MEMB_FIRST_NAME, m.DOB, m.Gender, m.MaxDate DESC) as RN
    				FROM ast.tmpCH m 
    				) a
    			 WHERE a.RN = 1) cur
		  ON  cur.MEMB_LAST_NAME	 = prv.MEMB_LAST_NAME
		  AND cur.MEMB_FIRST_NAME = prv.MEMB_FIRST_NAME
		  AND cur.DOB			 = prv.DOB
		  AND cur.Gender		 = prv.Gender
 	   
	   IF @DEBUG = 1  -- review set of dup member differnt subscriber ID
	   BEGIN
		  SELECT * 
		  FROM ast.tmpFinal
	   END;
	   
	   COMMIT TRAN;
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
	/*
	   /* write error log close */          
	   SET @ActionStop = getdate();              
	   /* get InpCnt  */
	   --SELECT @InpCnt = COUNT(*) FROM SOURCE ;      
	   SELECT @OutCnt = 0;      
	   SET @ErrCnt = @InpCnt;      
	   SET @JobStatus = 3 -- error      
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
		  @AuditId = @AuditID      
		  , @ActionStopTime = @ActionStop
		  , @SourceCount = @InpCnt          
		  , @DestinationCount = @OutCnt
		  , @ErrorCount = @ErrCnt      
		  , @JobStatus = @JobStatus      
		  ;      
		  */
	   ;THROW      
    END CATCH
    -- Export to ADW mbrClientMemberKeyHistory
    BEGIN TRY
	   BEGIN TRAN
		  INSERT INTO [adw].[MbrClientMemberKeyHistory]
			 ([NewCmkAdiTableName]
				,[IsCurrent]
				,[CurrentClientMemberKey]
				,[PreviousClientMemberKey]
				,[PreviousEffectiveDate]
				,[PreviousExpirationDate]
				,LoadDate
				,DataDate)
			 SELECT 'adw.Claims_Headers,adw.Claims_Member'
				,1
				,CurClientMasterKey
				,PrevClientMasterKey
				,PrevMinDate
				,PrevMaxDate
				,getdate()
				,getdate()
			 FROM ast.tmpFinal
			 ;
	   COMMIT TRAN
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
	/*
	   /* write error log close */          
	   SET @ActionStop = getdate();              
	   /* get InpCnt  */
	   --SELECT @InpCnt = COUNT(*) FROM SOURCE ;      
	   SELECT @OutCnt = 0;      
	   SET @ErrCnt = @InpCnt;      
	   SET @JobStatus = 3 -- error      
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
		  @AuditId = @AuditID      
		  , @ActionStopTime = @ActionStop
		  , @SourceCount = @InpCnt          
		  , @DestinationCount = @OutCnt
		  , @ErrorCount = @ErrCnt      
		  , @JobStatus = @JobStatus      
		  ;      
		  */
	   ;THROW      
    END CATCH
    IF @DEBUG = 1
	   SELECT * FROM adw.mbrClientMemberKeyHistory
	   --truncate table adw.mbrClientMemberKeyHistory;
END


