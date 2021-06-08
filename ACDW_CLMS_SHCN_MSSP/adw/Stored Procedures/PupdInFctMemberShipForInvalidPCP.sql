
CREATE PROCEDURE adw.PupdInFctMemberShipForInvalidPCP(@EffectiveDate DATE)

AS


BEGIN

		 UPDATE adw.FctMembership
		 SET	ProviderAddressLine1 = 'NA'
				,ProviderAddressLine2 = 'NA'
				,ProviderChapter = 'NA'
				,ProviderCity = 'NA'
				,ProviderCounty = 'NA'
				,ProviderFirstName = 'NA'
				,ProviderLastName = 'NA'
				,ProviderMI = 'NA'
				,ProviderPOD = 'NA'
				,ProviderPracticeName = 'NA'
				,ProviderNetwork = 'NA'
				,ProviderZip = 'NA'
				,ProviderPhone = 'NA'
				,ProviderSpecialty = 'NA' ------ SELECT * FROM adw.FctMembership
		WHERE	NPI = '1111111111'
		AND		PcpPracticeTIN = '111111111'
		AND		RwEffectiveDate = @EffectiveDate


END