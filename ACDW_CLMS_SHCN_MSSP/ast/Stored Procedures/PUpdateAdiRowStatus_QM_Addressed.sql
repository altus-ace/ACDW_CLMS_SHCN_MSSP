
CREATE PROCEDURE [ast].[PUpdateAdiRowStatus_QM_Addressed](
					@LoadDateAthena DATE, @LoadDateAthena_AWV DATE)

AS



	UPDATE		[adi].[Athena_EMR_QualityReport] 
	SET			RowStatus = 1
	WHERE		LoadDate = @LoadDateAthena

	UPDATE		[adi].[Athena_AWV]
	SET			RowStatus = 1
	WHERE		LoadDate = @LoadDateAthena_AWV


	/*
	EXECUTE [ast].[PUpdateAdiRowStatus_QM_Addressed]'2021-03-12','2021-03-13'
	*/

	
	