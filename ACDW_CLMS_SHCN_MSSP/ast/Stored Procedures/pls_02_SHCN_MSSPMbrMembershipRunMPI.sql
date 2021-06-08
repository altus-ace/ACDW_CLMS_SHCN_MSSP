


CREATE	PROCEDURE [ast].[pls_02_SHCN_MSSPMbrMembershipRunMPI](@ClientKey INT,@EffectiveDate DATE)

AS

SET ANSI_WARNINGS OFF

BEGIN
BEGIN TRAN
BEGIN TRY

			--SELECT * FROM  [AceMPI].[ast].[MPI_SourceTable]
BEGIN
			TRUNCATE TABLE [AceMPI].[ast].[MPI_SourceTable] 
END


BEGIN
			TRUNCATE TABLE [AceMPI].[ast].[MPI_OUTPUTTABLE] 
END


BEGIN

			INSERT INTO [AceMPI].[ast].[MPI_SourceTable] (
						[ClientSubscriberId]
						, [ClientKey]
						, [MstrMrnKey]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [mbrGENDER]
						, [mbrDob]
						, [SrcFileName]
						, [AdiTableName]
						, [ExternalUniqueID]
						, [MbrState]
						, [DataDate])
			SELECT		ClientMemberKey
						, [ClientKey]
						, Ace_ID
						, [LastName]
						, [FirstName]
						, [MiddleName]
						, [GENDER]
						, [Dob]
						, [SrcFileName]
						, [AdiTableName]
						, [AdiKey]
						, [MbrState]
						, [DataDate]
			FROM		[ast].[MbrStg2_MbrData]
			WHERE		DataDate = (SELECT MAX(DataDate) FROM [ast].[MbrStg2_MbrData])
			AND			ClientKey = 16
			AND			RwEffectiveDate = @EffectiveDate



				-- Run Load_MPI_MasterJob algorithm to Generate Mstrmrnkeys for members
			IF (SELECT COUNT(*) FROM [AceMPI].[ast].[MPI_SourceTable]) >= 1
			EXECUTE ACEMPI.adw.[Load_MasterJob_MPI]


END


BEGIN
			
			--Update stg table with the mstrmrnkeys
			--	BEGIN TRAN				-- rollback -- COMMIT
			UPDATE		ast.MbrStg2_MbrData
			SET			Ace_ID = z.MstrMrn
			-- SELECT		z.ClientSubscriberId,a.ClientKey,MstrMrn,a.Ace_ID,a.ClientMemberKey,z.ClientKey --a.ExternalUniqueID,b.ExternalUniqueID,
			FROM		ast.MbrStg2_MbrData a
			JOIN		(	SELECT		ClientSubscriberId, ClientKey,a.ExternalUniqueID,b.ExternalUniqueID bExternalUniqueID
										,MstrMrnKey,MstrMrn
							FROM		AceMPI.ast.MPI_SourceTable a
							JOIN		AceMPI.ast.MPI_OutputTable b
							ON			a.ExternalUniqueID = b.ExternalUniqueID
						)z
			ON			a.ClientMemberKey = z.ClientSubscriberId
			WHERE		a.ClientKey = 16
			AND			LoadDate =  (	SELECT	MAX(LoadDate) 
										FROM	ast.MbrStg2_MbrData 
										WHERE	ClientKey = 16
									)

END



COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH


END


/*
USAGE: [ast].[pls_02_SHCN_MSSPMbrMembershipRunMPI]16,'2021-04-01'
**/	