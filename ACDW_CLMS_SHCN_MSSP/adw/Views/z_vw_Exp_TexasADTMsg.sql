




--- last modify 01/21/2021


CREATE  VIEW [adw].[z_vw_Exp_TexasADTMsg] 
AS 

WITH CTE AS (
	SELECT
       m.ClientMemberKey
      ,m.Ace_ID
		,m.FirstName
      ,m.MiddleName
      ,m.LastName
      ,m.Gender
      ,m.DOB
      ,m.DOD
      ,m.NPI
      ,m.PcpPracticeTIN
      ,p.AccountType		as ProviderNetwork	--m.ProviderNetwork        -- SCHN_AFF, SHCN_SMG
      ,m.MbrMonth
      ,m.MbrYear
	  ,p.AccountType 
	  ,m.PlanName AS PlanName
	  ,m.PlanID AS PlanID
	  ,m.LOB AS LOB
	FROM [adw].[vw_Dashboard_Membership] m
	LEFT JOIN lst.LIST_PCP p
	ON m.NPI	= p.PCP_NPI
	WHERE m.Active = 1
	AND m.MbrYear = (SELECT MAX(MbrYear) FROM [adw].[vw_Dashboard_Membership])
	AND m.MbrMonth = (SELECT MAX(MbrMonth) FROM [adw].[vw_Dashboard_Membership] 
		WHERE MbrYear = (SELECT MAX(MbrYear) FROM [adw].[vw_Dashboard_Membership]))
	AND p.AccountType	IN ('SHCN_SMG','SHCN_AFF')
)

--;WITH PCPNPI(AttendDr, NPI)--Column names for CTE, which are optional
--AS
--(
--SELECT 
--FROM lst.LIST_PCP p INNER JOIN 

--)
    
SELECT   --NTF.AdmitHospital 
			NTF.NtfGhhNotificationKey,
         CODE.ACE_Definition AS FacilityName, -- admit hospital
        '' AS FacilityNPI,  
        '' AS FacilityCity,
         '' AS FacilityState,
         '' AS FacilityType,
          NTF.PatientVisitID  AS VisitID, -- Patient visit ID
          CASE NTF.EventType 
          WHEN 'A01' THEN 'Admit'  
          WHEN 'A03' THEN 'Discharge'
          END AS [Status],
          CASE NTF.EventType 
          WHEN 'A01' THEN CONVERT(DATE, NTF.AdmitDateTime) 
          WHEN 'A03' THEN CONVERT(DATE, NTF.DischargeDateTime)
          END AS StatusDate,
		  CASE NTF.EventType 
          WHEN 'A01' THEN CONVERT(TIME, NTF.AdmitDateTime) 
          WHEN 'A03' THEN CONVERT(TIME, NTF.DischargeDateTime)
          END AS StatusTime,
      --  NTF.MessageDateTime 
	   CONVERT(DATE, SUBSTRING(NTF.MessageDateTime, 1,8)) AS  EventReceiveDate,--MessageDateTime
       CONVERT(TIME, (SUBSTRING(NTF.MessageDateTime, 9,2) + ':' + SUBSTRING(NTF.MessageDateTime, 11,2) +':' + SUBSTRING(NTF.MessageDateTime, 13,2))) AS  EventReceiveTime, -- MessageDateTime
		CONVERT(DATE, NTF.CreatedDate) AS  EventProcessedDate, 
        CONVERT(time, NTF.CreatedDate) AS  EventProcessedTime,
        '' AS  Setting,
		Mbr.AceClientMemberId  AS  PatientID, -- PatientVisistID, AceClientMemberID ?
        Mbr.LastName  AS LastName,
        Mbr.FirstName  AS FirstName,
        Mbr.MiddleName AS MiddleName,
		'' AS Suffix,
        Mbr.DateOfBirth AS DOB,
        Mbr.Gender AS Gender,
        Mbr.HomeAddress1 AS Address1,
        Mbr.HomeAddress2 AS Address2,
         '' AS Address3,
        Mbr.HomeCity AS City,
        Mbr.HomeState AS [State],
        Mbr.HomeZip AS Zip,
        Mbr.MobilePhone AS MobilePhone,
		MBr.HomePhone AS HomePhone,
         '' AS PatientPhoneNumber,
        FMP.ClientMemberKey AS PrimaryInsuranceNumber,
		FMP.LOB AS PrimaryInsurer,
		FMP.PlanName AS PrimaryInsurancePlan,
		 --FMP.PlanID 
		 --FMP.LOB 
         --FMP.PlanName AS PrimaryInsurancePlan,
           '' AS InsuranceBilled,
           '' AS OtherPractices,
           '' AS OtherProviders,
           '' AS OtherPrograms,
           NTF.PatientVisitID AS FacilityVisitId, -- PatientVisistID
           MBR.AceClientMemberId AS AccountNumber,
           NTF.AdmitSource AS AdmittedFrom,   
           NTF.DischargeDisposition AS DischargedDisposition,
           NTF.DischargedLocation AS DischargeLocation,
           '' AS MLOADisposition,
           ''  AS MLOALocation,
           NTF.AdmittingDoctor AS AdmitCareCoordinator,
           '' AS DischargeCareCoordinator,
           '' AS EntryDelay,
           Convert(varchar(5),DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime)/3600)+':'+convert(varchar(5),DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime)%3600/60)+':'+convert(varchar(5),(DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime)%60))  
		    AS VisitDuration,    --  [hh:mm:ss]
           (1+ DATEDIFF(year, NTF.DischargeDateTime, NTF.AdmitDateTime)) AS LOS,
           '' AS CCD,
           '' AS AttendingProviderNPI, -- ACECAREDW - adiGHHNTF
           '' AS AttendingProviderLastName,
           '' AS AttendingProviderFirstName,
		   'Y' AS ActiveRosterPatient,
           NTF.DiagnosisDescription AS PrimaryDiagnosisDescription,
           NTF.DiagnosisCode AS PrimaryDiagnosisCode,
           NTF.DiagnosisType AS DiagnosisCategory,
          '' AS SubsequentDiagnosisCodes,
          '' AS HighUtilizerFlag,
          '' AS ReadmissionRiskFlag,
         '' AS RecentSNFStayFlag,
         '' AS RecentInpatientStayFlag,
         '' AS COVID_19Flags
  FROM [ACECAREDW].[adi].[NtfGhhNotifications] NTF 
  LEFT JOIN [ACECAREDW].[adi].[MbrGhhMember] Mbr 
  ON Mbr.AceClientMemberId = NTF.AceClientMemberID
  INNER JOIN CTE FMP 
  ON NTF.AceID = FMP.Ace_ID
  LEFT JOIN .[lst].[lstGHHCodes] CODE 
  ON NTF.AdmitHospital = CODE.Code 
  WHERE NotificationType = 'ADT' AND EventType in ('A01', 'A03') 
  AND CODE.LOADDATE = ( SELECT MAX(LOADDATE) FROM [lst].[lstGHHCodes] WHERE Code = NTF.AdmitHospital)
 

--CTE FMP RIGHT JOIN adw.NtfNotification NTF 
--ON FMP.Ace_ID = NTF.AceID
--WHERE NTF.ntfEventType IN ('DIS', 'ADM')

 
--SELECT MBR.AceClientMemberId,
--       MBR.FirstName,
--	   MBR.LastName,
--	   MBR.MiddleName,
--       MBR.DateOfBirth ,
--	   MBR.Gender,
--	   MBR.HomeAddress1,
--	   MBR.HomeAddress2,
--	   MBR.HomeCity,
--	   MBR.HomeState,
--	   MBR.HomeZip, 
--	   MBR.MobilePhone,
--	   MBR.HomePhone,
--	  NTF.*
--  FROM [ACECAREDW].[adi].[MbrGhhMember] Mbr left join 
--[ACECAREDW].[adi].[NtfGhhNotifications] NTF on Mbr.AceClientMemberId = NTF.AceClientMemberID
--WHERE NotificationType = 'ADT' and EventType in ('A01', 'A03') 


/***
SELECT *
FROM [adw].[vw_Exp_TexasADTMsg] 
***/

    




