
CREATE PROCEDURE [ast].[z__Pls_01_SHCN_MSSPMembership_OLD]
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
					,[MstrMrnKey]			
					,[ClientSubscriberId]	
					,[MBI]				
					,[HICN]				
					,[mbrFirstName]		
					,[mbrLastName]			
					,[mbrGender]			
					,[mbrDob]				
					,[mbrDOD]				
					,[MbrCurrentAge]		
					,[MbrMonth]			
					,[MbrYear]			
					,[MemberHomeAddress]
					,[MemberHomeAddress2]
					,[MemberHomeCity]	
					,[MemberHomeState]	
					,[MemberHomeZip]	
					,[plnProductPlan]				
					,[plnProductSubPlan]			
					,[prvNPI]	
					,[RiskScore]	
					,[MemberCurrentEffectiveDate]	
					,[MemberCurrentExpirationDate]
					,[plnProductSubPlanName]
					,[Active]
					,[MbrState]
					,[CountyNumber]
					,MemberMailingAddress
					,MemberMailingAddress1
					,MemberMailingCity
					,MemberMailingState
					,[MemberMailingZip]
					,[mbrMiddleName])			
	SELECT			DISTINCT [MSSPMembershipKey]							[AdiKey]
					,[SrcFileName]											[SrcFileName]
					,'[adi].[Steward_MSSPMembership_2021]'					[AdiTableName]	
					,GETDATE()												[LoadDate]
					,[DataDate]												[DataDate]
					,@RwEffectiveDate										[RwEffectiveDate]
					,@RwExpirationDate										[RwExpirationDate]
					,(SELECT ClientKey FROM lst.List_Client WHERE ClientName = 'Steward Health Care Network MSSP')	[ClientKey]
					,0														[MstrMrnKey]
					,a.[MedicareBeneficiaryID]								[ClientSubscriberId]
					,a.[MedicareBeneficiaryID]								[MBI]
					,[HealthInsuranceClaimNBR]								[HICN]
					,[FirstNM]												[mbrFirstName]
					,[LastNM]												[mbrLastName]
					,[SexCD]												[mbrGender]
					,[BirthDTS]												[mbrDob]
					,b.DeathDTS												[mbrDOD]  
					,DATEDIFF(YY,[BirthDTS],@RwEffectiveDate)				[MbrCurrentAge] 
					,@MbrMonth												[MbrMonth]
					,@MbrYear												[MbrYear]
					,b.MailingAddress01TXT									[MemberHomeAddress]
					,b.MailingAddress02TXT									[MemberHomeAddress2]
					,b.CityNM												[MemberHomeCity]
					,b.StateCD												[MemberHomeState]
					,b.PostalZipCD											[MemberHomeZip]
					,'MSSP'													[plnProductPlan]
					,(SELECT ClientShortName FROM lst.List_Client WHERE ClientKey = '16') [plnProductSubPlan]
					,AlignmentNPI											[prvNPI]
					,0														[RiskScore]
					,@MemberCurrentEffectiveDate							[MemberCurrentEffectiveDate]
					,@MemberCurrentExpirationDate							[MemberCurrentExpirationDate]
					,'MSSP'													[plnProductSubPlanName]
					,1														[Active]
					,CASE WHEN StateCD IS NOT NULL	THEN StateCD
						ELSE 'Unk' END 										[MbrState]
					,CountyNBR												[CountyNumber]	
					,b.MailingAddress01TXT									MemberMailingAddress 
					,b.MailingAddress02TXT									MemberMailingAddress1
					,b.CityNM												MemberMailingCity
					,b.StateCD												MemberMailingState
					,b.PostalZipCD											[MemberMailingZip]	
					,b.MiddleNM												[mbrMiddleName]		
	FROM			[adi].[Steward_MSSPMembership_2021] a
	LEFT JOIN		(	SELECT		DISTINCT MedicareBeneficiaryID,DeathDTS, MailingAddress01TXT,MailingAddress02TXT
									,MailingAddress03TXT,MailingAddress04TXT,MailingAddress05TXT, MailingAddress06TXT
									,CityNM,StateCD,PostalZipCD,MiddleNM
						FROM		adi.Steward_MSSPBeneficiaryDemographic
						WHERE		DataDate = @DemographicDataDate
												
					) b
	ON				a.MedicareBeneficiaryID = b.MedicareBeneficiaryID
	WHERE			DataDate = @DataDate
	--AND				Status = 0 --- Should only apply for processing a new set of records because records are re-used

	END
	

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
/*
USAGE [ast].[Pls_01_SHCN_MSSPMembership]2021,3,'2021-03-01','2021-03-31','2021-03-01','2021-12-31','2021-01-26','2021-03-03'
@MbrYear,@MbrMonth,@RwEffectiveDate ,@RwExpirationDate, @MemberCurrentEffectiveDate, @MemberCurrentExpirationDate
*/




