-- =============================================
-- Author:		Si Nguyen
-- Create date: 04/26/2020
-- Description:	Get Data from NPPES table
-- =============================================
CREATE PROCEDURE [adw].[z_usp_GetFromNPPES] 
	@EffDate		DATE,
	@State1			VARCHAR(2),
	@State2			VARCHAR(2),
	@State3			VARCHAR(2),
	@Type			VARCHAR(5),
	@Value			INT
AS
DECLARE @SQL				NVARCHAR(2000);
--DECLARE @SEffDate			DATE = @EffDate;
DECLARE @SState1			VARCHAR(2) =  @State1;
DECLARE @SState2			VARCHAR(2) =  @State2;
DECLARE @SState3			VARCHAR(2) =  @State3;
DECLARE @SType				VARCHAR(5) =  @Type  ;
DECLARE @SValue				INT = @Value ;

BEGIN
SET NOCOUNT ON;
--IF (@SType = 'NPI')
	BEGIN 
		SET @SQL = 'SELECT '
		SET @SQL = @SQL +  '["NPI"]			AS NPI                                                                                                 '
		SET @SQL = @SQL +  '	,["Entity Type Code"] AS EntityTypeCD																			   '
		SET @SQL = @SQL +  '	,["Employer Identification Number (EIN)"] AS EIN																   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider Organization Name (Legal Business Name)"]),100) AS ProvBusinessName						   '
		SET @SQL = @SQL +  '	,CASE LEN(["Provider Organization Name (Legal Business Name)"]) WHEN 0											   '
		SET @SQL = @SQL +  '	THEN CONCAT(LEFT(RTRIM(["Provider Last Name (Legal Name)"]),100),LEFT(RTRIM(["Provider First Name"]),100))		   '
		SET @SQL = @SQL +  '	ELSE LEFT(RTRIM(["Provider Organization Name (Legal Business Name)"]),100)										   '
		SET @SQL = @SQL +  '	END AS LegalBusinessName																						   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider Last Name (Legal Name)"]),100) AS ProvLastName											   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider First Name"]),100) AS ProvFirstName														   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider First Line Business Practice Location Address"]),100) AS ProvPracticeAddress1			   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider Second Line Business Practice Location Address"]),100) AS ProvPracticeAddress2			   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Provider Business Practice Location Address City Name"]),100) AS ProvPracticeCity					   '
		SET @SQL = @SQL +  '	,["Provider Business Practice Location Address State Name"] AS ProvPracticeState								   '
		SET @SQL = @SQL +  '	,LEFT(["Provider Business Practice Location Address Postal Code"],5) AS ProvPracticeZip							   '
		SET @SQL = @SQL +  '	,["Provider Business Practice Location Address Telephone Number"] AS ProvPracticePhone1							   '
		SET @SQL = @SQL +  '	,["Provider Business Practice Location Address Fax Number"] AS ProvPracticeFax1									   '
		SET @SQL = @SQL +  '	,["Last Update Date"] AS RecLastUpdateDate																		   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_1"]),50) AS Taxonomy1											   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_2"]),50) AS Taxonomy2											   '
		SET @SQL = @SQL +  '	,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_3"]),50) AS Taxonomy3											   '
		SET @SQL = @SQL +  'FROM [ACECAREDW_TEST].[dbo].NPI_NPPES																				   '
		SET @SQL = @SQL +  'WHERE ["Provider Business Practice Location Address State Name"] IN (' + @SState1 + ')'
		SET @SQL = @SQL +  'AND ["NPI"] = ' + @SValue + ' '
	END																																			   
--ELSE 																																			   
--IF (@Type = 'TIN')																																   
--	BEGIN																																		   
--		SELECT 
--			["NPI"]			AS NPI
--			,["Entity Type Code"] AS EntityTypeCD
--			,["Employer Identification Number (EIN)"] AS EIN
--			,LEFT(RTRIM(["Provider Organization Name (Legal Business Name)"]),100) AS ProvBusinessName
--			,CASE LEN(["Provider Organization Name (Legal Business Name)"]) WHEN 0
--			THEN LEFT(RTRIM(["Provider Last Name (Legal Name)"]),100) + ', ' + LEFT(RTRIM(["Provider First Name"]),100)
--			ELSE LEFT(RTRIM(["Provider Organization Name (Legal Business Name)"]),100)
--			END AS LegalBusinessName
--			,LEFT(RTRIM(["Provider Last Name (Legal Name)"]),100) AS ProvLastName
--			,LEFT(RTRIM(["Provider First Name"]),100) AS ProvFirstName
--			,LEFT(RTRIM(["Provider First Line Business Practice Location Address"]),100) AS ProvPracticeAddress1
--			,LEFT(RTRIM(["Provider Second Line Business Practice Location Address"]),100) AS ProvPracticeAddress2
--			,LEFT(RTRIM(["Provider Business Practice Location Address City Name"]),100) AS ProvPracticeCity
--			,["Provider Business Practice Location Address State Name"] AS ProvPracticeState
--			,LEFT(["Provider Business Practice Location Address Postal Code"],5) AS ProvPracticeZip
--			,["Provider Business Practice Location Address Telephone Number"] AS ProvPracticePhone1
--			,["Provider Business Practice Location Address Fax Number"] AS ProvPracticeFax1
--			,["Last Update Date"] AS RecLastUpdateDate
--			,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_1"]),50) AS Taxonomy1
--			,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_2"]),50) AS Taxonomy2
--			,LEFT(RTRIM(["Healthcare Provider Taxonomy Code_3"]),50) AS Taxonomy3
--		FROM [ACECAREDW_TEST].[dbo].NPI_NPPES
--		WHERE ["Provider Business Practice Location Address State Name"] IN (@State1,@State2,@State3)
--		AND ["Employer Identification Number (EIN)"] = @Value
--	END


	--BEGIN

	--END
--GO
--PRINT @SQL
EXEC [adw].[usp_GetFromNPPES]  @EffDate, @State1, @State2, @State3, @Type, @Value
END
