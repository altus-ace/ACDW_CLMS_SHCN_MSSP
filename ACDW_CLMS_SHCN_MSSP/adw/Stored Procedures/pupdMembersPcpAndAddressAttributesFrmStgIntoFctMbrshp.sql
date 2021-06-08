

CREATE PROCEDURE adw.pupdMembersPcpAndAddressAttributesFrmStgIntoFctMbrshp
					(@EffectiveDate DATE)

AS

BEGIN


	UPDATE		adw.FctMembership
	SET			ProviderNetwork = stg.ProviderNetwork
				,ProviderSpecialty = stg.ProviderSpecialty
				,ProviderPOD = stg.ProviderPOD
				,ProviderChapter = stg.ProviderChapter
				,ProviderAddressLine2 = stg.ProviderAddressLine2
				,MemberMailingAddress = stg.MemberMailingAddress
				,MemberMailingAddress1 = stg.MemberMailingAddress1
				,MemberMailingCity = stg.MemberMailingCity
				,MemberMailingState = stg.MemberMailingState
	FROM		adw.FctMembership fct
	JOIN		ast.MbrStg2_MbrData stg
	ON			fct.ClientMemberKey = stg.ClientMemberKey
	AND			fct.NPI = stg.NPI
	AND			fct.RwEffectiveDate = @EffectiveDate


	END