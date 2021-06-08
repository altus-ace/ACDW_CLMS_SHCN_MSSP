
/*************************************************
CREATED BY : 
PURPOSE : 
**************************************************/
CREATE FUNCTION [adw].[udf_GetNPIName]
(@NPI varchar(20))
RETURNS varchar(100) AS
BEGIN
  DECLARE @Result varchar(100)
  --WHILE 1=1
  BEGIN
    --IF PATINDEX('% %',@NPI) = 0 BREAK
    SET @Result = 
		(
		SELECT DISTINCT 
			CASE LEN([LBN]) WHEN 0											   
			THEN [LBN_Name]		   
			ELSE LEFT(RTRIM([LBN]),100)										   
			END AS LegalBusinessName
		FROM [AceMasterData].[adi].[LIST_NPPES_NPI] WHERE [NPI]=@NPI
		AND DataDate = (SELECT MAX(DataDate) FROM [AceMasterData].[adi].[LIST_NPPES_NPI])
		)
  END
  --SET @Result = Left(@Result,Len(@Result))
  RETURN @Result
END
/***
do not use....
SELECT [adw].[udf_GetNPIName]('1003819020')
***/
