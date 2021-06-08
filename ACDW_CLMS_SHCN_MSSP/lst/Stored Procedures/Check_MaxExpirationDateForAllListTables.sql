
CREATE PROCEDURE [lst].[Check_MaxExpirationDateForAllListTables]
AS
-- Create Table to Store the TblName & ColName
DECLARE @tmpListTable TABLE (
		[urn]					[int] IDENTITY NOT NULL,  
		[TABLE_CATALOG]	[varchar](50) NULL,
		[TABLE_SCHEMA]		[varchar](50) NULL,
		[TABLE_NAME]		[varchar](50) NULL,
		[COLUMN_NAME]		[varchar](50) NULL,
		[CreateDate]		DATE	NULL )

INSERT INTO @tmpListTable (
		[TABLE_CATALOG]	,
		[TABLE_SCHEMA]		,
		[TABLE_NAME]		,
		[COLUMN_NAME]		)

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
--INTO #tmpListTable
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'lst'
	AND COLUMN_NAME IN ('ExpirationDate')
	AND LEFT(TABLE_NAME,1) <> 'z'

-----
DECLARE @SQLCreateTbl	NVARCHAR(1000)
	SET @SQLCreateTbl =						'DROP TABLE lst.z_ListTables '
	SET @SQLCreateTbl = @SQLCreateTbl + 'CREATE TABLE lst.z_ListTables ('
	SET @SQLCreateTbl = @SQLCreateTbl + '[urn]					[int] IDENTITY NOT NULL, '
	SET @SQLCreateTbl = @SQLCreateTbl + '[TABLE_NAME]			[varchar](75) NULL, '
	SET @SQLCreateTbl = @SQLCreateTbl + '[COLUMN_NAME]			[varchar](50) NULL, '
	SET @SQLCreateTbl = @SQLCreateTbl + '[MaxExpDate]			DATE	NULL, '
	SET @SQLCreateTbl = @SQLCreateTbl + '[CreatedDate]			DATE	NULL DEFAULT GetDate(), '
	SET @SQLCreateTbl = @SQLCreateTbl + '[CreatedBy]			[varchar](50)	NULL DEFAULT suser_sname())'
EXEC dbo.sp_executesql @SQLCreateTbl
-----
DECLARE @SQL				NVARCHAR(1000)

DECLARE @i INT = 1;
DECLARE @RunningTotal BIGINT = 0;
DECLARE @RowCnt BIGINT = 0;

-- get a count of total rows to process 
SELECT @RowCnt = COUNT(0) FROM @tmpListTable;
WHILE @i <= @RowCnt
BEGIN
--DECLARE @SQLStatement	VARCHAR(max)	= (SELECT SQLStatement	FROM @tmpListTable WHERE urn = @i)
DECLARE @SQLTblName		VARCHAR(50)		= (SELECT CONCAT('lst.', TABLE_NAME)	FROM @tmpListTable WHERE urn = @i)
DECLARE @SQLColName		VARCHAR(50)		= (SELECT COLUMN_NAME	FROM @tmpListTable WHERE urn = @i)

SET NOCOUNT ON;
BEGIN

	SET @SQL =			'INSERT INTO lst.z_ListTables ([TABLE_NAME], [COLUMN_NAME], [MaxExpDate]) '
	SET @SQL = @SQL + 'SELECT TblName, ColName, '
	SET @SQL = @SQL + 'MaxExpDate '
	SET @SQL = @SQL + 'FROM ('
	SET @SQL = @SQL + 'SELECT ' + char(39) + @SQLTblName + char(39) + ' as TblName, '
	SET @SQL = @SQL + ' ' + char(39) + @SQLColName + char(39) + ' as ColName, '
	SET @SQL = @SQL + 'MAX(CONVERT(DATE,' + @SQLColName + ')) AS MaxExpDate '
	SET @SQL = @SQL + 'FROM ' + @SQLTblName  + ') a '
END

--PRINT @SQL
EXEC dbo.sp_executesql @SQL
	SET @RunningTotal += @i
	SET @i = @i + 1 
	
END

/***
EXEC [lst].[Check_MaxExpirationDateForAllListTables]
SELECT * FROM lst.z_ListTables ORDER BY TABLE_NAME 
***/


