
CREATE PROCEDURE [adw].[Pupd_LineageKeysInAdiAndStaging](@EffectiveDate DATE)

AS


BEGIN
		
		UPDATE	ast.MbrStg2_MbrData
		SET		stgRowStatus = 'Exported'
		WHERE	stgRowStatus = 'Valid'
		AND		RwEffectiveDate = @EffectiveDate



		UPDATE	ast.FctMembership
		SET		stgRowStatus = 'Exported'
		WHERE	stgRowStatus = 'Valid'
		AND		RowEffectiveDate = @EffectiveDate

		--UPDATE	[adi].[MSSPPatientAttributionList]
		--SET		Status = 1
		--WHERE	Status = 0

END