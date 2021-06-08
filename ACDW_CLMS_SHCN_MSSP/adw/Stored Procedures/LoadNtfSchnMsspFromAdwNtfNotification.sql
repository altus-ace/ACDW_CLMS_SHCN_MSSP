
/****** Object:  Table [adw].[NtfNotification]    Script Date: 6/16/2020 12:50:14 PM ******/
CREATE PROCEDURE [adw].[LoadNtfSchnMsspFromAdwNtfNotification]
AS

BEGIN
SET IDENTITY_INSERT [adw].[NtfNotification] ON

INSERT INTO			[adw].[NtfNotification](
					[CreatedDate]
					, [CreatedBy]
					, [LastUpdatedDate]
					, [LastUpdatedBy]
					, [LoadDate]
					, [DataDate]
					, [ntfNotificationKey]
					, [ClientKey]
					, [NtfSource]
					, [ClientMemberKey]
					, [ntfEventType]
					, [NtfPatientType]
					, [CaseType]
					, [AdmitDateTime]
					, [ActualDischargeDate]
					, [DischargeDisposition]
					, [ChiefComplaint]
					, [DiagnosisDesc]
					, [DiagnosisCode]
					, [AdmitHospital]
					, [AceFollowUpDueDate]
					, [Exported]
					, [ExportedDate]
					, [AdiKey]
					, [SrcFileName]
					, [AceID]
					, [DschrgInferredInd]
					, [DschrgInferredDate])

SELECT				[CreatedDate]
					, [CreatedBy]
					, [LastUpdatedDate]
					, [LastUpdatedBy]
					, [LoadDate]
					, [DataDate]
					, [ntfNotificationKey]
					, [ClientKey]
					, [NtfSource]
					, [ClientMemberKey]
					, [ntfEventType]
					, [NtfPatientType]
					, [CaseType]
					, [AdmitDateTime]
					, [ActualDischargeDate]
					, [DischargeDisposition]
					, [ChiefComplaint]
					, [DiagnosisDesc]
					, [DiagnosisCode]
					, [AdmitHospital]
					, [AceFollowUpDueDate]
					, [Exported]
					, [ExportedDate]
					, [AdiKey]
					, [SrcFileName]
					, [AceID]
					, [DschrgInferredInd]
					, [DschrgInferredDate] 
FROM				[ACECAREDW].[adw].[NtfNotification]
WHERE				ClientKey = 16
AND					CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())

SET IDENTITY_INSERT [adw].[NtfNotification] OFF

END


BEGIN
--Update Shcn from Acecaredw

UPDATE				adw.NtfNotification
SET					DschrgInferredInd = 1        ----   select a.adikey,b.adikey,a.ClientMemberKey,b.ClientMemberKey,a.AdmitDateTime,b.AdmitDateTime,a.DschrgInferredInd,a.loaddate,b.loaddate,a.createddate,b.createddate,a.DiagnosisCode,b.DiagnosisCode
FROM				adw.NtfNotification b
JOIN				ACECAREDW.adw.NtfNotification a
ON					a.ClientMemberKey = b.ClientMemberKey
AND					a.AdmitDateTime = b.AdmitDateTime 
AND					a.AdiKey = b.AdiKey
WHERE				a.DschrgInferredInd = 1
AND					a.DschrgInferredDate <> '1900-01-01' 
AND					a.NtfPatientType = 'IP'
AND					a.ntfEventType = 'ADM' 

UPDATE				adw.NtfNotification
SET					DschrgInferredDate = a.DschrgInferredDate       ----   select *
FROM				adw.NtfNotification b
JOIN				ACECAREDW.adw.NtfNotification a
ON					a.ClientMemberKey = b.ClientMemberKey
AND					a.AdmitDateTime = b.AdmitDateTime
AND					a.AdiKey = b.AdiKey
WHERE				a.DschrgInferredInd = 1
AND					a.DschrgInferredDate <> '1900-01-01'
AND					a.NtfPatientType = 'IP'
AND					a.ntfEventType = 'ADM' 

END
