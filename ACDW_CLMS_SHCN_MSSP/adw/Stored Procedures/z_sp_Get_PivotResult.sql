
CREATE PROCEDURE [adw].[z_sp_Get_PivotResult]
(   
	 @TableName				VARCHAR(100)		
	,@PivotRowF1			VARCHAR(100)		
	,@PivotColF1			VARCHAR(100)	
	,@PivotFunction		VARCHAR(50)			-- SUM, COUNT, AVG
	,@DispColPrefix		VARCHAR(10)	
	,@DispColSuffix		VARCHAR(10)
)
AS
BEGIN

DECLARE @SQLSrc			NVARCHAR(max);
SET @SQLSrc = ' '
SET @SQLSrc = @SQLSrc + 'CREATE TABLE ##tmp_pv_SourceTable  ( '
SET @SQLSrc = @SQLSrc + '[urn]						[int] IDENTITY NOT NULL, '
SET @SQLSrc = @SQLSrc + '[PivotCol]				[varchar](50) NULL ) '
SET @SQLSrc = @SQLSrc + 'INSERT INTO ##tmp_pv_SourceTable (PivotCol) '
SET @SQLSrc = @SQLSrc + 'SELECT DISTINCT ' + @PivotColF1 + ' FROM ' + @TableName + ' ORDER BY ' + @PivotColF1 + ' ASC '
EXEC dbo.sp_executesql @SQLSrc

/*** Loop Thru each row and create pivot table ***/
DECLARE @SQLOuter			NVARCHAR(max);
DECLARE @SQLInner			VARCHAR(max)		= ''
DECLARE @SQLi				VARCHAR(max);
DECLARE @c					INT = 1;
DECLARE @cRTotal			BIGINT = 0;
DECLARE @cRowCnt			BIGINT = 0;

-- get a count of total rows to process 
SELECT @cRowCnt = COUNT(0) FROM ##tmp_pv_SourceTable;
WHILE  @c <= @cRowCnt
BEGIN
DECLARE @ColVal			VARCHAR(10)		= (SELECT PivotCol FROM ##tmp_pv_SourceTable WHERE urn = @c)
-- create SQL statement 
SET NOCOUNT ON;
BEGIN
	SET @SQLi =			' '  
	SET @SQLi = @SQLi + ',' + @PivotFunction + '(CASE WHEN ' + @PivotColF1 + ' = ' + @ColVal + ' THEN 1 ELSE 0 END) AS ' + @DispColPrefix + @ColVal + @DispColSuffix + ' '
END
	SET @SQLInner = @SQLInner + @SQLi
	SET @cRTotal += @c
	SET @c = @c + 1 
END
SET @SQLOuter =				 ' '  
SET @SQLOuter = @SQLOuter + 'SELECT DISTINCT ' + @PivotRowF1 + ' '
SET @SQLOuter = @SQLOuter + @SQLInner
--SET @SQLOuter = @SQLOuter + 'INTO drop table ##tmpHCCPivot '
SET @SQLOuter = @SQLOuter + 'FROM ' + @TableName + ' '
SET @SQLOuter = @SQLOuter + 'GROUP BY ' + @PivotRowF1 + ' '

--PRINT @SQLOuter
EXEC dbo.sp_executesql @SQLOuter
END

-- Clean Up
DROP TABLE ##tmp_pv_SourceTable
DROP PROCEDURE [adw].[z_sp_Get_PivotResult] 
/***
Usage: 
EXEC [adw].[z_sp_Get_PivotResult] 'dbo.z_tmpHCCScoreTbl','SUBSCRIBER_ID','HCC_CODE','SUM','[',']'  
EXEC [adw].[z_sp_Get_PivotResult] '[lst].[List_CPT]','[CPT_CODE],[CPT_DESC]','[CPT_VER]','SUM','[',']' 

DROP PROCEDURE [adw].[z_sp_Get_PivotResult] 
***/
