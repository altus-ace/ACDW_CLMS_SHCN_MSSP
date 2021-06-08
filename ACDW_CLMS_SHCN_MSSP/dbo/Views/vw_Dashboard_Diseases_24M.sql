
CREATE VIEW [dbo].[vw_Dashboard_Diseases_24M]
-- In this view, we have data for last 24 months
AS
SELECT DISTINCT 
	   H.SEQ_CLAIM_ID,
       A.SUBSCRIBER_ID AS SubscriberID, 
	   C.PcpPracticeTIN,
	   C.ProviderPracticeName,
       C.FirstName, 
       C.LastName, 
       C.DOB, 
	   C.Gender,
       C.CurrentAge, 
       C.MemberHomeAddress, 
       C.MemberHomeAddress1, 
       C.MemberHomeCity, 
       C.MemberHomeState, 
       C.MemberHomeZip, 
       C.MemberPhone, 
       C.MemberCellPhone, 
       C.MemberHomephone,
	   C.PlanName AS Plans,
	   A.diagCodeWithoutDot As DiagCode,
       B.[ICD-10-CM_CODE_DESCRIPTION] AS CodeDescription, 
	   B.CCS_CATEGORY_DESCRIPTION,
	   B.MULTI_CCS_LVL1_LABEL,
	   B.MULTI_CCS_LVL2_LABEL,
       H.PRIMARY_SVC_DATE, 
	   C.ClientRiskScore,
	   C.ClientRiskScoreLevel,
	   C.LOB,
	   C.PlanID,
	   C.PlanName
FROM adw.Claims_Headers h
     JOIN adw.Claims_Diags a 
		ON h.SEQ_CLAIM_ID = a.SEQ_CLAIM_ID
     JOIN lst.LIST_ICDCCS b 
		ON a.diagCodeWithoutDot = b.[ICD-10-CM_CODE]
     JOIN [adw].[FctMembership] c 
		ON h.SUBSCRIBER_ID = c.ClientMemberKey
       AND YEAR(h.PRIMARY_SVC_DATE) = c.mbryear
       AND MONTH(h.PRIMARY_SVC_DATE) = c.MbrMonth
WHERE  
h.PRIMARY_SVC_DATE >= DateAdd(MONTH, -26, getdate())

 