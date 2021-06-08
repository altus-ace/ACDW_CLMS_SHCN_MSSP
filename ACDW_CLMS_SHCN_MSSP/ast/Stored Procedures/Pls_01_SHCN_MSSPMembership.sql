
CREATE PROCEDURE [ast].[Pls_01_SHCN_MSSPMembership]
                 (@MbrYear SmallInt
				 ,@MbrMonth TinyINT
				 ,@RwEffectiveDate DATE
				 ,@RwExpirationDate DATE
				 ,@MemberCurrentEffectiveDate DATE
				 ,@MemberCurrentExpirationDate Date
				 ,@DataDate DATE
				 ,@DemographicDataDate DATE)

AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
--SET ANSI_WARNINGS OFF
BEGIN
				
				DECLARE @MbrMonths TINYINT = @MbrMonth 
				DECLARE @MbrYears SMALLINT = @MbrYear				
				DECLARE @RwEffectiveDates  DATE = @RwEffectiveDate
				DECLARE @RwExpirationDates  DATE = @RwExpirationDate 
				DECLARE @MemberCurrentEffectiveDates DATE = @MemberCurrentEffectiveDate
				DECLARE @MemberCurrentExpirationDates DATE = @MemberCurrentExpirationDate
	--DECLARE @YearNBRs INT = @YearNBR 
	
	INSERT INTO  ast.MbrStg2_MbrData	
					([AdiKey]
					,[SrcFileName]		
					,[AdiTableName]		
					,[LoadDate]
					,[DataDate]			
					,[RwEffectiveDate]
					,[RwExpirationDate]
					,[ClientKey]		
					,Ace_ID			
					,ClientMemberKey	
					,[MBI]				
					,[HICN]				
					,FirstName		
					,LastName			
					,Gender			
					,[Dob]				
					,[DOD]				
					,[CurrentAge]		
					,[MbrMonth]			
					,[MbrYear]			
					,[MemberHomeAddress]
					,[MemberHomeAddress1]
					,[MemberHomeCity]	
					,[MemberHomeState]	
					,[MemberHomeZip]	
					,[LOB]				
					,Contract --[PlanName]			
					,[NPI]	
					,[ClientRiskScore]	
					,[MemberCurrentEffectiveDate]	
					,[MemberCurrentExpirationDate]
					,[PlanName]
					,[Active]
					,MbrState
					,[CountyNumber]
					,MemberMailingAddress
					,MemberMailingAddress1
					,MemberMailingCity
					,MemberMailingState
					,[MemberMailingZip]
					,MiddleName
					)			
	SELECT			DISTINCT [MSSPPatientAttributionKey]					[AdiKey]
					,[SrcFileName]											[SrcFileName]
					,'adi.[MSSPPatientAttributionList]'						[AdiTableName]	
					,GETDATE()												[LoadDate]
					,[DataDate]												[DataDate]
					,@RwEffectiveDate										[RwEffectiveDate]
					,@RwExpirationDate										[RwExpirationDate]
					,(SELECT ClientKey FROM lst.List_Client WHERE ClientName = 'Steward Health Care Network MSSP')	[ClientKey]
					,0														Ace_ID
					,a.MBI_ID												ClientMemberKey
					,a.MBI_ID												[MBI]
					,ISNULL(b.HealthInsuranceClaimNBR,'')					[HICN]
					,a.PatientFirstName										[FirstName]
					,a.PatientLastName										[LastName]
					,CASE WHEN a.Sex = 'Female' THEN 	'F'		
						  WHEN a.Sex = 'Male' THEN 'M' END					[Gender]
					,a.DOB													[Dob]
					,ISNULL(b.DeathDTS,'')									[DOD]  
					,DATEDIFF(YY,a.DOB,@RwEffectiveDate)					[CurrentAge] 
					,@MbrMonth												[MbrMonth]
					,@MbrYear												[MbrYear]
					,b.MailingAddress01TXT									[MemberHomeAddress]
					,b.MailingAddress02TXT									[MemberHomeAddress1]
					,b.CityNM												[MemberHomeCity]
					,b.StateCD												[MemberHomeState]
					,b.PostalZipCD											[MemberHomeZip]
					,'MSSP'													LOB
					,(SELECT ClientShortName FROM lst.List_Client WHERE ClientKey = '16') Contract
					,a.AttributedNPI										[NPI]
					,a.HCCRiskScore											[ClientRiskScore]
					,@MemberCurrentEffectiveDate							[MemberCurrentEffectiveDate]
					,@MemberCurrentExpirationDate							[MemberCurrentExpirationDate]
					,'MSSP'													[PlanName]
					,1														[Active]
					,CASE WHEN StateCD IS NOT NULL	THEN StateCD
						ELSE 'Unk' END 										MbrState
					,''														[CountyNumber]	
					,b.MailingAddress01TXT									MemberMailingAddress 
					,b.MailingAddress02TXT									MemberMailingAddress1
					,b.CityNM												MemberMailingCity
					,b.StateCD												MemberMailingState
					,b.PostalZipCD											[MemberMailingZip]	
					,ISNULL(b.MiddleNM,'')									[MiddleName]
	FROM			adi.[MSSPPatientAttributionList] a
	LEFT JOIN		(	
	
						SELECT	*
						FROM	(
									SELECT	DISTINCT MedicareBeneficiaryID,DeathDTS, MailingAddress01TXT,MailingAddress02TXT
											,MailingAddress03TXT,MailingAddress04TXT,MailingAddress05TXT, MailingAddress06TXT
											,CityNM,StateCD,PostalZipCD,MiddleNM,HealthInsuranceClaimNBR
											,ROW_NUMBER()OVER(PARTITION BY MedicareBeneficiaryID ORDER BY DeathDTS DESC ) RwCnt
									FROM	adi.Steward_MSSPBeneficiaryDemographic sec
									WHERE	sec.DataDate =  @DemographicDataDate --  '2021-04-28' ---
								)b
						WHERE	RwCnt = 1			
					) b
	ON				a.MBI_ID = b.MedicareBeneficiaryID
	LEFT JOIN		(	SELECT	*
						FROM	(--list_pcp has the new Get NpiandTin 
									SELECT	PCP_NPI,EffectiveDate,ExpirationDate 
											,ROW_NUMBER()OVER(PARTITION BY PCP_NPI ORDER BY EffectiveDate)RwCnt
									FROM	lst.List_PCP
									WHERE	CONVERT(DATE,GETDATE()) BETWEEN EffectiveDate AND ExpirationDate
								)t
						WHERE	RwCnt = 1		
					) pr
	ON				a.AttributedNPI = pr.PCP_NPI
	WHERE			DataDate =  @DataDate --- '2021-04-28' --
	AND				CONVERT(date,CreateDate) =( SELECT MAX(CONVERT(date,CreateDate))
												FROM adi.[MSSPPatientAttributionList])
	--AND				Status = 0 Should only apply for processing a new set of records because records are re-used

	END
	

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
/*
EXECUTE [ast].[Pls_01_SHCN_MSSPMembership]
				  @MbrYear						= 2021
				 ,@MbrMonth						= 5
				 ,@RwEffectiveDate				= '2021-05-01'
				 ,@RwExpirationDate				= '2021-05-31'
				 ,@MemberCurrentEffectiveDate	= '2021-01-01'
				 ,@MemberCurrentExpirationDate	= '2021-12-31'
				 ,@DataDate						= '2021-03-13'
				 ,@DemographicDataDate			= '2021-04-28'
*/



  