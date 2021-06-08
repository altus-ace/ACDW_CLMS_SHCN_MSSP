

CREATE PROCEDURE adw.pupdateForDataDates

AS
/*Updating DataDate for FctMembership.*/
		
		UPDATE	adw.FctMembership
		SET		DataDate = '2021-03-13' --- SELECT DISTINCT MBRYEAR, MBRMONTH, DATADATE FROM adw.FctMembership
		WHERE	MbrYear = YEAR(GETDATE())
		AND		DataDate <> '2021-03-13'