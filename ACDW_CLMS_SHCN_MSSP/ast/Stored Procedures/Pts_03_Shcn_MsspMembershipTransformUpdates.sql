

CREATE PROCEDURE [ast].[Pts_03_Shcn_MsspMembershipTransformUpdates] (@EffectiveDate DATE) -- [ast].[Pts_03_Shcn_MsspMembershipTransformUpdates]'2021-03-10'
AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN


--		select top 2 * from ast.MbrStg2_MbrData
	
	--Ai
	BEGIN	 --Transform Members Demo
			
		UPDATE	ast.MbrStg2_MbrData  SET FirstName = [adi].[udf_ConvertToCamelCase](FirstName) WHERE FirstName IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET LastName = [adi].[udf_ConvertToCamelCase](LastName) WHERE LastName IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberHomeAddress = ISNULL([adi].[udf_ConvertToCamelCase](MemberHomeAddress),'')	WHERE MemberHomeAddress IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberHomeAddress1 = ISNULL([adi].[udf_ConvertToCamelCase](MemberHomeAddress1),'') WHERE MemberHomeAddress1 IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberHomeCity = ISNULL([adi].[udf_ConvertToCamelCase](MemberHomeCity),'') WHERE  MemberHomeCity IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberMailingAddress = ISNULL([adi].[udf_ConvertToCamelCase](MemberMailingAddress),'') WHERE  MemberMailingAddress IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberMailingAddress1 = ISNULL([adi].[udf_ConvertToCamelCase](MemberMailingAddress1),'') WHERE  MemberMailingAddress1 IS NOT NULL AND stgRowStatus = 'Valid'	
		UPDATE	ast.MbrStg2_MbrData  SET MemberMailingCity = ISNULL([adi].[udf_ConvertToCamelCase](MemberMailingCity),'') WHERE  MemberMailingCity IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberMailingZip = ISNULL(MemberMailingZip,'') WHERE  MemberMailingZip IS NOT NULL AND stgRowStatus = 'Valid'	
		UPDATE	ast.MbrStg2_MbrData  SET MemberHomeState = ISNULL(MemberHomeState,'') WHERE  MemberHomeState IS NOT NULL AND stgRowStatus = 'Valid'
		UPDATE	ast.MbrStg2_MbrData  SET MemberMailingState = ISNULL(MemberMailingState,'') WHERE  MemberMailingState IS NOT NULL AND stgRowStatus = 'Valid'
						 --  select mbrFirstname,mbrLastName,MemberHomeAddress,MemberHomeAddress2,MemberHomeCity from ast.MbrStg2_MbrData

		UPDATE ast.MbrStg2_MbrData SET MemberHomeAddress = '' WHERE MemberHomeAddress IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberHomeAddress1 = '' WHERE MemberHomeAddress1 IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberHomeCity = '' WHERE MemberHomeCity IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberMailingAddress = '' WHERE MemberMailingAddress IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberMailingAddress1 = '' WHERE MemberMailingAddress1 IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberMailingCity = '' WHERE MemberMailingCity IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberMailingZip = '' WHERE MemberMailingZip IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberHomeState = '' WHERE MemberHomeState IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberMailingState = '' WHERE MemberMailingState IS NULL AND stgRowStatus = 'Valid'
		UPDATE ast.MbrStg2_MbrData SET MemberHomeZip = '' WHERE MemberHomeZip IS NULL AND stgRowStatus = 'Valid'

	END
	
	--Aii
	/* -- Not needed anymore
	BEGIN
			BEGIN TRAN
			UPDATE				ast.MbrStg2_MbrData
			SET					RiskScore = HCCRiskScore ---  select HCCRiskScore,RiskScore,mbi_id,mbi,ClientSubscriberId,trg.hicn,src.hicn
			FROM				ast.MbrStg2_MbrData trg
			JOIN				[adi].[tmp_MemberListValidation] src
			ON					trg.ClientSubscriberID = src.MBI_ID
			WHERE				stgRowStatus = 'Valid' 
			COMMIT
			
	END*/
	
	--(B) Update Transform Gender Column
	BEGIN
			UPDATE		ast.StgFctMembership
			SET			Gender = 'M'
			WHERE		Gender = '1'
			
			UPDATE		ast.StgFctMembership
			SET			Gender = 'F'
			WHERE		Gender LIKE '2'
	END
				
	--C Update Provider Details, TIN, POD, TIN NAME, Provider Name *** LST_LIST_PCP NEEDS TO UPDATE
	
	BEGIN
			UPDATE		ast.MbrStg2_MbrData
			SET			
						ProviderChapter = [adi].[udf_ConvertToCamelCase](ISNULL(PCP_POD,'')) 
						,ProviderPracticeName = [adi].[udf_ConvertToCamelCase](ISNULL(PCP_PRACTICE_TIN_NAME,''))
						,ProviderAddressLine1 = [adi].[udf_ConvertToCamelCase](ISNULL(PCP__ADDRESS,''))
						,ProviderAddressLine2 = [adi].[udf_ConvertToCamelCase](ISNULL(PCP__ADDRESS2,''))
						,ProviderCity = [adi].[udf_ConvertToCamelCase](ISNULL(PCP_CITY,''))
						,ProviderFirstName = [adi].[udf_ConvertToCamelCase](ISNULL(PCP_FIRST_NAME,''))
						,ProviderLastName = [adi].[udf_ConvertToCamelCase](ISNULL(PCP_LAST_NAME,''))
						,PcpPracticeTIN = ISNULL(src.PCP_Practice_Tin,'')
						,ProviderMI = ISNULL(PCP_MI,'')
						,ProviderZip = ISNULL(PCP_ZIP,'')
						,ProviderPhone = ISNULL(PCP_PHONE,'')
						,ProviderSpecialty = [adi].[udf_ConvertToCamelCase](ISNULL(PRIM_SPECIALTY,''))
						,ProviderPOD = src.PCP_POD
						,ProviderCounty = src.County
						,ProviderNetwork = (CASE WHEN AccountType NOT IN ('SHCN_SMG','SHCN_AFF') THEN 'Ace' 
											ELSE AccountType
											END )
			FROM		ast.MbrStg2_MbrData trg
			JOIN		(	SELECT	*
							FROM	(
									SELECT	*
											,ROW_NUMBER()OVER(PARTITION BY PCP_NPI ORDER BY EffectiveDate) RwCnt
									FROM	lst.List_PCP
									) c
									WHERE	RwCnt = 1
						) src
			ON			trg.NPI = src.PCP_NPI 
			WHERE		RwEffectiveDate = @EffectiveDate

	--D Update members phone no 
	
	BEGIN
		
	UPDATE			ast.MbrStg2_MbrData
	SET				MemberCellPhone = ISNULL([lst].[fnStripNonNumericChar](PatientMobilePhone),'')
	FROM			ast.MbrStg2_MbrData trg
	JOIN			[adi].[MSSPPatientPhoneNumber] src
	ON				trg.ClientMemberKey = src.PatientPolicyidNumber
	WHERE			trg.stgRowStatus = 'Valid'
	AND				RwEffectiveDate = @EffectiveDate
		
	UPDATE			ast.MbrStg2_MbrData 
	SET				MemberHomePhone = ISNULL([lst].[fnStripNonNumericChar](PatientHomePhone),'')   --- SELECT MemberHomePhone, PatientHomePhone
	FROM			ast.MbrStg2_MbrData  a
	JOIN			[adi].[MSSPPatientPhoneNumber] b
	ON				ClientMemberKey = PatientPolicyidNumber
	WHERE			a.stgRowStatus = 'Valid'
	AND				RwEffectiveDate = @EffectiveDate

	UPDATE			ast.MbrStg2_MbrData 
	SET				MemberPhone = ISNULL([lst].[fnStripNonNumericChar](PatientMobilePhone),'') --- SELECT MemberPhone, PatientMobilePhone
	FROM			ast.MbrStg2_MbrData  a
	JOIN			[adi].[MSSPPatientPhoneNumber] b
	ON				a.ClientMemberKey = b.PatientPolicyidNumber
	WHERE			a.stgRowStatus = 'Valid'
	AND				RwEffectiveDate = @EffectiveDate

	--E Assign values to invalid NPI and TINS
	
	UPDATE	ast.MbrStg2_MbrData
	SET		NPI = '1111111111' 
			, PcpPracticeTIN = '111111111' 
	WHERE	NPI = '-'
	AND		RwEffectiveDate = @EffectiveDate
	

	--F Update Active Flag using MbrDOD field and Exclusion File for update
	UPDATE			ast.MbrStg2_MbrData
	SET				Active = 0   -- SELECT ClientMemberKey,MbrYear,MbrMonth, NPI,PcpPracticeTIN , Active, DOD FROM ast.MbrStg2_MbrData
	WHERE			@EffectiveDate BETWEEN RwEffectiveDate AND RwExpirationDate 
	AND				DOD <> '' 

	--G ----Update Stg DataData to a new datadate to enable processing downstream

	UPDATE			ast.MbrStg2_MbrData
	SET				DataDate = @EffectiveDate		---  SELECT datadate,* FROM ast.MbrStg2_MbrData
	WHERE			RwEffectiveDate = @EffectiveDate

	--H Apply Exclusion BENEX
	 ----Check this out before you process
	EXECUTE [adw].[p_PdwMbr_UpdateFctMembershipExcluded_Stg] @EffectiveDate


	--I Update Members plan
	UPDATE		ast.MbrStg2_MbrData
	SET			SubgrpName = p.TargetValue
		--   SELECT		 ProviderChapter,ProviderPOD,SourceValue,TargetValue,PlanName,SubgrpName,Contract,LOB,clientMemberKey
	FROM		 ast.MbrStg2_MbrData t
	JOIN		(	SELECT * 
					FROM lst.lstPlanMapping
					WHERE ClientKey = 16
				) p
	ON			t.ProviderChapter = SourceValue
	WHERE		t.RwEffectiveDate = @EffectiveDate
	
	-- J  Update ClientRiskScoreLevel
	IF OBJECT_ID('tempdb..#ClientRiskScoreLevel') IS NOT NULL DROP TABLE #ClientRiskScoreLevel
	
	Create Table #ClientRiskScoreLevel (mbi_id varchar (50),rs decimal(25,2))
	Insert Into #ClientRiskScoreLevel(mbi_id,rs)
	Select  MBI_ID
			,Case PatientidentifiedHighRisk 
				When 'Y' Then 1.00
				When 'N' Then 0.00 
				End PatientidentifiedHighRisk
	From	[adi].[tmp_MemberListValidation]
	
	Begin Tran 
	Update		ast.MbrStg2_MbrData
	SET			ClientRiskScoreLevel = rs -- select ClientRiskScoreLevel,rs,ClientMemberKey,mbi_id
	FROM		ast.MbrStg2_MbrData a
	JOIN		#ClientRiskScoreLevel b
	ON			a.ClientMemberKey = b.mbi_id
	WHERE		RwEffectiveDate = @EffectiveDate
	
	Commit
	
	END
	
	END
	
	COMMIT
	END TRY
	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH
	
	

	/*
	USAGE: EXECUTE [ast].[Pts_03_Shcn_MsspMembershipTransformUpdates]'2021-04-01'
	**/


	--Validation Check
		SELECT		COUNT(*)RecCnt,Active
		FROM		ast.MbrStg2_MbrData a
		WHERE		MbrYear = 2021
		AND			RwEffectiveDate = @EffectiveDate
		GROUP BY	Active


		SELECT		COUNT(*)RecCnt,Active,Excluded
		FROM		ast.MbrStg2_MbrData a
		WHERE		MbrYear = 2021
		AND			RwEffectiveDate = @EffectiveDate
		GROUP BY	Active,Excluded
	--------------------------------------------------------------------------------------
		/* Do not process. Reads at load to staging
	BEGIN
	--B
	--Get updated script from adw.load_fctmembership
	UPDATE			ast.MbrStg2_MbrData
	SET				mbrDOD = src.DeathDTS
	FROM			ast.MbrStg2_MbrData trg
	LEFT JOIN		[adi].[Steward_MSSPBeneficiaryDemographic] src
	ON				trg.ClientSubscriberId = src.MedicareBeneficiaryID
	WHERE			src.MedicareBeneficiaryID IS NOT NULL  
	
	END*/
	
	/*
	-----Update on adw Not required. Captured already
	--DOD
	--BEGIN TRAN --ROLLBACK
	UPDATE			adw.FctMembership
	SET				DOD = src.DeathDTS
	FROM			adw.[FctMembership] trg
	LEFT JOIN		[adi].[Steward_MSSPBeneficiaryDemographic] src
	ON				trg.ClientMemberKey = src.MedicareBeneficiaryID
	WHERE			CONVERT(date,src.CreateDate) = (select CONVERT(DATE,MAX(createdate)) from adi.Steward_MSSPBeneficiaryDemographic)
					and Active = 1
					--COMMIT
	
	
	SELECT			DISTINCT a.ClientMemberKey,b.PreviousClientMemberKey
					,b.CurrentClientMemberKey,Active
					,PreviousEffectiveDate,PreviousExpirationDate
	FROM			adw.FctMembership a
	JOIN			[adw].[MbrClientMemberKeyHistory] b
	on				a.ClientMemberKey = b.PreviousClientMemberKey
	
	--begin tran --rollback MembershipBeneficiaryCrossReference
	UPDATE			adw.FctMembership
	SET				ClientMemberKey = CurrentClientMemberKey
	FROM			adw.FctMembership a
	JOIN			[adw].[MbrClientMemberKeyHistory] b
	on				a.ClientMemberKey = b.PreviousClientMemberKey --COMMIT
	*/
	

	/*    Not required for now since we do a direct insert from source
	--(C) Update Member Demographics
	  
	BEGIN
	--A
	;WITH CTE_DemoUpdate
	AS
	(
	SELECT 	DISTINCT		MedicareBeneficiaryID
					,MemberHomeAddress			= (MailingAddress01TXT) 
					,MemberHomeAddress1			= (src.MailingAddress02TXT)
					,MemberHomeCity				= (src.CityNM)
					,MemberHomeState			= (src.StateCD)
					,MemberHomeZip				= (src.PostalZipCD)
					,MemberMailingZip			= (src.PostalZipCD)
					,MemberMailingAddress		= (src.MailingAddress01TXT)
					,MemberMailingAddress1		= (src.MailingAddress02TXT)
					,MemberMailingCity			= (src.CityNM)
					,MemberMailingState		    = (src.StateCD)
					,CountyNumber			    = (src.FIPSStateCD)
	
	
	FROM			ast.MbrStg2_MbrData trg
	LEFT JOIN		[adi].[Steward_MSSPBeneficiaryDemographic] src
	ON				trg.ClientSubscriberId = src.MedicareBeneficiaryID
	WHERE			src.MedicareBeneficiaryID IS NOT NULL 
	--AND				src.DataDate = (SELECT MAX(Datadate) FROM [adi].[Steward_MSSPBeneficiaryDemographic])
		
	)
	
	UPDATE			ast.MbrStg2_MbrData
	SET				MemberHomeAddress = [adi].[udf_ConvertToCamelCase](src.MemberHomeAddress)
					,MemberHomeAddress2 = [adi].[udf_ConvertToCamelCase](src.MemberHomeAddress1)
					,MemberHomeCity = [adi].[udf_ConvertToCamelCase](src.MemberHomeCity)
					,MemberHomeState = src.MemberHomeState
					,MemberHomeZip = [adi].[udf_ConvertToCamelCase](src.MemberHomeZip)
					,MemberMailingZip = [adi].[udf_ConvertToCamelCase](src.MemberMailingZip)
					,MemberMailingAddress = [adi].[udf_ConvertToCamelCase](src.MemberMailingAddress)
					,MemberMailingAddress1 = [adi].[udf_ConvertToCamelCase](src.MemberMailingAddress1)
					,MemberMailingCity = [adi].[udf_ConvertToCamelCase](src.MemberMailingCity)
					,MemberMailingState = src.MemberMailingState
					,CountyNumber = [adi].[udf_ConvertToCamelCase](src.CountyNumber)
	FROM			ast.MbrStg2_MbrData trg
	JOIN			CTE_DemoUpdate src
	ON				trg.ClientSubscriberId = src.MedicareBeneficiaryID
		
	*/
	
