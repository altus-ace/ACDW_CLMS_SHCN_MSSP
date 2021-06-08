
CREATE  FUNCTION [adw].[z_2020_tvf_Get_SNFStays]
(
 @EffectiveAsOfDate	DATE,
 @DaysElapse	      INT,			-- Days Elapse
 @PrimSvcDate_Start	DATE, 
 @PrimSvcDate_End		DATE
)
RETURNS TABLE
AS RETURN
(

SELECT b.ClientMemberKey, b.PrimaryServiceDate --, MIN(PrimaryServiceDate) as StartSvcDate, MAX(PrimaryServiceDate) as EndSvcDate
	,COUNT(Distinct Seq_ClaimID) as CntClaimID, SUM(LOS) as SumLos
FROM [adw].[FctInpatientVisits] b 

INNER JOIN [adw].[2020_tvf_Get_SNFAdmitFromIPDisch] ( @EffectiveAsOfDate,30,@PrimSvcDate_Start,@PrimSvcDate_End) exc		--
ON  b.ClientMemberKey = exc.ClientMemberKey										
AND b.SEQ_ClaimID = exc.SNFClaimID												

WHERE b.EffectiveAsOfDate =  @EffectiveAsOfDate
	AND b.ClaimType in ('20','30')
	AND b.InstType IN ('SNF')	
	AND b.ObvFlag = 0
	AND b.PrimaryServiceDate BETWEEN @PrimSvcDate_Start and @PrimSvcDate_End ---@PrimSvcDate_Start AND  @PrimSvcDate_End
GROUP BY  b.ClientMemberKey, b.PrimaryServiceDate
--ORDER BY  b.ClientMemberKey

)

/***
Usage: 
SELECT *
FROM [adw].[2020_tvf_Get_SNFStays] ('08-15-2020', 30,'01/01/2020','05/30/2020')
***/


