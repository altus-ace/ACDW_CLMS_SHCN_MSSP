/***
V1		2021-06-01	Create Procedure
***/
CREATE PROCEDURE dbo.z_sp_CreateCampaign
(@CodeEffDate  VARCHAR(10),
 @ValueSetName	VARCHAR(100),
 @ValueSetSys	VARCHAR(50),
 @MbrEffDate	VARCHAR(10),	
 @SvcDateStart	VARCHAR(10),	
 @SvcDateEnd	VARCHAR(10)	
)
AS


DECLARE @SQL					NVARCHAR(max)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0

--WHILE @i <= @RowCnt
BEGIN
SET @SQL = '
	IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpCodeSet' + char(39) + ') IS NOT NULL
	DROP TABLE #tmpCodeSet
	SELECT * INTO #tmpCodeSet FROM (
	SELECT DISTINCT VALUE_SET_NAME	as ValueSetName
		,VALUE_CODE_WithoutDot			as ValueCode
		,VALUE_CODE_SYSTEM				as ValueCodeSystem
	FROM lst.LIST_HEDIS_CODE
	WHERE	CONVERT(DATE,' + char(39) + @CodeEffDate + char(39) + ') BETWEEN EffectiveDate AND ExpirationDate AND ACTIVE = ' + char(39) + 'Y' + char(39) + ' 
	AND VALUE_SET_NAME LIKE ' + char(39) + '%' + @ValueSetName + '%' + char(39) + ' 
	AND VALUE_CODE_SYSTEM LIKE ' + char(39) + '%' + @ValueSetSys + '%' + char(39) + ' 
	) m 
	IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpPopulation' + char(39) + ') IS NOT NULL
	DROP TABLE #tmpPopulation
	SELECT ClientKey, ClientMemberKey
	INTO #tmpPopulation
	FROM adw.[2020_tvf_Get_ActiveMembersFull] (' + char(39) + @MbrEffDate + char(39) + ') p
	IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpDxCodes' + char(39) + ') IS NOT NULL
	DROP TABLE #tmpDxCodes
	SELECT top 100 h.SUBSCRIBER_ID as ClientMemberKey, h.SEQ_CLAIM_ID as ClaimID, h.PRIMARY_SVC_DATE as SvcDateStart, h.SVC_TO_DATE as SvcDateEnd
		,h.CATEGORY_OF_SVC as SvcCat, d.diagNumber as DxSeqNo, d.diagCodeWithoutDot as DxCode
	INTO #tmpDxCodes
	FROM adw.Claims_Headers h
	JOIN adw.Claims_Diags d
		ON h.SEQ_CLAIM_ID = d.SEQ_CLAIM_ID
	WHERE h.SVC_TO_DATE BETWEEN ' + char(39) + @SvcDateStart + char(39) + ' AND ' + char(39) + @SvcDateEnd + char(39) + '
	SELECT * FROM #tmpCodeSet
	SELECT * FROM #tmpPopulation
	SELECT * FROM #tmpDxCodes
	'

--PRINT @SQL
EXEC dbo.sp_executesql @SQL
--SET @rTotal	+= @i
--SET @i= @i + 1
END
/*** 
EXEC dbo.z_sp_CreateCampaign '2021-05-01','Breast','ICD10CM','2021-05-01','2020-01-01','2020-05-01'
***/
