﻿


CREATE VIEW [adw].[vw_SSRS_MissingHcc_CY]
AS
    /* Objective:  For SSRS report generation ONLY: select from tvf Missing hcc codes for current year all members adds details form fct for report 
	   10/30/2020: GK/JK 
	   11/02/2020: GK: Added Active Flag to where, changed Get_ActiveMembers to use max loaddate from fact
	   05/21/2021: GK: JK asked to make Get_MissginDxHcc use the rule: Get data from start of 2 years from current year throught end of previous year. Implemented below.
		  [adw].[2020_tvf_Get_MissingDxHCC](DATEFROMPARTS(Year(DATEADD(year, -2, getdate())), 1,1), DATEFROMPARTS(Year(DATEADD(year, -1, getdate())), 12,31), '12/31/2019') HCC
    */
    SELECT HCC.SUBSCRIBER_ID AS ClientMemberKey, hcc.PRIMARY_SVC_DATE, HCC.HCC_CODE, hcc.ValueCode,  HccCodes.HCC_Description
    		,Mbr.NPI AS AttribNPI, mbr.ProviderLastName, mbr.ProviderFirstName
			,Mbr.PcpPracticeTIN AS AttribTIN, mbr.ProviderPracticeName, Mbr.ProviderChapter 
			,Mbr.LastName, mbr.FirstName, mbr.MemberHomeAddress + mbr.MemberHomeAddress1 AS MemberHomeAddress, mbr.MemberHomeCity,mbr.MemberHomeState, mbr.MemberHomeZip, mbr.MemberHomePhone, mbr.Dob
			,Mbr.ClientRiskScore, Mbr.AceRiskScore

    FROM [adw].[2020_tvf_Get_MissingDxHCC](DATEFROMPARTS(Year(DATEADD(year, -2, getdate())), 1,1), DATEFROMPARTS(Year(DATEADD(year, -1, getdate())), 12,31), '12/31/2019') HCC
			JOIN [adw].[2020_tvf_Get_ActiveMembersFull]((SELECT Max(LoadDate) FROM adw.FctMembership)) Mbr ON HCC.SUBSCRIBER_ID = Mbr.ClientMemberKey		
			LEFT JOIN lst.LIST_HCC_CODES HccCodes ON Hcc.HCC_CODE = HccCodes.HCC_No 				
    WHERE Mbr.ClientMemberKey IS NOT NULL
	 AND mbr.Active = '1'
	 AND mbr.PcpPracticeTIN <> '111111111'
    


