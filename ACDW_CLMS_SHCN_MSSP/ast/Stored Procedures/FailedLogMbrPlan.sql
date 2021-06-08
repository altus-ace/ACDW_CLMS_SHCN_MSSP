
CREATE PROCEDURE [ast].[FailedLogMbrPlan]

AS

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'FailedLogMbrPlan';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPRiskPopulation'
					DECLARE @DestName VARCHAR(100) = 'AceMetaData.amd.AceBusinessRuleLog'
					DECLARE @ErrorName VARCHAR(100) = 'Check table, AceEtlAuditErrorLog';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					

					CREATE TABLE		#OutputTbl (ID INT NOT NULL );
					
					
					SELECT				 @InpCnt = COUNT(ID)    
					FROM				 #OutputTbl
					 

	EXEC			amd.sp_AceEtlAudit_Open 
					@AuditID = @AuditID OUTPUT
					, @AuditStatus = @JobStatus
					, @JobType = @JobType
					, @ClientKey = @ClientKey
					, @JobName = @JobName
					, @ActionStartTime = @ActionStart
					, @InputSourceName = @SrcName
					, @DestinationName = @DestName
					, @ErrorName = @ErrorName

	
	INSERT INTO			AceMetaData.[amd].[AceBusinessRuleLog](
						[lBusinessRuleKey]
						,RuleOutCome
						,AdiTableName
						,AdiKey
						,astTableName
						,astTableKey)
	OUTPUT				inserted.adiKey INTO #OutputTbl(ID)
	SELECT				(Select lBusinessRuleKey From AceMetaData.[lst].[lstBusinessRules] Where lBusinessRuleKey = 4)
						,'Failed'
						,'adi.Steward_MSSPRiskPopulation' 
						, MSSPRiskPopulationKey
						,'ast.MbrModelMbrData'
						,0
		
	FROM		
						( 
									SELECT		MedicareBeneficiaryID,DataDate
												, MSSPRiskPopulationKey
												,CreateDate
									FROM		[adi].[Steward_MSSPRiskPopulation]
				
						)a
	
	LEFT JOIN
						(
	
									SELECT		 ClientSubscriberId,DataDate
												,ClientKey
												, AdiKey
									FROM		ast.MbrModelMbrData 
									WHERE		AdiTableName = '[adi].[Steward_MSSPRiskPopulation]'
									AND			DataDate = (Select MAX(DataDate) From ast.MbrModelMbrData Where ClientKey = 16 )
								  
						)b
	
	ON					a.MedicareBeneficiaryID = b.ClientSubscriberId
	WHERE				b.ClientSubscriberId IS NULL 
			
	
	
	
	SET					@ActionStart  = GETDATE();
	SET					@JobStatus =2  
			    				
	EXEC				amd.sp_AceEtlAudit_Close 
						@AuditId = @AuditID
						, @ActionStopTime = @ActionStart
						, @SourceCount = @InpCnt		  
						, @DestinationCount = @OutCnt
						, @ErrorCount = @ErrCnt
						, @JobStatus = @JobStatus


		
	DROP TABLE #OutputTbl						


					
COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH
END						






