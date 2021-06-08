
CREATE PROCEDURE [adw].[Pdw_Load_FctMembership]
                 (@ClientKey INT)

AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN

BEGIN
				  
				 
	INSERT INTO  adw.FctMembership	
					([AdiKey]
					,[SrcFileName]
					,[AdiTableName]
					,[LoadDate]
					,[DataDate]
					,[RwEffectiveDate]
					,[RwExpirationDate]
					,[ClientKey]
					,[Ace_ID]
					,[ClientMemberKey]
					,[MBI]
					,[HICN]
					,[FirstName]
					,[LastName]
					,[MiddleName]
					,[Gender]
					,[DOB]
					,[DOD]
					,[CurrentAge]
					,[MbrMonth]
					,[MbrYear]
					,[MemberHomeAddress]
					,[MemberHomeAddress1]
					,[MemberHomeCity]
					,[MemberHomeState]
					,[MemberHomeZip]
					,[CountyNumber]
					,[MemberMailingAddress]
					,[MemberMailingAddress1]
					,[MemberMailingCity]
					,[MemberMailingState]
					,[MemberMailingZip]
					,[LOB]
					,[Contract]
					,[NPI]
					,[ProviderFirstName]
					,[ProviderLastName]
					,[ProviderMI]
					,[PcpPracticeTIN]
					,[ProviderPracticeName]
					,[ProviderPOD]
					,[ProviderChapter]
					,[ProviderAddressLine1]
					,[ProviderAddressLine2]
					,[ProviderCity]
					,[ProviderZip]
					,[ProviderPhone]
					,ProviderSpecialty
					,[ClientRiskScore]
					,[MemberCurrentEffectiveDate]
					,[MemberCurrentExpirationDate]
					,[PlanName]
					,[MemberPhone]
					,[MemberCellPhone]
					,[MemberHomePhone]
					,[Active])
	SELECT			AdiKey
					,[SrcFileName]
					,AdiTableName
					,GETDATE()
					,[DataDate]
					,RwEffectiveDate
					,RwExpirationDate
					,ClientKey
					,MstrMrnKey
					,ClientSubscriberId
					,MBI
					,HICN
					,MbrFirstName
					,MbrLastName
					,MbrMiddleName
					,MbrGender
					,MbrDOB
					,[MbrDOD]
					,[MbrCurrentAge]
					,MbrMonth
					,MbrYear
					,[MemberHomeAddress]
					,[MemberHomeAddress2]
					,[MemberHomeCity]
					,[MemberHomeState]
					,[MemberHomeZip]
					,[CountyNumber]
					,[MemberHomeAddress]
					,[MemberHomeAddress2]
					,[MemberHomeCity]
					,[MemberHomeState]
					,[MemberHomeZip]
					,[plnProductPlan]
					,[plnProductSubPlan]
					,prvNPI
					,[ProviderFirstName]
					,[ProviderLastName]
					,[ProviderMI]
					,[PrvTIN]
					,[ProviderPracticeName]
					,[ProviderChapter]
					,[ProviderChapter]
					,[ProviderAddressLine1]
					,[ProviderAddressLine2]
					,[ProviderCity]
					,[ProviderZip]
					,[ProviderPhone]
					,ProviderSpecialty
					,[RiskScore]
					,MemberCurrentEffectiveDate
					,MemberCurrentExpirationDate
					,[plnProductPlan]
					,[MemberPhone]
					,[MemberCellPhone]
					,[MemberHomePhone]
					,[Active]
	FROM			[ast].[MbrStg2_MbrData]
	WHERE			stgRowStatus = 'Valid'
	
END



--Update Active Field
/*
BEGIN

UPDATE adw.FctMembership
SET Active = 0 --SELECT MBRYEAR, MBRMONTH, ACTIVE FROM adw.FctMembership
WHERE MbrYear = YEAR(GETDATE())
AND MbrMonth  <> MONTH(GETDATE()) --COMMIT

END
*/


COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

/**
USAGE
EXECUTE [adw].[Pdw_Load_FctMembership]16
**/

--Only used to update DOD from new quartely file
/*UPDATE		adw.FctMembership
	SET			DOD = DeathDTS
	FROM		adw.FctMembership a
	JOIN		(		
						SELECT	DataDate,MedicareBeneficiaryID,DeathDTS 
						FROM	[ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPQuarterlyMembership]
						WHERE	DataDate = (SELECT MAX(DataDate) FROM [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPQuarterlyMembership])
				)  b
	ON			a.ClientMemberKey = b.MedicareBeneficiaryID
	WHERE		MbrYear = 2020 and MbrMonth = 12*/
	--UPDATE Active to 0 for DOD <> 1900-01-01
	/*
	select a.Ace_ID, b.Ace_ID from ast.StgFctMembership a
	join adw.FctMembership b
	on a.Ace_ID = b.Ace_ID
	where a.Ace_ID = b.Ace_ID

	select active,dod from adw.FctMembership where MbrYear = 2021  and MbrMonth = 1 and Active = 1
	and dod <> '1900-01-01'
	order by dod desc commit
	begin tran
	update adw.FctMembership
	set Active = 0  --select * from adw.FctMembership
	where MbrYear = 2021  and MbrMonth = 1 and dod <> '1900-01-01'

	
	---Updating of DOD monthly.
	BEGIN
	
	
					;WITH CTE_MaxDod
					AS
					(
						SELECT DISTINCT MedicareBeneficiaryID,MAX(DeathDTS) DeathDTS
						FROM		[adi].[Steward_MSSPBeneficiaryDemographic] 
						WHERE		MedicareBeneficiaryID <> ''
						AND			DataDate = (	
													SELECT MAX(DataDate) 
													FROM   [adi].[Steward_MSSPBeneficiaryDemographic]
											   )
						GROUP BY	MedicareBeneficiaryID
					)
	
						UPDATE		adw.FctMembership
						SET			DOD = b.DeathDTS	
						FROM		adw.FctMembership a
						JOIN		CTE_MaxDod b
						ON			a.ClientMemberKey = b.MedicareBeneficiaryID
						WHERE		MbrYear =  YEAR(GETDATE())
						AND			MbrMonth = MONTH(GETDATE())
	
	
	
	END
		*/