﻿CREATE VIEW [adi].[vw_MapProviderID] AS
    SELECT 'Edit me' EDIT_ME
	   , 'TIN' AS [PCP_TIN_NAME]
	   , 'PCPNAME' AS [PCP_NAME]
        , '12345' AS NPI
                     
    /*
	SELECT DISTINCT a.[ProviderID]					AS ProviderID
		,a.[NPI]									AS NPI
		,b.PCP_LAST_NAME + ', ' + b.PCP_FIRST_NAME	AS PCP_NAME
		,b.PCP_PRACTICE_TIN							AS PCP_TIN
		,b.PCP_PRACTICE_TIN_NAME					AS PCP_TIN_NAME
		FROM [adi].[stg_ClientCareopps] a INNER JOIN 
		(SELECT num, PCP_CLIENT_ID, PCP_NPI, PCP_PRACTICE_TIN, PCP_PRACTICE_TIN_NAME,PCP_LAST_NAME, PCP_FIRST_NAME FROM 
			(SELECT PCP_CLIENT_ID, PCP_NPI, PCP_PRACTICE_TIN, PCP_PRACTICE_TIN_NAME,PCP_LAST_NAME, PCP_FIRST_NAME, ROW_NUMBER() OVER(PARTITION BY PCP_CLIENT_ID ORDER BY PCP_URN DESC) AS num
			FROM lst.LIST_PCP ) AS numbered
			WHERE num = 1
			) b
		--lst.LIST_PCP b
		ON a.NPI = b.PCP_NPI AND a.ProviderID = b.PCP_CLIENT_ID
		*/
