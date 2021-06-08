
CREATE PROCEDURE		[ast].[Load_StgMbrPhoneAddEmmailDimModel]
					(@MbrYear SmallInt
					,@MbrMonth TinyINT)

AS

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @MbrMonths TINYINT = @MbrMonth 
					DECLARE @MbrYears SMALLINT = @MbrYear				
					--DECLARE @RwEffectiveDates  DATE = @RwEffectiveDate
					--DECLARE @RwExpirationDates  DATE = @RwExpirationDate 
					--DECLARE @MemberCurrentEffectiveDates DATE = @MemberCurrentEffectiveDate
					--DECLARE @MemberCurrentExpirationDates DATE = @MemberCurrentExpirationDate

					DECLARE @DataDate DATE = CONVERT(DATE,GETDATE())

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
					DECLARE @JobType SmallInt = 9	  -- AST load
					DECLARE @ClientKey INT	 = 16; -- aetna Comm
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MbrMemberPhoneAddEmailLoad';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'adw.FctMembership'
					DECLARE @DestName VARCHAR(100) = 'ast.[MbrModelPhoneAddEmail]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
SELECT				@InpCnt = COUNT(MbrModelPhoneAddEmailKey)    
FROM				ast.[MbrModelPhoneAddEmail]  
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


INSERT INTO			[ast].[MbrModelPhoneAddEmail]
					([ClientMemberKey]
					,[SrcFileName]
					,[LoadType]
					,[LoadDate]
					,[DataDate]
					,[AdiTableName]
					,[AdiKey]
					,[lstPhoneTypeKey]
					,[PhoneNumber]
					,[PhoneCarrierType]
					,[PhoneIsPrimary]
					,[lstAddressTypeKey]
					,[AddAddress1]
					,[AddAddress2]
					,[AddCity]
					,[AddState]
					,[AddZip]
					,[AddCounty]
					,[lstEmailTypeKey]
					,[EmailAddress]
					,[EmailIsPrimary]
					,[stgRowStatus]
					,[CreateDate]
					,[CreateBy]
					,[ClientKey]
					,[mbrEmailKey])
OUTPUT				inserted.MbrModelPhoneAddEmailKey INTO #OutputTbl(ID)
SELECT 
					ClientMemberKey
					,SrcFileName
					,'P'
					,LoadDate
					,RwEffectiveDate
					,AdiTableName
					,AdiKey
					,0
					,MemberPhone
					,''
					,0
					,0
					,MemberHomeAddress
					,MemberHomeAddress1
					,MemberHomeCity
					,MemberHomeState
					,MemberHomeZip
					,CountyName
					,0
					,''
					,0
					,'Valid'
					,CreatedDate
					,CreatedBy
					,ClientKey
					,0
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

