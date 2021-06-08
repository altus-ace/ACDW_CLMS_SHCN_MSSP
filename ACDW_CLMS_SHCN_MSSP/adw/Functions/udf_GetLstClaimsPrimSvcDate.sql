

/*************************************************
CREATED BY : 
PURPOSE : 
**************************************************/
CREATE FUNCTION [adw].[udf_GetLstClaimsPrimSvcDate]
	(
	@EffectiveAsOfDate DATE
	)
RETURNS varchar(100) AS
BEGIN
  DECLARE @Result DATE
  BEGIN
    SET @Result = 
		(
		SELECT DISTINCT
			Max(Primary_Svc_Date) 
		FROM [adw].[Claims_Headers]
		)
  END
  RETURN @Result
END
/***
SELECT adw.[udf_GetLstClaimsPrimSvcDate] (Getdate())
***/

