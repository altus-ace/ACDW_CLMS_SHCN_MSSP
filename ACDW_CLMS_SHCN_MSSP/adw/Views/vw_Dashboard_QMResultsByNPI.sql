CREATE VIEW adw.vw_Dashboard_QMResultsByNPI
AS

SELECT ClientMemberKey
	,AttribNPI
	,ProviderChapter
	,Sum(Den) as Den
	,Sum(Num) as Num
	,Sum(Gap) as Gaps
FROM [adw].[2020_tvf_Get_QMResultsByNPIChapterMember] ('2020-05-15','2020-05-15')
GROUP BY ClientMemberKey
	,AttribNPI
	,ProviderChapter
