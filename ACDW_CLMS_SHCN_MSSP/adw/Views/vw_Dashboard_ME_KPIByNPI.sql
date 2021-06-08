﻿










CREATE VIEW [adw].[vw_Dashboard_ME_KPIByNPI]
AS 
    -- Purpose: creates a Persiste
    SELECT [FctFctMEKpiNPIKey]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[AdiKey]
      ,[SrcFileName]
      ,[AdwTableName]
      ,[LoadDate]
      ,[DataDate]
      ,[EffectiveAsOfDate]
      ,[KPI_ID]
	  ,[KPI]
	  ,substring([KPI],PATINDEX('%-%',[KPI])+1, len([KPI])) as KPIShort
      ,[KPIEffYear]
      ,[KPIEffMth]
      ,[AttribNPI]
      ,[AttribNPIName]
      ,[AttribTIN]
      ,[AttribTINName]
      ,[KPIValue]
      ,[KPIValue2]
	  ,NPIChapter
FROM [adw].[FctMEKPIByNPI]
LEFT JOIN ( SELECT	*
			FROM	(
						SELECT 
						DISTINCT PCP_NPI, PCP_POD as NPIChapter
						, ROW_NUMBER()OVER(PARTITION BY PCP_NPI ORDER BY EffectiveDate)RwCnt 
						FROM lst.List_PCP
					) c
			WHERE	c.RwCnt = 1
			)c
ON c.PCP_NPI = [AttribNPI] 
WHERE EffectiveAsOfDate = (select max(EffectiveAsOfDate) from  [adw].[FctMEKPIByNPI])
--AND AttribNPI <> 0




