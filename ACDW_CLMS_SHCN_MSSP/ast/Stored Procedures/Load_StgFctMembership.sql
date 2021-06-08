
CREATE PROCEDURE [ast].[Load_StgFctMembership]
                 (@MbrYear SmallInt
				 ,@MbrMonth TinyINT
				 ,@RwEffectiveDate DATE
				 ,@RwExpirationDate DATE
				 ,@MemberCurrentEffectiveDate DATE
				 ,@MemberCurrentExpirationDate Date)

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
					,[MbrMbrMonth]			
					,[MbrMbrYear]			
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
					,[MbrState])			
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
					,[adi].[udf_ConvertToCamelCase]([FirstNM])				[mbrFirstName]
					,[adi].[udf_ConvertToCamelCase]([LastNM])				[mbrLastName]
					,[SexCD]												[mbrGender]
					,[BirthDTS]												[mbrDob]
					,b.DeathDTS												[mbrDOD]  --Cuurently all nulls
					,DATEDIFF(YY,[BirthDTS],@RwEffectiveDate)				[MbrCurrentAge] 
					,@MbrMonth												[MbrMbrMonth]
					,@MbrYear												[MbrMbrYear]
					,[adi].[udf_ConvertToCamelCase](b.MailingAddress01TXT)	[MemberHomeAddress]
					,[adi].[udf_ConvertToCamelCase](b.MailingAddress02TXT)	[MemberHomeAddress2]
					,[adi].[udf_ConvertToCamelCase](b.CityNM)				[MemberHomeCity]
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
	FROM			[adi].[Steward_MSSPMembership_2021] a
	LEFT JOIN		(	SELECT		MedicareBeneficiaryID,DeathDTS, MailingAddress01TXT,MailingAddress02TXT
									,MailingAddress03TXT,MailingAddress04TXT,MailingAddress05TXT, MailingAddress06TXT
									,CityNM,StateCD,PostalZipCD
						FROM		adi.Steward_MSSPBeneficiaryDemographic
						WHERE		DataDate = (	SELECT	MAX(DataDate) 
													FROM	adi.Steward_MSSPBeneficiaryDemographic
												)
					) b
	ON				a.MedicareBeneficiaryID = b.MedicareBeneficiaryID
	WHERE			Status = 0 
	AND				DataDate = (SELECT MAX(DataDate) FROM [adi].[Steward_MSSPMembership_2021])

	END
	

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
/*
USAGE [ast].[Load_StgFctMembership]2021,2,'2021-02-01','2021-02-28','2021-02-01','2021-12-31'
@MbrYear,@MbrMonth,@RwEffectiveDate ,@RwExpirationDate, @MemberCurrentEffectiveDate, @MemberCurrentExpirationDate
*/






