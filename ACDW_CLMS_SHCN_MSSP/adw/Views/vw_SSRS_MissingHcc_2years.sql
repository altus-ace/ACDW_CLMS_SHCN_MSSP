

CREATE VIEW  [adw].[vw_SSRS_MissingHcc_2years]


AS

SELECT DISTINCT HCC.SUBSCRIBER_ID AS ClientMemberKey, 
       hcc.PRIMARY_SVC_DATE, 
       HCC.HCC_CODE, 
       hcc.ValueCode, 
       HccCodes.HCC_Description, 
       Mbr.NPI AS AttribNPI, 
       mbr.ProviderLastName, 
       mbr.ProviderFirstName, 
       Mbr.PcpPracticeTIN AS AttribTIN, 
       mbr.ProviderPracticeName, 
       Mbr.ProviderChapter, 
       Mbr.LastName, 
       mbr.FirstName, 
       mbr.MemberHomeAddress + mbr.MemberHomeAddress1 AS MemberHomeAddress, 
       mbr.MemberHomeCity, 
       mbr.MemberHomeState, 
       mbr.MemberHomeZip, 
       mbr.MemberHomePhone, 
       mbr.Dob, 
       Mbr.ClientRiskScore, 
       Mbr.AceRiskScore
FROM [adw].[2020_tvf_Get_ClaimsByHCC]
(DATEADD(yy, DATEDIFF(yy, 0, DATEADD(yy, DATEDIFF(yy, 0, '2021-01-01') - 1, 0)) - 1, 0), DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), -1), DATEADD(yy, DATEDIFF(yy, 0, '12/31/2019'), 0)) HCC
     LEFT JOIN [adw].[2020_tvf_Get_ClaimsByHCC]('2021-01-01', GETDATE(), '12/31/2019') CY
			ON HCC.SUBSCRIBER_ID = CY.SUBSCRIBER_ID
		    AND HCC.ValueCode = CY.ValueCode
     JOIN [adw].[2020_tvf_Get_ActiveMembersFull]
(
(SELECT MAX(LoadDate) FROM adw.FctMembership)
) Mbr ON HCC.SUBSCRIBER_ID = Mbr.ClientMemberKey
     LEFT JOIN lst.LIST_HCC_CODES HccCodes ON Hcc.HCC_CODE = HccCodes.HCC_No
WHERE HCC.PRIMARY_SVC_DATE IS NOT NULL
      AND HCc.CLAIM_TYPE IN('71', '72')
AND CY.SUBSCRIBER_ID IS NULL
AND mbr.Active = '1'
AND HccCodes.ACTIVE = 'Y'
AND mbr.PcpPracticeTIN <> '111111111';

