

CREATE PROCEDURE		[ast].[Load_StgMbrDimModel]
					(@MbrYear SmallInt
					,@MbrMonth TinyINT)

AS

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @MbrMonths TINYINT = @MbrMonth 
					DECLARE @MbrYears SMALLINT = @MbrYear				

					DECLARE @DataDate DATE = CONVERT(DATE,GETDATE())

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 16; 
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MbrMemberLoad';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'adw.FctMembership'
					DECLARE @DestName VARCHAR(100) = 'ast.[MbrModelMbrData]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
SELECT				@InpCnt = COUNT(MbrModelMbrDataKey)    
FROM				ast.[MbrModelMbrData]  
WHERE				DataDate = @DataDate  

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
					
CREATE TABLE		#OutputTbl (ID INT NOT NULL );


INSERT INTO			[ast].[MbrModelMbrData]   
					([ClientSubscriberId]
					,[ClientKey]
					,[MstrMrnKey]
					,[LoadType]
					,[mbrLastName]
					,[mbrFirstName]
					,[mbrMiddleName]
					,[mbrSSN]
					,[mbrGENDER]
					,[mbrDob]
					,[mbrInsuranceCardIdNum]
					,[mbrMEDICAID_NO]
					,[mbrMEDICARE_ID]
					,[HICN]
					,[MBI]
					,[mbrEthnicity]
					,[mbrRace]
					,[mbrPrimaryLanguage]
					,[prvNPI]
					,[prvTIN]
					,[prvAutoAssign]
					,[prvClientEffective]
					,[prvClientExpiration]
					,[plnProductPlan]
					,[plnProductSubPlan]
					,[plnProductSubPlanName]
					,[plnMbrIsDualCoverage]
					,[plnClientPlanEffective]
					,[rspLastName]
					,[rspFirstName]
					,[rspAddress1]
					,[rspAddress2]
					,[rspCITY]
					,[rspSTATE]
					,[rspZIP]
					,[rspPhone]
					,[SrcFileName]
					,[AdiTableName]
					,[AdiKey]
					,[stgRowStatus]
					,[LoadDate]
					,[DataDate]
					,[CreateDate]
					,[CreateBy]
					,[MbrMemberKey]
					,[MbrPlanKey]
					,[MbrPcpKey]
					,[MbrCsPlanKey]
					,[TransformPcpEffectiveDate]
					,[TransfromPcpExpirationDate]
					,[TransformPlanEffectiveDate]
					,[TransfromPlanExpirationDate]
					,[TransformCsPlanEffectiveDate]
					,[TransfromCsPlanExpirationDate]
					,[MbrLoadHistoryKey]
					,[TransformDemoEffectiveDate]
					,[TransformDemoExpirationDate]
					,[TransformCsPlanNameDate]
					,[plnClientPlanEndDate]
					,[stgRowAction]
					,[Member_Dual_Eligible_Flag])
OUTPUT				inserted.MbrModelMbrDataKey INTO #OutputTbl(ID)
SELECT					
					ClientMemberKey
					,ClientKey
					,Ace_ID
					,'P'
					,LastName
					,FirstName
					,MiddleName
					,MemberSSN
					,Gender
					,DOB
					,''
					,''
					,''
					,HICN
					,MBI
					,''
					,''
					,''
					,NPI
					,PcpPracticeTIN
					,''
					,'2019-01-01'
					,''
					,[PlanName]
					,''
					,PlanName
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,SrcFileName
					,AdiTableName
					,AdiKey
					,'Valid'
					,LoadDate
					,RwEffectiveDate
					,CreatedDate
					,CreatedBy
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,''
					,'Insert'
					,''
FROM				adw.FctMembership


SELECT				@OutCnt = COUNT(*) FROM #OutputTbl;
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



