CREATE VIEW adw.[Z_vw_Dashboard_IPUTIL]

AS

SELECT      
              IP.DataDate
            , IP.ClientKey
			, IP.ClientMemberKey
			, IP.EffectiveAsOfDate
			, IP.SEQ_ClaimID 
            , IP.PrimaryServiceDate
			, IP.PrimaryDiagnosis
		--	, IP.RevCode
			, IP.VendorID
			, IP.VendorName
			, IP.SVCProviderID
			, IP.SVCProviderFullName
			, IP.AttProviderID
			, IP.AttProviderFullName 
            , IP.LOS
			, IP.ClaimType
			, IP.BillType
			, IP.AttribNPI
			, IP.AttribTIN
            , IP.FacilityPrefferedFlag
			, IP.ERToIPFlag
			, IP.ObvFlag
			, IP.SvcNPISpecialty 
            , IP.AttNPISpecialty
			, CH.CATEGORY_OF_SVC
			, CH.DRG_CODE
			, CH.BILL_TYPE
			, CH.CLAIM_TYPE 
            , CH.TOTAL_BILLED_AMT
			, CH.TOTAL_PAID_AMT
			, concat(mbr.LastName , ', ', mbr.FirstName ) as MemberName
		--	, mbr.LastName
			, mbr.DOB
			, mbr.MemberID
			, mbr.PlanName
			, mbr.ProviderChapter
			, mbr.PcpPracticeTIN
			, mbr.ProviderPracticeName
			, mbr.NPI
			, concat(mbr.ProviderLastName , ', ', mbr.ProviderFirstName ) as ProviderName
			, mbr.RiskScoreUtilization
			, mbr.RiskScoreClinical
			, mbr.ClientRiskScore
			, mbr.ClientRiskScoreLevel
			, mbr.RiskScoreHRA
						 
FROM           adw.vw_Dashboard_InpatientVisits IP left JOIN
                         adw.Claims_Headers CH  ON IP.SEQ_ClaimID =   CH.SEQ_CLAIM_ID
						 LEFT JOIN adw.vw_Dashboard_Membership mbr on mbr.clientmemberkey = IP.clientmemberkey 
						 and mbr.mbryear = year(IP.EffectiveAsOfDate) 
						 and mbr.MbrMonth = MONTH(IP.EffectiveAsOfDate)







