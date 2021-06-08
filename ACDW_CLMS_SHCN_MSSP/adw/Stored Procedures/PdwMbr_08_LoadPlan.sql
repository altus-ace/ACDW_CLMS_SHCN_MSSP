﻿







CREATE PROCEDURE [adw].[PdwMbr_08_LoadPlan]			(@DataDate DATE
													,@ClientID INT
													)
AS

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = @ClientID; 
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MbrPlan';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ast.[MbrStg2_MbrData]'
					DECLARE @DestName VARCHAR(100) = '[adw].[MbrPlan]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT);
	SELECT	@InpCnt = COUNT(a.ID)    
	FROM	@OutputTbl a 

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
									,ProductPlan
									,ProductSubPlan
									,ProductSubPlanName
									,adiKey
									,adiTableName
									,LoadDate
									,DataDate
									,EffectiveDate
									,ExpirationDate
									,ClientPlanEffective
					FROM			adw.MbrPlan
					WHERE			DataDate = @DataDate
				  )
	
	INSERT INTO adw.MbrPlan(
							[ClientMemberKey]
							, [adiKey]
							, [adiTableName]
							, [EffectiveDate]
							, [ExpirationDate]
							, [ProductPlan]
							, [ProductSubPlan]
							, [ProductSubPlanName]
							, [MbrIsDualCoverage]
							, [DualEligiblityStatus]
							, [ClientPlanEffective]
							, [LoadDate]
							, [DataDate]
							, [ClientKey])
	OUTPUT inserted.adiKey INTO @OutputTbl(ID)
	SELECT					ClientMemberKey
							,[adiKey]
							,[adiTableName]
							,EffectiveDate
							,ExpirationDate
							,LOB
							,PlanName
							,Contract
							,[plnMbrIsDualCoverage]
							,[Member_Dual_Eligible_Flag]
							,MemberCurrentEffectiveDate
							,[LoadDate]
							,[DataDate]
							,[ClientKey]
	FROM					(
								SELECT
														mbr.MbrMemberKey
														,stg.ClientMemberKey
														,stg.[adikey]
														,stg.[adiTableName]
														,mbr.EffectiveDate
														,mbr.ExpirationDate
														,stg.Contract
														,stg.PlanName
														,stg.LOB
														,stg.[plnMbrIsDualCoverage]
														,stg.[Member_Dual_Eligible_Flag]
														,stg.LoadDate
														,stg.DataDate
														,stg.ClientKey
														,stg.MemberCurrentEffectiveDate
								FROM					ast.[MbrStg2_MbrData]  stg
								JOIN					adw.MbrMember mbr
								ON						stg.ClientMemberKey = mbr.ClientMemberKey
								AND						stg.AdiKey = mbr.AdiKey
								AND						stg.AdiTableName = mbr.AdiTableName
								AND						stg.DataDate = mbr.DataDate
								WHERE					mbr.DataDate = @DataDate
								AND						mbr.ClientKey =   @ClientID  
								AND						stg.stgRowStatus = 'Valid'   
							) AS Src
								
;

	UPDATE			adw.MbrPlan
	SET				IsCurrent = 'N'		
	---- SELECT * FROM adw.MbrPlan
	WHERE			DataDate <>  @DataDate 
	AND				IsCurrent <> 'N'

	UPDATE			adw.MbrPlan
	SET				ExpirationDate = (SELECT CONVERT(DATE,DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,CONVERT(DATE,GETDATE())),0))))
	--	SELECT * FROM adw.MbrPlan --  ORDER BY LoadDate DESC
	WHERE			DataDate <>  @DataDate
	AND				ExpirationDate = '2099-12-31'

SELECT				@OutCnt = COUNT(*) FROM @OutputTbl;
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
[adw].[PdwMbr_08_LoadPlan]'2021-03-13',16
*/
--Validation
	/*
	 SELECT		COUNT(*), DataDate 
	 FROM		adw.MbrPlan 
	 GROUP BY	DataDate
	 ORDER BY	DataDate DESC
	 */


