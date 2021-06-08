CREATE PROCEDURE [adw].[pdw_MbrPcpUpdateFrmAHS] (@DataDate Date) 
AS
BEGIN
BEGIN TRAN
BEGIN TRY


					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 16; 
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP_UpdateMbrPCPInfoFrmAHS';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ast.MbrInfoStg2_MbrDataUpdate'
					DECLARE @DestName VARCHAR(100) = 'adw.MbrPcp'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
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

						


INSERT INTO				  adw.MbrPcp([AdiKey]
									,[AdiTableName]
									,ClientMemberKey
									,[EffectiveDate]
									,[ExpirationDate]
									,[NPI]
									,[TIN]
									,[ClientEffective]
									,[ClientExpiration]
									,[AutoAssigned]
									,[LoadDate]
									,[DataDate] )
SELECT								[AdiKey]
									,[AdiTableName]
									,ClientMemberKey
									,[EffectiveDate]
									,[ExpirationDate]
									,[NPI]
									,[TIN]
									,[ClientEffective]
									,[ClientExpiration]
									,'SrcSys_Ahs'
									,[LoadDate]
									,[DataDate]
FROM					  (
									MERGE		[adw].[MbrPcp] AS Trg
									USING		(
												SELECT DISTINCT
												mbr.MbrMemberKey
												,stg.ClientMemberKey
												,stg.[adikey]
												,stg.[adiTableName]
												,stg.[prvNPI]
												,stg.[prvTIN]
												,stg.[TransformPcpEffectiveDate]      
												,stg.[TransfromPcpExpirationDate]
												,stg.[prvClientEffective]
												,stg.[prvClientExpiration]
												,stg.[prvAutoAssign]
												,stg.LoadDate
												,stg.DataDate
									FROM		ast.MbrInfoStg2_MbrDataUpdate stg   
									JOIN		adw.MbrMember mbr
									ON		    stg.ClientMemberKey = mbr.ClientMemberKey
									JOIN		adw.MbrPcp pcp
									ON		    mbr.ClientMemberKey = pcp.ClientMemberKey
									WHERE		stg.ClientKey = 16 
									AND		    stg.DataDate = @DataDate--   '2020-06-30'-- 
									AND		    stg.stgRowStatus = 'Valid'   
												) AS Src
									ON			Trg.ClientMemberKey = src.ClientMemberKey
									
									WHEN NOT MATCHED BY Target
									THEN INSERT			 (
														 [AdiKey],[AdiTableName],[ClientMemberKey],[EffectiveDate],[ExpirationDate]
														 ,[NPI],[TIN],[ClientEffective],[ClientExpiration],[AutoAssigned]
														 ,[LoadDate]
														 ,[DataDate]
														 )
									VALUES				 (
														 src.[AdiKey]
														 ,src.[AdiTableName]
														 ,src.ClientMemberKey
														 ,src.[prvClientEffective]
														 ,src.[prvClientExpiration]
														 ,src.[prvNPI]
														 ,src.[prvTIN]
														 ,src.[TransformPcpEffectiveDate]
														 ,src.[TransfromPcpExpirationDate]
														 ,'FrmAhs'
														 ,src.LoadDate
														 ,src.DataDate
														 )
									WHEN MATCHED AND	Trg.[NPI] <> src.prvNPI
									OR					Trg.[TIN] <> src.[prvTIN]		
									THEN UPDATE					
									SET					ExpirationDate = (SELECT DATEADD(DD,-1,CONVERT(DATE,GETDATE())))--src.[prvClientExpiration] 
														,IsCurrent	 = 'N'
									OUTPUT 
														$Action as Action_Out,
														[src].ClientMemberKey,
														[src].[adikey],
														[src].[adiTableName],
														[src].[prvNPI] AS NPI,
														[src].[prvTIN] AS TIN,
														[src].[prvClientEffective] AS [EffectiveDate], 
														[src].[prvClientExpiration] AS [ExpirationDate],
														[src].[prvClientEffective] AS [ClientEffective],
														[src].[prvClientExpiration] AS [ClientExpiration],
														[src].[prvAutoAssign] AS [AutoAssigned],
														[src].LoadDate,
														[src].DataDate
						  ) Merge_Output
WHERE					  Merge_Output.Action_Out = 'UPDATE';

; 

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




