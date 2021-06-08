





CREATE PROCEDURE [adw].[PdwMbr_05_LoadAddress]		(@DataDate DATE
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
					DECLARE @JobName VARCHAR(100) = 'SHCN MSSP MbrAddress';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ast.[MbrStg2_MbrData]'
					DECLARE @DestName VARCHAR(100) = '[adw].[MbrAddress]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT);
	SELECT			@InpCnt = COUNT(a.ID)    
	FROM			@OutputTbl a 

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
									,Address1
									,Address2
									,a.STATE
									,ZIP
									,adiKey
									,adiTableName
									,LoadDate
									,DataDate
									,EffectiveDate
									,ExpirationDate
					FROM			adw.MbrAddress a
					WHERE			DataDate = @DataDate
				  )

--
INSERT INTO				 adw.MbrAddress(
						 [ClientMemberKey]
						 , [adiKey]
						 , [adiTableName]
						 , [EffectiveDate]
						 , [ExpirationDate]
						 , [Address1]
						 , [Address2]
						 , [CITY]
						 , [STATE]
						 , [ZIP]
						 , [COUNTY]
						 , [LoadDate]
						 , [DataDate]
						 , ClientKey)
OUTPUT inserted.adiKey INTO @OutputTbl(ID)
SELECT					 [ClientMemberKey]
						 , [AdiKey]
						 , [AdiTableName]
						 , EffectiveDate
						 , ExpirationDate
						 , MemberHomeAddress
						 , MemberHomeAddress1
						 , MemberHomeCity
						 , MemberHomeState
						 , MemberHomeZip
						 , CountyName
						 , [LoadDate]
						 , [DataDate]
						 , [ClientKey]
FROM					(
							SELECT
													mbr.[ClientMemberKey]
													,stg.[AdiKey]
													,ISNULL(stg.[AdiTableName],'') [AdiTableName]
													,mbr.EffectiveDate
													,mbr.ExpirationDate
													,ISNULL(stg.MemberHomeAddress,'') MemberHomeAddress
													,ISNULL(stg.MemberHomeAddress1,'') MemberHomeAddress1
													,ISNULL(stg.MemberHomeCity,'') MemberHomeCity
													,ISNULL(stg.MemberHomeState,'') MemberHomeState
													,ISNULL(stg.MemberHomeZip,'') MemberHomeZip
													,ISNULL(stg.CountyName,'') CountyName
													,stg.LoadDate
													,stg.DataDate
													,stg.ClientKey
							FROM					 ast.[MbrStg2_MbrData]  stg --select * from ast.[MbrStg2_MbrData]
							JOIN					(	SELECT		DISTINCT  a.ClientMemberKey,EffectiveDate,ExpirationDate,a.AdiKey
																		,a.DataDate,a.ClientKey,stgRowStatus
															FROM		adw.MbrMember a 
															JOIN		ast.[MbrStg2_MbrData] b 
															ON			a.ClientMemberKey = b.ClientMemberKey 
															AND			a.DataDate =b.DataDate
															AND			a.AdiKey = b.Adikey
															WHERE		b.DataDate = @DataDate 
														)mbr
							ON						mbr.ClientMemberKey = stg.ClientMemberKey
							AND						stg.AdiKey = mbr.AdiKey
							AND						stg.DataDate = mbr.DataDate
							WHERE					stg.DataDate =   @DataDate  
							AND						mbr.ClientKey =  @ClientID 
							AND						mbr.stgRowStatus = 'Valid'
													) AS Src
							

 BEGIN
	UPDATE			adw.MbrAddress
	SET				IsCurrent = 'N'		
	---- SELECT * FROM adw.MbrAddress
	WHERE			DataDate <>  @DataDate 
	AND				IsCurrent <> 'N'

	UPDATE			adw.MbrAddress
	SET				ExpirationDate = (SELECT CONVERT(DATE,DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,CONVERT(DATE,GETDATE())),0))))
	--	SELECT * FROM adw.MbrAddress --  ORDER BY LoadDate DESC
	WHERE			DataDate <>  @DataDate
	AND				ExpirationDate = '2099-12-31'

END

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
[adw].[PdwMbr_05_LoadAddress]'2021-03-13',16
*/
--Validation
	/*
	 SELECT		COUNT(*), DataDate 
	 FROM		adw.MbrAddress 
	 GROUP BY	DataDate
	 ORDER BY	DataDate DESC
	 */



