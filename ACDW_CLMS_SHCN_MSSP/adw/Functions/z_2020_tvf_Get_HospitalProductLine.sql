






CREATE FUNCTION [adw].[z_2020_tvf_Get_HospitalProductLine]
(
 @VisitType VARCHAR(20) 
 --@PrimSvcDate_End   VARCHAR(20)
)
RETURNS TABLE
AS RETURN
(
	SELECT DISTINCT VisitType, ProductLine, ServiceLine, SubServiceLine
	,STUFF((SELECT ',' + CONVERT(varchar(10),s.MDCCode)
            FROM 
				(SELECT DISTINCT VisitType, ProductLine, ServiceLine, SubServiceLine, MDCCode
				FROM [adi].[z_List_HospitalProductLines]
				WHERE LEN(MDCCode) > 1 AND MDCCode <> '0') s
			WHERE s.VisitType = m.VisitType
			AND s.ProductLine = m.ProductLine
			AND s.ServiceLine = m.ServiceLine
			AND s.SubServiceLine = m.SubServiceLine
            FOR XML PATH('')
            ), 1, 1, '') AS MDCCode
	,STUFF((SELECT ',' + CONVERT(varchar(10),s.DrgCode)
            FROM 
				(SELECT DISTINCT VisitType, ProductLine, ServiceLine, SubServiceLine, DrgCode
				FROM [adi].[z_List_HospitalProductLines]
				WHERE LEN(DrgCode) > 1 AND DrgCode <> '0') s
			WHERE s.VisitType = m.VisitType
			AND s.ProductLine = m.ProductLine
			AND s.ServiceLine = m.ServiceLine
			AND s.SubServiceLine = m.SubServiceLine
            FOR XML PATH('')
            ), 1, 1, '') AS DrgCode
	,STUFF((SELECT ',' + CONVERT(varchar(10),s.ProcCode)
            FROM 
				(SELECT DISTINCT VisitType, ProductLine, ServiceLine, SubServiceLine, ProcCode
				FROM [adi].[z_List_HospitalProductLines]
				WHERE LEN(ProcCode) > 1 AND ProcCode <> '0') s
			WHERE s.VisitType = m.VisitType
			AND s.ProductLine = m.ProductLine
			AND s.ServiceLine = m.ServiceLine
			AND s.SubServiceLine = m.SubServiceLine
            FOR XML PATH('')
            ), 1, 1, '') AS ProcCode
	,STUFF((SELECT ',' + CONVERT(varchar(10),s.DiagCode)
            FROM 
				(SELECT DISTINCT VisitType, ProductLine, ServiceLine, SubServiceLine, DiagCode
				FROM [adi].[z_List_HospitalProductLines]
				WHERE LEN(DiagCode) > 1 AND DiagCode <> '0') s
			WHERE s.VisitType = m.VisitType
			AND s.ProductLine = m.ProductLine
			AND s.ServiceLine = m.ServiceLine
			AND s.SubServiceLine = m.SubServiceLine
            FOR XML PATH('')
            ), 1, 1, '') AS DiagCode
	,m.[ER_Flag]		 
	,m.[Obv_Flag]		 
	,m.[Surg_Flag]
FROM [adi].[z_List_HospitalProductLines] m
)

/***
Usage: 
SELECT *
FROM adw.[z_2020_tvf_Get_HospitalProductLine] ('IP')

***/


