CREATE VIEW dbo.tmp_vw_QASSIGN4_NPIsByMBI
AS (
SELECT DISTINCT q4t2.MedicareBeneficiaryID
	,MultNPI = STUFF(
				(SELECT ', ' + NPI FROM [adi].[Steward_MSSPAnnualMembershipTIN_NPICrosswalk_HALRBASE] q4t1
				WHERE q4t1.MedicareBeneficiaryID = q4t2.MedicareBeneficiaryID
				AND q4t1.YearNBR = 2020
				ORDER BY q4t1.RowNBR 
				FOR XML PATH (''))
				, 1,1, '') 
	FROM [adi].[Steward_MSSPAnnualMembershipTIN_NPICrosswalk_HALRBASE] q4t2
	--JOIN lst.List_PCP pcp ON pcp.PCP_NPI = q4t2.NPI
	WHERE q4t2.YearNBR = 2020
	GROUP BY q4t2.MedicareBeneficiaryID
	)
