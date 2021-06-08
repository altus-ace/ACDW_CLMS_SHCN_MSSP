


CREATE FUNCTION [adw].[z_2020_tvf_Get_ClaimsTMEByMember]
(
 @PrimSvcDate_Start DATE, 
 @PrimSvcDate_End   DATE
)

RETURNS TABLE
AS RETURN
(
	SELECT DISTINCT @PrimSvcDate_Start as PrimSvcDate_Start,@PrimSvcDate_End as PrimSvcDate_End
			,ClientMemberKey
			,PrimSvcYr
			,PrimSvcMth
			,SUM(CntClaims)				AS CntClaims
			,SUM(SumPaidAmt)			AS TotPaidAmt
			,SUM(HHAPaidAmt)			AS HHAPaidAmt
			,SUM(SNFPaidAmt)			AS SNFPaidAmt
			,SUM(OPPaidAmt)				AS OPPaidAmt
			,SUM(HospicePaidAmt)		AS HospicePaidAmt
			,SUM(IPPaidAmt)				AS IPPaidAmt
			,SUM(PhyPaidAmt)			AS PhyPaidAmt
			,SUM(OtherPaidAmt)			AS OtherPaidAmt
			,SUM(PrefSumPaidAmt)		AS PrefTotPaidAmt
			,SUM(PrefHHAPaidAmt)		AS PrefHHAPaidAmt
			,SUM(PrefSNFPaidAmt)		AS PrefSNFPaidAmt
			,SUM(PrefOPPaidAmt)			AS PrefOPPaidAmt
			,SUM(PrefHospicePaidAmt)	AS PrefHospicePaidAmt
			,SUM(PrefIPPaidAmt)			AS PrefIPPaidAmt
			,SUM(PrefPhyPaidAmt)		AS PrefPhyPaidAmt
			,SUM(PrefOtherPaidAmt)		AS PrefOtherPaidAmt

	FROM (
		SELECT --DISTINCT @PrimSvcDate_Start as PrimSvcDate_Start,@PrimSvcDate_End as PrimSvcDate_End
			B1.[SUBSCRIBER_ID] as ClientMemberkey
			,YEAR(CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)) as PrimSvcYr
			,MONTH(CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)) as PrimSvcMth
			,CLAIM_TYPE
			,COUNT(DISTINCT B1.SEQ_CLAIM_ID) AS CntClaims
			,SUM(B1.[TOTAL_PAID_AMT]) AS SumPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS PrefSumPaidAmt
			,CASE WHEN CLAIM_TYPE = '10' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS HHAPaidAmt
			,CASE WHEN CLAIM_TYPE = '20' OR CLAIM_TYPE = '30' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS SNFPaidAmt
			,CASE WHEN CLAIM_TYPE = '40' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS OPPaidAmt
			,CASE WHEN CLAIM_TYPE = '50' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS HospicePaidAmt
			,CASE WHEN CLAIM_TYPE = '60' OR CLAIM_TYPE = '61' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS IPPaidAmt
			,CASE WHEN CLAIM_TYPE = '71' OR CLAIM_TYPE = '72' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS PhyPaidAmt
			,CASE WHEN CLAIM_TYPE NOT IN ('10','20','30','40','50','60','61','71','72') THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS OtherPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '10' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END						AS PrefHHAPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '20' OR CLAIM_TYPE = '30' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END	AS PrefSNFPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '40' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END						AS PrefOPPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '50' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END						AS PrefHospicePaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '60' OR CLAIM_TYPE = '61' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END	AS PrefIPPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE = '71' OR CLAIM_TYPE = '72' THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END	AS PrefPhyPaidAmt
			,CASE WHEN d.FacilityName IS NOT NULL AND CLAIM_TYPE NOT IN ('10','20','30','40','50','60','61','71','72') THEN SUM(B1.[TOTAL_PAID_AMT]) ELSE 0 END AS PrefOtherPaidAmt
		FROM [adw].[Claims_Headers] B1
		LEFT JOIN [lst].[lstPreferredFacility] d		--
			ON b1.VENDOR_ID = d.NPI						--
		WHERE YEAR(CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)) BETWEEN YEAR(@PrimSvcDate_End)-2 AND YEAR(@PrimSvcDate_End)
			AND CLAIM_TYPE			IN ('10','20','30','40','50','60','61','71','72')
			--AND CATEGORY_OF_SVC <> 'PHARMACY'
			--AND B1.PROCESSING_STATUS			= 'P'
			--AND B1.CLAIM_STATUS				= 'P'
		GROUP BY B1.[SUBSCRIBER_ID]
			,B1.[CLAIM_TYPE]
			,YEAR(CONVERT(DATETIME, B1.PRIMARY_SVC_DATE))
			,MONTH(CONVERT(DATETIME, B1.PRIMARY_SVC_DATE))
			,d.FacilityName
		) tot 
	GROUP BY ClientMemberKey
		,PrimSvcYr
		,PrimSvcMth
)

/***
Usage: 
SELECT SUM(TotPaidAmt), SUM(PrefS
FROM [adw].[2020_tvf_Get_ClaimsTMEByMember] ('2020-01-01','2020-03-01') a
ORDER BY SUBSCRIBER_ID
***/


