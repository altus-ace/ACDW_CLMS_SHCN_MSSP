--================================================
--  Create Inline Table-valued Function template
--================================================

CREATE FUNCTION adw.[z_tvf_GetPrimarySecondaryDiagCode](@SubscriberId VARCHAR(50), @SeqClaimID VARCHAR(50))
RETURNS TABLE
AS RETURN
(
	--resultSet: sub, cliam, dx1, dx1Desc, dx2, dx2Desc
	   SELECT pvtOut.SUBSCRIBER_ID, pvtOut.SEQ_CLAIM_ID, PvtOut.[1] AS PrimaryDiagCode, PrimDesc.VALUE_CODE_NAME AS PrimaryDiagDescription
	       , PvtOut.[2] AS SecondaryDiagCode, SecondDesc.Value_Code_Name AS SecondDiageDescription
	   FROM (
	   SELECT Diags.SUBSCRIBER_ID
	       , Diags.SEQ_CLAIM_ID
	       , diagNumber
	       , diagCode    
	   FROM adw.Claims_Diags Diags    
	   WHERE (Diags.diagNumber = 1 or Diags.diagNumber = 2)
	   ) pd
	   PIVOT( MAX(pd.diagCode)
	       FOR diagNumber IN ([1],[2])
	   ) AS PvtOut
	   LEFT JOIN [lst].[LIST_ICD10CM] PrimDesc ON PrimDesc.value_code = pvtOut.[1]
	   LEFT JOIN [lst].[LIST_ICD10CM] SecondDesc ON SecondDesc.value_code = pvtOut.[2]
	   WHERE ((@SeqClaimID <> '0' AND SEQ_CLAIM_ID = @SeqClaimID) OR (@SeqClaimID = '0')) 		  
		  AND ((@SubscriberID <> '0' AND  pvtOut.SUBSCRIBER_ID = @SubscriberId) OR (@SubscriberId = '0'))		  
)
