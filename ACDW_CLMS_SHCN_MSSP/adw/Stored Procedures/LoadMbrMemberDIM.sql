

CREATE PROCEDURE [adw].[LoadMbrMemberDIM] (@DataDate Date, @ClientID INT)
AS
BEGIN
BEGIN TRAN
BEGIN TRY

					

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
					DECLARE @JobType SmallInt = 9	  -- AST load
					DECLARE @ClientKey INT	 = 16; -- aetna Comm
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MbrPCPInfoLoad';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ast.MbrInfoStg2_MbrDataUpdate'
					DECLARE @DestName VARCHAR(100) = 'adw.MbrMember'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
/*
SELECT				@InpCnt = COUNT(mbrInfoStg2_MbrDataKey)    
FROM				ast.MbrInfoStg2_MbrDataUpdate  
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
					
CREATE TABLE #OutputTbl (ID INT NOT NULL );

MERGE				[adw].[MbrMember]		AS Trg
USING				(
					SELECT	
					ast.ClientMemberKey
					,ast.ClientKey
					,ast.MstrMrnKey
					,ast.AdiKey
					,ast.AdiTableName
					,ast.LoadDate
					,ast.DataDate
FROM				ast.MbrInfoStg2_MbrDataUpdate  ast
WHERE				ast.ClientKey =  16 --  @ClientID -- 
--AND				ast.DataDate = '2020-07-31' -- @DataDate -- Enable after first Run
AND					ast.stgRowStatus = 'Valid'
					) AS Src
ON					trg.ClientMemberKey = src.ClientMemberKey

WHEN MATCHED AND	trg.ClientMemberKey <> src.ClientMemberKey
THEN UPDATE	
SET					trg.RecordFlag = 'N'

WHEN NOT MATCHED	
THEN INSERT			([ClientMemberKey]
					, [ClientKey]
					, [MstrMrnKey]
					, [adiKey]
					, [adiTableName]
					, [LoadDate]
					, [DataDate])
VALUES				(src.ClientMemberKey
					,src.ClientKey
					,src.MstrMrnKey
					,src.AdiKey
					,src.AdiTableName
					,src.LoadDate
					,src.DataDate)
OUTPUT				inserted.[adiKey] INTO #OutputTbl(ID);


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

*/
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
COMMIT

END






