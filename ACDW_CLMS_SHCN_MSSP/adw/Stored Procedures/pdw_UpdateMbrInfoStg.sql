
CREATE PROCEDURE [adw].[pdw_UpdateMbrInfoStg]

AS

BEGIN

BEGIN TRAN
BEGIN TRY

UPDATE		ast.MbrInfoStg2_MbrDataUpdate
SET			stgRowStatus = 'Exported'
WHERE		stgRowStatus = 'Valid'
AND			CONVERT(DATE,CreateDate) = CONVERT(DATE,GETDATE()) 

END TRY

BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

COMMIT

END


