

CREATE PROCEDURE adw.ME_Exp_KPISummary
 ( 
	 @EffectiveAsOfDate		AS DATE
	,@KPIEffYear			AS INT	
	,@KPIEffMth				AS INT	
 )
AS
BEGIN
	SET NOCOUNT ON;

	SELECT KPIEffYear as EffYear, KPIEffMth as EffMth, KPI_ID as KpiID, KPI as KpiDesc
		,SUM(Numerator)		as Num
		,SUM(Denominator)	as Den
		,SUM(Value)			as Metric
	FROM [adw].[FctMEKPISummary]
	WHERE EffectiveAsOfDate = @EffectiveAsOfDate
		AND KPIEffYear = @KPIEffYear AND KPIEffMth = @KPIEffMth
		AND KPI_ID NOT IN (6510,9510)
	GROUP BY KPIEffYear, KPIEffMth, KPI, KPI_ID
	ORDER BY KPIEffYear, KPIEffMth, KPI, KPI_ID

END

/***
EXEC adw.ME_Exp_KPISummary '08-15-2020',2020,5
***/
