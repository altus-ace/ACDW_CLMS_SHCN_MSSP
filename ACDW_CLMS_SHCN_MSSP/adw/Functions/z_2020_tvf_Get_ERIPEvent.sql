





CREATE FUNCTION [adw].[z_2020_tvf_Get_ERIPEvent]
(
 @PrimSvcDate_Start VARCHAR(20), 
 @PrimSvcDate_End   VARCHAR(20)
)
RETURNS TABLE
AS RETURN
(
	WITH cte AS (
	SELECT SEQ_CLAIM_ID,SUBSCRIBER_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,
		row_number()over(partition BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE) AS r
	FROM (SELECT b.*
		FROM [adw].[2020_tvf_Get_ERVisits] (@PrimSvcDate_Start,@PrimSvcDate_End) b 
		--WHERE b.ClaimType in ('60','61')
		--AND b.InstType IN ('ACUTE')
		--AND b.PrimaryServiceDate BETWEEN  @PrimSvcDate_Start AND  @PrimSvcDate_End
		) vw_tmp )

	SELECT DISTINCT
		c1.SUBSCRIBER_ID AS ClientMemberKey, 
		c1.SEQ_CLAIM_ID AS SeqClaimID_ER, c2.SEQ_CLAIM_ID AS SeqClaimID_IP,
		c1.PRIMARY_SVC_DATE as PrimSvcDate_ER,
		c1.SVC_TO_DATE as [SvcToDate_ER],
		--c1.r As RowNum_ER,
		c2.PRIMARY_SVC_DATE as [PrimSvcDate_IP],
		c2.SVC_TO_DATE as [SvcToDate_IP]
	FROM cte c1
		INNER JOIN [adw].[2020_tvf_Get_IPVisits] (@PrimSvcDate_Start,@PrimSvcDate_End) c2 
		ON c1.SUBSCRIBER_ID=c2.SUBSCRIBER_ID
	WHERE c1.SEQ_CLAIM_ID<>c2.SEQ_CLAIM_ID
		--AND c1.r+1=c2.r
		AND c1.PRIMARY_SVC_DATE BETWEEN c2.PRIMARY_SVC_DATE AND c2.SVC_TO_DATE
		AND c2.CLAIM_TYPE IN ('60')
	--ORDER BY c1.ClientMemberKey
)

/***
Usage: 
SELECT *
FROM adw.[2020_tvf_Get_ERIPEvent] ('01/01/2020','12/31/2020')
WHERE ClientMemberKey = '1AH9TX1MR00'

***/

