

CREATE  VIEW [adw].[z_vw_Exp_Texas_ADT] 
AS 
    /* get from SHCN */
    SELECT   
   
     
      [LoadDate]
      ,[DataDate]
      ,[ClientKey]
      ,[NtfSource]
      ,[ClientMemberKey]
      ,[ntfEventType]
      ,[NtfPatientType]
      ,[CaseType]
      ,[AdmitDateTime]
      ,[ActualDischargeDate]
      ,[DischargeDisposition]
      ,[ChiefComplaint]
      ,[DiagnosisDesc]
      ,[DiagnosisCode]
      ,[AdmitHospital]
      ,[AceFollowUpDueDate]
      ,[Exported]
      ,[ExportedDate]
      ,[AdiKey]
      ,[AceID]
      ,[DschrgInferredInd]
      ,[DschrgInferredDate] 
	FROM [ACDW_CLMS_SHCN_MSSP].[adw].[NtfNotification]
    WHERE ntfEventType  in ('DIS', 'ADM')