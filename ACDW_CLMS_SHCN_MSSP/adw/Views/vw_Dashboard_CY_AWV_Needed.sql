



	/*WIP - Brit : 2020/12/15 - Rebuilding View to meet requirements */

CREATE VIEW [adw].[vw_Dashboard_CY_AWV_Needed]
AS 
    -- 
WITH CTE 
AS 
(
		SELECT src.*
		FROM
	(
		 SELECT	DISTINCT [ClientKey]
						,[ClientMemberKey]
						,[AttribNPI]
						,[AttribTIN]
						,'C' as CompliantStatus
						,[PrimaryServiceDate]
						,EffectiveAsOfDate
						,ROW_NUMBER() OVER(PARTITION BY ClientKey,ClientMemberKey,AttribNPI,AttribTIN 
							ORDER BY ClientKey,ClientMemberKey,PrimaryServiceDate DESC) arn
		 FROM	adw.FctAWVVisits m
		 WHERE	EffectiveAsOfDate = (SELECT MAX(EffectiveAsOfDate) FROM  adw.FctAWVVisits)
	) src
	WHERE src.arn = 1 
)


	SELECT		RANK() OVER (ORDER BY vis.PrimaryServiceDate, ClientRiskScoreLevel DESC) RankNo
				,mbr.[ClientKey]
				,mbr.[ClientMemberKey]
				,mbr.[Contract]
  				,mbr.PlanName
				,mbr.[NPI] as AttribNPI
				,mbr.[PcpPracticeTIN] as AttribTIN
				,mbr.ProviderChapter
				,mbr.ClientRiskScore
				,mbr.ClientRiskScoreLevel
				,mbr.FirstName
				,mbr.LastName
				,mbr.CurrentAge
				,mbr.DOB
				,mbr.Gender
				,mbr.MemberHomeAddress
  				,mbr.MemberHomeAddress1
				,mbr.MemberHomeCity
				,mbr.MemberHomeState
				,mbr.MemberHomeZip
				,mbr.MemberPhone
				,concat(1,mbr.MemberCellPhone) as MemberCellPhone
				,mbr.MemberHomePhone
				,mbr.ProviderNetwork
				,CASE WHEN YEAR(vis.PrimaryServiceDate) = YEAR(GETDATE()) THEN 'Y' ELSE 'N' END as CompliantStatus
				,vis.PrimaryServiceDate AS LstAWVDate
				,CASE WHEN DOD = '1900-01-01' THEN 'N' ELSE 'Y' END AS Expired
				,Year(Getdate()) as SvcYear
				--,gaps.CntOfGaps as Gaps
				,vis.EffectiveAsOfDate		--
	FROM		[adw].[vw_Dashboard_Membership] mbr
	LEFT JOIN	CTE vis
	ON			vis.ClientKey = mbr.ClientKey
	AND			vis.ClientMemberKey = mbr.ClientMemberKey
	--JOIN		[adw].[2020_tvf_Get_NumOfGaps] ((select max(QMDate) from  [adw].[vw_Dashboard_QMResultsbyMember_History])) gaps
	--ON		mbr.ClientMemberKey = gaps.ClientMemberKey
	WHERE		'2021-01-01' BETWEEN RwEffectiveDate AND RwExpirationDate
	AND			Active = 1

/***
SELECT * FROM [adw].[vw_Dashboard_CY_AWV_Needed]
WHERE Expired = 'N'
AND LstAWVDate is NULL
OR LstAWVDate BETWEEN DATEADD(YEAR, -1, GETDATE()) AND DATEADD(MONTH, -3, GETDATE())
ORDER BY LstAWVDate, ClientRiskScore DESC
***/

