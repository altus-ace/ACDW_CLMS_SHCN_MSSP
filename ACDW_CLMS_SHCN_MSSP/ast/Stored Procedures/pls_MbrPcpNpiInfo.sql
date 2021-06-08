
CREATE PROCEDURE [ast].[pls_MbrPcpNpiInfo](@DateDate DATE) 
AS
BEGIN
BEGIN TRAN
BEGIN TRY

					DECLARE @DataDate DATE = CONVERT(DATE,GETDATE())

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1  
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 16; 
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MemberInfoFrmAHSLoad';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'Ahs_Altus_Prod_PreferredProvider'
					DECLARE @DestName VARCHAR(100) = 'adi.AhsMemberInfo.'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @RecordCount INT
SELECT				@InpCnt = COUNT(AhsMemberInfoKey)    
FROM				adi.AhsMemberInfo  
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
					
--CREATE TABLE #OutputTbl (ID INT NOT NULL );

INSERT INTO				[ast].[MbrInfoStg2_MbrDataUpdate](
						[ClientMemberKey]
						, [ClientKey]
						, [LoadType]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [prvNPI]
						, [prvTIN]
						, [prvAutoAssign]
						, [prvClientEffective]
						, [prvClientExpiration]
						, [SrcFileName]
						, [AdiTableName]
						, [AdiKey]
						, [LoadDate]
						, [DataDate])
--OUTPUT					inserted.mbrInfoStg2_MbrDataKey INTO #OutputTbl(ID)
SELECT					a.[CLientMemberKey]
						, b.ClientKey
						, 'P'
						, b.LastName
						, b.FirstName
						, b.MiddleName
						, a.[PcpPreferredNPI]
						,   a.[PcpPreferredTIN]
						, ''
						, a.DataDate				
						, ''		
						, a.[SrcFileName]	
						, 'adi.AhsMemberInfo'
						, a.[AhsMemberInfoKey]
						, CAST(GETDATE() AS DATE)
						, a.[DataDate]	
FROM					adi.AhsMemberInfo a
JOIN					adw.FctMembership b
ON						a.CLientMemberKey = b.ClientMemberKey
WHERE					b.Active = 1
AND						b.Clientkey = 16 --- @ClientID --
AND						a.DataDate = @DataDate -- 

SELECT					@OutCnt = COUNT(AhsMemberInfoKey)    
									FROM	adi.AhsMemberInfo  
									WHERE	DataDate = @DataDate 
SET						@ActionStart  = GETDATE();
SET						@JobStatus =2  
    
EXEC					amd.sp_AceEtlAudit_Close 
						@AuditId = @AuditID
						, @ActionStopTime = @ActionStart
						, @SourceCount = @InpCnt		  
						, @DestinationCount = @OutCnt
						, @ErrorCount = @ErrCnt
						, @JobStatus = @JobStatus

						

END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
COMMIT


END





