

CREATE VIEW [adw].[vw_Dashboard_QMResultsByNPIAndMeasure]
AS

SELECT 
	QmDate
	,AttribNPI
	,ProviderChapter
	,QmMsrID as QM
	,qm.[AHR_QM_DESC] as QMDescription
	,Sum(Den) as Den
	,Sum(Num) as Num
	,Sum(Gap) as Gaps
	,CAST ((CAST(Sum(Num) as float)/Sum(Den) * 100) AS DECIMAL(5,2)) as Pct
FROM [adw].[2020_tvf_Get_QMResultsByNPIChapterMember] (
	(SELECT MAX(QMDate) FROM adw.QM_ResultByMember_History),
	(SELECT max([RwEffectiveDate]) FROM [adw].[FctMembership])
	) a
LEFT JOIN lst.List_QM_Mapping qm
ON a.QmMsrID = qm.QM
GROUP BY QmDate
	,AttribNPI
	,ProviderChapter
	,QmMsrID
	,qm.[AHR_QM_DESC]

