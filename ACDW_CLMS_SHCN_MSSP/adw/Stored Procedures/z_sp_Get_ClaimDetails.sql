

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z_sp_Get_ClaimDetails]
	-- Add the parameters for the stored procedure here
	 @ClientMemberKey	VARCHAR(50)
	,@SeqClaimID		VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

IF (@ClientMemberKey <> '0' AND @SeqClaimID = '0')
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[LINE_NUMBER]					AS LineNumber	
      ,[SUB_LINE_CODE]					AS LineCode
      ,[DETAIL_SVC_DATE]				AS SvcStartDate
      ,[SVC_TO_DATE]					AS SvcEndDate
      ,[PROCEDURE_CODE]					AS ProcCode
      ,[MODIFIER_CODE_1]				AS ModCode1
      ,[MODIFIER_CODE_2]				AS ModCode2
      ,[MODIFIER_CODE_3]				AS ModCode3
      ,[MODIFIER_CODE_4]				AS ModCode4
      ,[REVENUE_CODE]					AS RevCode
      ,[PLACE_OF_SVC_CODE1]				AS POS1
      ,[PLACE_OF_SVC_CODE2]				AS POS2
      ,[PLACE_OF_SVC_CODE3]				AS POS3
      ,[QUANTITY]						AS Qty
	  ,[BILLED_AMT]						AS BilledAmt
      ,[PAID_AMT]						AS PaidAmt
  FROM [adw].[Claims_Details]
  WHERE [SUBSCRIBER_ID] = @ClientMemberKey
  ORDER BY SEQ_CLAIM_ID, LINE_NUMBER
ELSE IF (@SeqClaimID <> '0' AND @ClientMemberKey = '0')
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[LINE_NUMBER]					AS LineNumber	
      ,[SUB_LINE_CODE]					AS LineCode
      ,[DETAIL_SVC_DATE]				AS SvcStartDate
      ,[SVC_TO_DATE]					AS SvcEndDate
      ,[PROCEDURE_CODE]					AS ProcCode
      ,[MODIFIER_CODE_1]				AS ModCode1
      ,[MODIFIER_CODE_2]				AS ModCode2
      ,[MODIFIER_CODE_3]				AS ModCode3
      ,[MODIFIER_CODE_4]				AS ModCode4
      ,[REVENUE_CODE]					AS RevCode
      ,[PLACE_OF_SVC_CODE1]				AS POS1
      ,[PLACE_OF_SVC_CODE2]				AS POS2
      ,[PLACE_OF_SVC_CODE3]				AS POS3
      ,[QUANTITY]						AS Qty
	  ,[BILLED_AMT]						AS BilledAmt
      ,[PAID_AMT]						AS PaidAmt
  FROM [adw].[Claims_Details]
  WHERE [SEQ_CLAIM_ID] = @SeqClaimID
  ORDER BY SEQ_CLAIM_ID, LINE_NUMBER
ELSE
	SELECT [SEQ_CLAIM_ID]				AS ClaimID
      ,[SUBSCRIBER_ID]					AS MemberID
      ,[LINE_NUMBER]					AS LineNumber	
      ,[SUB_LINE_CODE]					AS LineCode
      ,[DETAIL_SVC_DATE]				AS SvcStartDate
      ,[SVC_TO_DATE]					AS SvcEndDate
      ,[PROCEDURE_CODE]					AS ProcCode
      ,[MODIFIER_CODE_1]				AS ModCode1
      ,[MODIFIER_CODE_2]				AS ModCode2
      ,[MODIFIER_CODE_3]				AS ModCode3
      ,[MODIFIER_CODE_4]				AS ModCode4
      ,[REVENUE_CODE]					AS RevCode
      ,[PLACE_OF_SVC_CODE1]				AS POS1
      ,[PLACE_OF_SVC_CODE2]				AS POS2
      ,[PLACE_OF_SVC_CODE3]				AS POS3
      ,[QUANTITY]						AS Qty
	  ,[BILLED_AMT]						AS BilledAmt
      ,[PAID_AMT]						AS PaidAmt
  FROM [adw].[Claims_Details]
  WHERE [SUBSCRIBER_ID] = @ClientMemberKey
  AND [SEQ_CLAIM_ID] = @SeqClaimID
  ORDER BY SEQ_CLAIM_ID, LINE_NUMBER
END

/***
EXEC [adw].[sp_Get_ClaimDetails] '1G08R12880C','D0285S92854263100'
***/

