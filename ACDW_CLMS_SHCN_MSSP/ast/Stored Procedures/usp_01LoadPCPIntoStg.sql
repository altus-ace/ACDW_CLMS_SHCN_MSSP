

CREATE PROCEDURE [ast].[usp_01LoadPCPIntoStg](@ClientKey INT,@DataDate DATE) --[ast].[usp_01LoadPCPIntoStg]16,'2021-04-13'
AS
---Insert into stg and transform
--stg table shud be same structure as list pcp
--insert into Acemasterdata list pcp

BEGIN

---Step 1 populate TIN Addresses into respective Tables
BEGIN
	EXECUTE ACECAREDW.[adw].[FctPR_PryAddress]'[ACECAREDW].[adw].[FctProviderPracticePrimaryAddress]'
	EXECUTE ACECAREDW.[adw].[FctPR_BillingAddress]'[ACECAREDW].[adw].[FctProviderPracticeBillingAddress]'
END
--Step 2: Insert into Staging
		/*
		IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
		CREATE TABLE #Prr(NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

		INSERT INTO #Prr(NPI,AttribTIN,ClientNPI,ClientTIN,MemberID)
		EXECUTE  [adi].[GetMbrNpiAndTin_SHCN_MSSP]'2021-03-13',0,16*/
		TRUNCATE TABLE ast.LIST_PCP 

		INSERT INTO			ast.LIST_PCP (  -- SELECT * FROM lst.LIST_PCP
							[SrcFileName]
							, [CLIENT_ID]
							, [PCP_NPI]
							, [PCP_FIRST_NAME]
							, [PCP_MI]
							, [PCP_LAST_NAME]
							, [PCP__ADDRESS]
							, [PCP__ADDRESS2]
							, [PCP_CITY]
							, [PCP_STATE]  
							, [PCP_ZIP]
							, [PCP_PHONE]
							, [PCP_CLIENT_ID]
							, [PCP_PRACTICE_TIN]
							, [PCP_PRACTICE_TIN_NAME]
							, [PRIM_SPECIALTY]
							, [Sub_Speciality]
							, [PROV_TYPE]
							, [PCP_FLAG]
							, [CAMPAIGN_RUN_ID]
							, [T_Modify_by]
							, [ACTIVE]
							, [EffectiveDate]
							, [ExpirationDate]
							, [PCP_POD]
							, [AccountType]
							, [County]
							,TinHPEffectiveDate
							,TinHPExpirationDate)
		--DECLARE @DATE DATE = GETDATE()
		SELECT				[SrcFileName]
							,[CLIENT_ID]
							,[PCP_NPI]
							,[PCP_FIRST_NAME]
							,[PCP_MI]
							,[PCP_LAST_NAME]
							,[PCP__ADDRESS]
							,[PCP__ADDRESS2]
							,[PCP_CITY]
							,[PCP_STATE]
							,[PCP_ZIP]
							,[PCP_PHONE]
							,[PCP_CLIENT_ID]
							,[PCP_PRACTICE_TIN]
							,[PCP_PRACTICE_TIN_NAME]
							,[PRIM_SPECIALTY]
							,[Sub_Speciality]
							,[PROV_TYPE]
							,[PCP_FLAG]
							,[CAMPAIGN_RUN_ID]
							,[T_Modify_by]
							,[ACTIVE]
							,[EffectiveDate]
							,[ExpirationDate]			
							,[PCP_POD]
							,[AccountType]
							,[County]
							,TinHPEffectiveDate
							,TinHPExpirationDate
							--,[RwCnt]
		FROM				(
									SELECT			'[ACECAREDW].adw.tvf_AllClient_ProviderRoster'				AS [SrcFileName]
													, pr.[ClientKey]												AS [CLIENT_ID]
													, pr.[NPI]														AS [PCP_NPI]
													, pr.[FirstName]											AS [PCP_FIRST_NAME]
													, ''														AS [PCP_MI]
													, pr.[LastName]												AS [PCP_LAST_NAME]
													, pry.PrimaryAddress											AS [PCP__ADDRESS]
													, ''														AS [PCP__ADDRESS2]
													, pry.PrimaryCity												AS [PCP_CITY]
													, pry.PrimaryState												AS [PCP_STATE]
													, pry.PrimaryZipcode											AS [PCP_ZIP]
													, pry.PrimaryAddressPhoneNumber									AS [PCP_PHONE]
													, ''														AS [PCP_CLIENT_ID]
													, pr.[AttribTIN]														AS [PCP_PRACTICE_TIN]
													, pr.AttribTINName											AS [PCP_PRACTICE_TIN_NAME]
													, pr.ProviderSpecialty										AS [PRIM_SPECIALTY]
													, pr.ProviderSubSpecialty									AS [Sub_Speciality]
													, pr.[ProviderType]											AS [PROV_TYPE]
													, CASE pr.[ProviderType]
													   WHEN 'PCP' THEN 'Y'
													   ELSE 'N'
													   END														AS [PCP_FLAG]
													, ''														AS [CAMPAIGN_RUN_ID]
													, ''														AS [T_Modify_by]
													, 'Y'														AS [ACTIVE]
													, pr.NpiHpEffectiveDate										AS [EffectiveDate]
													, pr.NpiHpExpirationDate									AS [ExpirationDate]						
													, pr.[Chapter]													AS [PCP_POD]
													, pr.[AccountType]											AS [AccountType]
													, pr.[PrimaryCounty]											AS [County]
													,pr.TinHPEffectiveDate										AS TinHPEffectiveDate
													,pr.TinHPExpirationDate										AS TinHPExpirationDate
													--, ROW_NUMBER() OVER (PARTITION BY NPI, TIN ORDER BY DataDate DESC) RwCnt
									FROM			[ACECAREDW].adw.tvf_AllClient_ProviderRoster (16,GETDATE(),1) pr
									JOIN			(		SELECT * FROM (
																		SELECT	pry.TIN,PrimaryAddress,PrimaryCity
																				,PrimaryState,PrimaryZipcode
																				, PrimaryAddressPhoneNumber
																				, ROW_NUMBER()OVER(PARTITION BY pry.TIN ORDER BY pry.DataDate DESC)RwCnt
																		FROM	[ACECAREDW].[adw].[FctProviderPracticePrimaryAddress] pry
																		JOIN	[ACECAREDW].[adw].[FctProviderPracticeBillingAddress] bil
																		ON		pry.TIN = bil.TIN	
																		  )a
																		WHERE	 RwCnt = 1
													)pry
									ON				pr.AttribTIN = pry.TIN
									
							)drv
END

BEGIN					

--Step 2: Transform Data
		UPDATE			ast.LIST_PCP
		SET				[PCP__ADDRESS] =  [adi].[udf_ConvertToCamelCase](ISNULL([PCP__ADDRESS],''))
						,[PCP_CITY]   =   [adi].[udf_ConvertToCamelCase](ISNULL([PCP_CITY],''))
						,[PCP_FIRST_NAME]   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_FIRST_NAME,''))
						,PCP_LAST_NAME   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_LAST_NAME,''))
						,PCP_PRACTICE_TIN_NAME   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_PRACTICE_TIN_NAME,''))
						,PRIM_SPECIALTY   =   [adi].[udf_ConvertToCamelCase](ISNULL(PRIM_SPECIALTY,''))
						,Sub_Speciality   =   [adi].[udf_ConvertToCamelCase](ISNULL(Sub_Speciality,''))
						,County   =   [adi].[udf_ConvertToCamelCase](ISNULL(County,''))
						,PCP_POD   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_POD,''))
						,PROV_TYPE   =   [adi].[udf_ConvertToCamelCase](ISNULL(PROV_TYPE,''))
		FROM			ast.LIST_PCP lst

		UPDATE			ast.List_PCP
		SET				PCP__ADDRESS = ''
		WHERE			PCP__ADDRESS IS NULL

		UPDATE			ast.List_PCP
		SET				PCP__ADDRESS2 = ''
		WHERE			PCP__ADDRESS2 IS NULL

		--d Format PCP_Phone
		UPDATE			ast.LIST_PCP
		SET				PCP_PHONE = [lst].[fnStripNonNumericChar](PCP_PHONE)

		---Update PCP_POD for Ace NPIs 
		UPDATE			ast.LIST_PCP
		SET				PCP_POD =
						(CASE WHEN AccountType NOT IN ('SHCN_SMG','SHCN_AFF') THEN 'Tx - Ace' 
						ELSE PCP_POD
						END )
		FROM			ast.LIST_PCP


END

/*
usage: EXECUTE [ast].[usp_01LoadPCPIntoStg]16,'2021-03-01'
*/


--Validation
SELECT		COUNT(*), PCP_NPI
FROM		ast.LIST_PCP 	
GROUP BY	PCP_NPI
HAVING		COUNT(*)>1

SELECT * FROM ast.LIST_PCP