

CREATE FUNCTION [adi].[ValidateMemberCount]
(
	@QASSIGN1Year		INT,
	@QASSIGN4Year		INT		
)
RETURNS TABLE
AS
RETURN

( 
SELECT t1.[FileNM]
	,t1.[HealthInsuranceClaimNBR]
	,t1.[MedicareBeneficiaryID]
	,t1.[YearNBR] as t1YearNBR
	,t4.[YearNBR] as t4YearNBR
    ,t4.[RowNBR]
	,t4.[NPI]
	,t4.[TIN]
    FROM [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPAnnualmembership_HALRBASE] t1
	LEFT JOIN [adi].[Steward_MSSPAnnualMembershipTIN_NPICrosswalk_HALRBASE] t4
	ON t1.[MedicareBeneficiaryID] = t4.[MedicareBeneficiaryID]
	AND t1.[YearNBR] = t4.[YearNBR]
	WHERE t1.[YearNBR] = @QASSIGN1Year
	AND t4.[YearNBR] = @QASSIGN4Year
)

/***
Usage: 
SELECT [MedicareBeneficiaryID]
	,COUNT(DISTINCT [TIN]) as CntTIN
	,COUNT(DISTINCT [NPI]) as CntNPI
FROM [adi].[ValidateMemberCount] (2020,2020) 
GROUP BY [MedicareBeneficiaryID]

SELECT SUM(CntMBI) as SumMBI
from (
	SELECT mem.TIN, [PCP_PRACTICE_TIN_NAME]
	,COUNT(DISTINCT [HealthInsuranceClaimNBR]) as CntHICN
	,COUNT(DISTINCT [MedicareBeneficiaryID]) as CntMBI
	FROM [adi].[ValidateMemberCount] (2020,2020) mem
	LEFT JOIN lst.LIST_PCP phy
	ON mem.TIN = phy.[PCP_PRACTICE_TIN]
	WHERE phy.CLIENT_ID = '16'
	GROUP BY mem.TIN, [PCP_PRACTICE_TIN_NAME]
	--ORDER BY [PCP_PRACTICE_TIN_NAME]
	) a

***/


