




CREATE  VIEW    [adw].[z_vw_MissingHCCCodes]
AS

		
		SELECT		ou.SUBSCRIBER_ID				AS ClientMemberKey
					, ou.FirstName
					, ou.LastName
					, ou.DOB
					, ou.NPI
					, ou.PcpPracticeTIN
					, ou.ProviderFullName
					, ou.ProviderPracticeName
					, ou.HCC_CODE					AS HccCode
					, ou.Hcc_Description			AS HccDescription
					, ou.ICDCode					AS IcdCd
					, ou.Description				AS ValCodeDescription
					, ou.AdmissionDate				AS AdmissionDT
					, inn.SUBSCRIBER_ID
					, inn.ValueCode
					, inn.HCC_CODE
					, inn.ICDCode
					, inn.AdmissionDate


		FROM		(
							SELECT		DISTINCT SUBSCRIBER_ID,ValueCode,HCC_CODE,ICDCode
										, YEAR(ADMISSION_DATE) AdmissionDate
										, FirstName
										, LastName
										, DOB
										, NPI
										, PcpPracticeTIN
										, ProviderFullName
										, ProviderPracticeName
										, Description
										, Hcc_Description
							FROM		[adw].[fn_ClaimsByHCC](GETDATE())
							WHERE		YEAR(ADMISSION_DATE) = 2019
					) ou
		LEFT JOIN	(		SELECT		DISTINCT SUBSCRIBER_ID,ValueCode,HCC_CODE,ICDCode
										, YEAR(ADMISSION_DATE) AdmissionDate
										, FirstName
										, LastName
										, NPI
										, ProviderFullName
										, ProviderPracticeName
							FROM		[adw].[fn_ClaimsByHCC](GETDATE())
							WHERE		YEAR(ADMISSION_DATE) = 2020
					) inn
		ON					ou.SUBSCRIBER_ID=inn.SUBSCRIBER_ID
		AND					ou.HCC_CODE = inn.HCC_CODE
		AND					ou.ICDCode = inn.ICDCode
		AND					ou.ValueCode = inn.ValueCode
		AND					inn. SUBSCRIBER_ID IS NULL
					
				
