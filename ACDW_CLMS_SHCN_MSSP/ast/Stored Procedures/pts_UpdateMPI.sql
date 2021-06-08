
CREATE PROCEDURE		[ast].[pts_UpdateMPI]

AS

BEGIN TRAN
BEGIN TRY


BEGIN
--Update MstrMrnKey and ClientKey
UPDATE				[ast].[MbrInfoStg2_MbrDataUpdate]
SET					MstrMrnKey = Src.Ace_ID
					, ClientKey = Src.ClientKey	 -- select trg.ClientMemberKey,src.ClientMemberKey,mstrmrnkey,ace_id
FROM				[ast].[MbrInfoStg2_MbrDataUpdate] trg
JOIN				adw.FctMembership src
ON					trg.ClientMemberKey = src.ClientMemberKey
AND					Active = 1


END


BEGIN
--Update ClientKey to 0 where MstrMrnKey = 0
UPDATE				[ast].[MbrInfoStg2_MbrDataUpdate]
SET					ClientKey = 0
WHERE				ClientKey = ''
AND					MstrMrnKey = 0 

END

END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

COMMIT
