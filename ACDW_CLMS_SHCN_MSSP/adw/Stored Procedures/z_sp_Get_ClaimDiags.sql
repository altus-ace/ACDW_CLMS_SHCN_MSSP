


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z_sp_Get_ClaimDiags]
	-- Add the parameters for the stored procedure here
	 @ClientMemberKey	VARCHAR(50)
	,@SeqClaimID		VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

IF (@ClientMemberKey <> '0' AND @SeqClaimID = '0')
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[ICD_FLAG]						AS IcdFlg
      ,[diagNumber]						AS SeqNo
      ,[diagCodeWithoutDot]				AS IcdCode
	  ,l.VALUE_CODE_NAME				AS IcdDesc
      ,[diagPoa]						AS IcdPOA
  FROM [adw].[Claims_Diags] a
  LEFT JOIN [lst].[LIST_ICD10CM] l
  ON a.[diagCode] = l.[VALUE_CODE]
  WHERE a.[SUBSCRIBER_ID] = @ClientMemberKey
  AND getdate() BETWEEN l.EffectiveDate AND l.ExpirationDate
  AND l.ACTIVE = 'Y'
  ORDER BY SEQ_CLAIM_ID, diagNumber
ELSE IF (@SeqClaimID <> '0' AND @ClientMemberKey = '0')
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[ICD_FLAG]						AS IcdFlg
      ,[diagNumber]						AS SeqNo
      ,[diagCodeWithoutDot]				AS IcdCode
  	  ,l.VALUE_CODE_NAME				AS IcdDesc
      ,[diagPoa]						AS IcdPOA
  FROM [adw].[Claims_Diags] a
  LEFT JOIN [lst].[LIST_ICD10CM] l
  ON a.[diagCode] = l.[VALUE_CODE]
  WHERE a.SEQ_CLAIM_ID = @SeqClaimID
  AND getdate() BETWEEN l.EffectiveDate AND l.ExpirationDate
  AND l.ACTIVE = 'Y'
  ORDER BY SEQ_CLAIM_ID, diagNumber
ELSE
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[ICD_FLAG]						AS IcdFlg
      ,[diagNumber]						AS SeqNo
      ,[diagCodeWithoutDot]				AS IcdCode
	  ,l.VALUE_CODE_NAME				AS IcdDesc
      ,[diagPoa]						AS IcdPOA
  FROM [adw].[Claims_Diags] a
  LEFT JOIN [lst].[LIST_ICD10CM] l
  ON a.[diagCode] = l.[VALUE_CODE]
  WHERE a.[SUBSCRIBER_ID] = @ClientMemberKey
  AND a.SEQ_CLAIM_ID = @SeqClaimID
  AND getdate() BETWEEN l.EffectiveDate AND l.ExpirationDate
  AND l.ACTIVE = 'Y'
  ORDER BY SEQ_CLAIM_ID, diagNumber
END

/***
EXEC [adw].[sp_Get_ClaimDiags] '1G08R12880C','D0285S92854263100'
***/



