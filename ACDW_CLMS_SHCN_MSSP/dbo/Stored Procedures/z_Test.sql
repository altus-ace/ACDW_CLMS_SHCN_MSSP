/***
-- =============================================
-- Author:		
-- Create date: 
-- Description:	Compares 2 RecordSet
-- =============================================
***/
CREATE PROCEDURE			[dbo].[z_Test] 
 @EffDate1 Date, 
 @EffDate2 Date
AS
BEGIN

DECLARE @InputTbl		as VARCHAR(50)		= '[adw].[FctMEKPISummary]'
DECLARE @InputCol		as VARCHAR(50)		= '[EffectiveAsOfDate]'
DECLARE @SelectCols	as VARCHAR(200)	= 'KPIEffYear, KPIEffMth, KPI_ID, KPI '
DECLARE @RS1			as VARCHAR(10)		= CONCAT('[',DATEPART(MM, @EffDate1),DATEPART(DD, @EffDate1),DATEPART(yyyy, @EffDate1),']')
DECLARE @RS2			as VARCHAR(10)		= CONCAT('[',DATEPART(MM, @EffDate2),DATEPART(DD, @EffDate2),DATEPART(yyyy, @EffDate2),']')
DECLARE @SQLInput		as VARCHAR(MAX)	

SET @SQLInput =				 'SELECT * INTO #tmpInput FROM ('
SET @SQLInput = @SQLInput + 'SELECT ' + char(39) + 'RS1' + char(39) + ' as RecSet, * FROM ' + @InputTbl + ' WHERE ' + @InputCol + ' = ''' + Convert(Varchar(10),@EffDate1,101) + ''' '
SET @SQLInput = @SQLInput + 'UNION '
SET @SQLInput = @SQLInput + 'SELECT ' + char(39) + 'RS2' + char(39) + ' as RecSet, * FROM ' + @InputTbl + ' WHERE ' + @InputCol + ' = ''' + Convert(Varchar(10),@EffDate2,101) + ''' '
SET @SQLInput = @SQLInput + ') input ;'

--SET @SQLInput = @SQLInput + 'SELECT * FROM #tmpInput ;'

SET @SQLInput = @SQLInput + 'SELECT ' + @SelectCols + ', RS1 AS ' + @RS1 + ', RS2 AS ' + @RS2 + ', (RS2 - RS1) as Variance FROM '
SET @SQLInput = @SQLInput + '(SELECT ' + @SelectCols + ', RecSet, [Value]  FROM #tmpInput) ps	 '
SET @SQLInput = @SQLInput + 'PIVOT( SUM([Value]) FOR RecSet IN (RS1, RS2)) AS pvt								 '
SET @SQLInput = @SQLInput + 'ORDER BY ' + @SelectCols + ' '

--PRINT @SQLInput
EXEC(@SQLInput)
END

/***
EXEC [dbo].[z_Test] '09-15-2020','10-15-2020'
***/



