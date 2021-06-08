




CREATE VIEW [adw].[z_vw_Dashboard_Notifications]
AS





SELECT				TOP 50 a.[CreatedDate]
					,'test' as Test
					, a.[CreatedBy]
					, a.[LastUpdatedDate]
					, a.[LastUpdatedBy]
					, [LoadDate]
					, [DataDate]
					, [ntfNotificationKey]
					, a.[ClientKey]
					,b.[ClientShortName]
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
FROM				adw.NtfNotification a
JOIN				lst.List_Client b
ON					a.ClientKey = b.ClientKey
WHERE				CONVERT(DATE,a.CreatedDate) BETWEEN DATEADD(MONTH,-1,CONVERT(DATE,GETDATE())) AND CONVERT(DATE,GETDATE())












