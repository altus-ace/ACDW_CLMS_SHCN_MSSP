

CREATE VIEW			[adw].[vw_SSRS_AttributionList]

AS


SELECT				
					a.ClientMemberKey
					,a.LastName + ' ' + FirstName				AS PatientFullName
					,a.DOB
					,a.Gender
					,a.MemberHomeAddress
					,a.MemberHomeAddress1
					,a.MemberHomeCity
					,a.MemberHomeState
					,a.MemberHomeZip
					,a.MemberHomePhone
					,a.ClientRiskScore
					,b.PatientIdentifiedHighRisk
					,a.ProviderLastName + ' ' + ProviderFirstName AS ProviderName
					,a.ProviderPracticeName
					,a.NPI
					,a.PcpPracticeTIN
					,a.ProviderChapter
					,a.MbrYear
					,a.MbrMonth  
FROM				adw.vw_Dashboard_Membership  a
JOIN				adi.tmp_MemberListValidation b
ON					a.ClientMemberKey = b.MBI_ID 



