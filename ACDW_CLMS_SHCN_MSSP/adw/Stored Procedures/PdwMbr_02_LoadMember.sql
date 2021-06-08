﻿



CREATE PROCEDURE [adw].[PdwMbr_02_LoadMember]	(@DataDate DATE       
											    ,@LoadType VARCHAR(1)   
											    ,@ClientID INT
												,@EffectiveDate DATE
												)   
AS

BEGIN

BEGIN TRY 
BEGIN TRAN
							
						DECLARE @AuditId INT;    
						DECLARE @JobStatus tinyInt = 1    
						DECLARE @JobType SmallInt = 9	  
						DECLARE @ClientKey INT	 = @ClientID; 
						DECLARE @JobName VARCHAR(100) = 'SHCN MSSPMbrMember';
						DECLARE @ActionStart DATETIME2 = GETDATE();
						DECLARE @SrcName VARCHAR(100) = 'ast.[MbrStg2_MbrData]'
						DECLARE @DestName VARCHAR(100) = '[adw].[MbrMember]'
						DECLARE @ErrorName VARCHAR(100) = 'NA';
						DECLARE @InpCnt INT = -1;
						DECLARE @OutCnt INT = -1;
						DECLARE @ErrCnt INT = -1;
						DECLARE @OutputTbl TABLE (ID INT);
	SELECT				@InpCnt = COUNT(a.ID)    
	FROM				@OutputTbl a
	
	
	SELECT				@InpCnt, @DataDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
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
	--			DECLARE @DataDate DATE = '2021-02-18' DECLARE @LoadType VARCHAR(1) = 'P' DECLARE @ClientID INT = 20 DECLARE @EffectiveDate DATE = '2021-02-01'

	IF NOT EXISTS ( SELECT			ClientMemberKey
									,ClientKey
									,MstrMrnKey
									,adiKey
									,adiTableName
									,LoadDate
									,DataDate
									,EffectiveDate
									,ExpirationDate
					FROM			adw.MbrMember
					WHERE			DataDate = @DataDate
				  )
	INSERT INTO			[adw].[MbrMember]
						([ClientMemberKey]
						, [ClientKey]
						, [MstrMrnKey]
						, [adiKey]
						, [adiTableName]
						, [LoadDate]
						, [DataDate]
						, [EffectiveDate]
						,[ExpirationDate])
	OUTPUT inserted.MbrMemberKey INTO @OutputTbl(ID)
	SELECT				[ClientMemberKey]
						, [ClientKey]
						, Ace_ID
						, [adiKey]
						, [adiTableName]
						, [LoadDate]
						, [DataDate]
						, [EffectiveDate]
						,[ExpirationDate]
	FROM				
						(
	
									SELECT 	
												ast.ClientMemberKey
												,ast.ClientKey
												,ast.Ace_ID
												,ast.AdiKey
												,ast.AdiTableName
												,ast.LoadDate
												,ast.DataDate
												,@EffectiveDate 					AS EffectiveDate 
												,ast.MemberCurrentExpirationDate	AS ExpirationDate
									FROM		ast.[MbrStg2_MbrData]  ast 
									WHERE		ast.DataDate = @DataDate 
									AND			ast.ClientKey =   @ClientID 
									AND			ast.stgRowStatus = 'Valid'
									AND			RwEffectiveDate =  @EffectiveDate 
						) AS Src

	;
	UPDATE			adw.MbrMember
	SET				IsCurrent = 'N'		
	---- SELECT * FROM adw.MbrMember
	WHERE			DataDate <>  @DataDate 
	AND				IsCurrent <> 'N'

	UPDATE			adw.MbrMember
	SET				ExpirationDate = (SELECT CONVERT(DATE,DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,CONVERT(DATE,GETDATE())),0))))
	--	SELECT * FROM adw.MbrMember --  ORDER BY LoadDate DESC
	WHERE			DataDate <>  @DataDate
	AND				ExpirationDate = '2099-12-31'



	SET					@ActionStart  = GETDATE();
	SET					@JobStatus =2  
	    				
	EXEC				amd.sp_AceEtlAudit_Close 
						@AuditId = @AuditID
						, @ActionStopTime = @ActionStart
						, @SourceCount = @InpCnt		  
						, @DestinationCount = @OutCnt
						, @ErrorCount = @ErrCnt
						, @JobStatus = @JobStatus
	
	COMMIT
	END TRY
	BEGIN CATCH
	EXECUTE				[dbo].[usp_QM_Error_handler]
	END CATCH
	
	
	END
	
	
	/*
	USAGE
	[adw].[PdwMbr_02_LoadMember]'2021-03-13','P',16,'2021-01-01'
	*/
	--Validation
	/*
	 SELECT		COUNT(*), DataDate 
	 FROM		adw.MbrMember 
	 GROUP BY	DataDate
	 ORDER BY	DataDate DESC
	 */
	
	

