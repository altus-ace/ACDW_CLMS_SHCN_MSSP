
CREATE		FUNCTION  [adw].[z_fn_ClaimsByHCC] (@DataDate DATE)
RETURNS TABLE 

AS

RETURN

		SELECT				 B1. [SEQ_CLAIM_ID]
							,B1. [SUBSCRIBER_ID]
							,fct.[FirstName]
							,fct.[LastName]
							,fct.[DOB]
							,fct.[MemberHomeAddress]
							,fct.[MemberHomeAddress1]
							,fct.[MemberHomeCity]
							,fct.[MemberHomeState]
							,fct.[MemberHomePhone]
							,fct.[NPI]
							,fct.[PcpPracticeTIN]
							,fct.[ProviderLastName] + ' ' + fct.[ProviderFirstName] AS ProviderFullName
							,fct.[ProviderPracticeName]
							,B1. [CATEGORY_OF_SVC]
							,B1. [PRIMARY_SVC_DATE]
							,B1. [SVC_TO_DATE]
							,B1. [CLAIM_THRU_DATE]
							,B1. [VEND_FULL_NAME]
							,B1. [PROV_SPEC]
							,B1. [IRS_TAX_ID]
							,B1. [DRG_CODE]
							,B1. [BILL_TYPE]		
							,B1. [ADMISSION_DATE]
							,B1. [CLAIM_TYPE]
							,B1. [TOTAL_BILLED_AMT]
							,B1. [TOTAL_PAID_AMT]
							,D.  [ValueCode]
							,D.  [HCC] AS HCC_CODE
							,D.  [ICDCode]
							,D.  [Description]
							,D.	 [HCC_Description]
							
							,CASE	WHEN DATEDIFF(dd, PRIMARY_SVC_DATE, SVC_TO_DATE) = 0 
									THEN 1 
									ELSE DATEDIFF(dd, PRIMARY_SVC_DATE, SVC_TO_DATE) 
									END AS LOS
							,DATEDIFF(dd,B1.PRIMARY_SVC_DATE, GETDATE()) AS DaysSincePrimarySvcDate
		  FROM				[adw].[Claims_Headers] B1
		  INNER JOIN
							(
								SELECT DISTINCT C3.SEQ_CLAIM_ID, L33.ICDCode AS ValueCode, L33.HCC,[ICDCode],[Description],[HCC_Description]
								FROM adw.Claims_Diags C3 
								INNER JOIN
									(
											SELECT DISTINCT [ICDCode],[HCC],Description,HCC_Description, HCC_NO
											FROM			[lst].[LIST_ICDcwHCC] L3
											LEFT JOIN		lst.LIST_HCC_CODES b
											ON				l3.HCC = b.HCC_No
											WHERE			LEN(L3.HCC) > 0
											AND				l3.EffectiveDate = (SELECT MAX(EffectiveDate) FROM [lst].[LIST_ICDcwHCC])
									) L33
		  ON				L33.[ICDCode] = C3.diagCodeWithoutDot
							) AS D 
		  ON				D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID
		  JOIN				adw.FctMembership fct
		  ON				B1.SUBSCRIBER_ID = fct.ClientMemberKey
		  WHERE				B1.SEQ_CLAIM_ID IS NOT NULL
		  AND				CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)	>= '2019-01-01' --Cutoff Date
		  AND				fct.Active = 1
		  AND				B1.CLAIM_TYPE IN('71','72')




		 