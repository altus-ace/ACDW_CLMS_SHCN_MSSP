CREATE PROCEDURE [ast].[Load_StgFctMembership2]
                 (@MbrYear SmallInt
				 ,@MbrMonth TinyINT
				 ,@RwEffectiveDate DATE
				 ,@RwExpirationDate DATE
				 ,@MemberCurrentEffectiveDate DATE
				 ,@MemberCurrentExpirationDate Date)

AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN

BEGIN
				
				DECLARE @MbrMonths TINYINT = @MbrMonth 
				DECLARE @MbrYears SMALLINT = @MbrYear				
				DECLARE @RwEffectiveDates  DATE = @RwEffectiveDate
				DECLARE @RwExpirationDates  DATE = @RwExpirationDate 
				DECLARE @MemberCurrentEffectiveDates DATE = @MemberCurrentEffectiveDate
				DECLARE @MemberCurrentExpirationDates DATE = @MemberCurrentExpirationDate
	--DECLARE @YearNBRs INT = @YearNBR 

INSERT INTO  ast.StgFctMembership	
				([AdiKey]
				,[SrcFileName]		
				,[AdiTableName]		
				,[LoadDate]
				,[DataDate]			
				,[RwEffectiveDate]
				,[RwExpirationDate]
				,[ClientKey]		
				,[Ace_ID]			
				,[ClientMemberKey]	
				,[MBI]				
				,[HICN]				
				,[FirstName]		
				,[LastName]			
				,[Gender]			
				,[DOB]				
				,[DOD]				
				,[CurrentAge]		
				,[MbrMonth]			
				,[MbrYear]			
				,[MemberHomeAddress]
				,[MemberHomeCity]	
				,[MemberHomeState]	
				,[MemberHomeZip]	
				,[LOB]				
				,[Contract]			
				,[NPI]	
				,[ClientRiskScore]	
				,[MemberCurrentEffectiveDate]	
				,[MemberCurrentExpirationDate]
				,[PlanName]
				,[Active])			
SELECT			MSSPAnnualmembership_HALRBASEKey
				,[SrcFileName]
				,'[adi].[Steward_MSSPAnnualmembership_HALRBASE]'
				,GETDATE()
				,[DataDate]
				,@RwEffectiveDate
				,@RwExpirationDate
				,(SELECT ClientKey FROM lst.List_Client WHERE ClientName = 'Steward Health Care Network MSSP')
				,0
				,MedicareBeneficiaryID
				,MedicareBeneficiaryID
				,HealthInsuranceClaimNBR
				,FirstNM
				,LastNM
				,SexCD
				,BirthDTS
				,'1900-01-01' --No DOD from SrcFile
				,DATEDIFF(YY,BirthDTS,@RwEffectiveDate)
				,@MbrMonth
				,@MbrYear
				,'','','',''
				,'MSSP'
				,(SELECT ClientShortName FROM lst.List_Client WHERE ClientKey = '16')
				,''--AttributedNPI
				,0--HCCRiskScore
				,@MemberCurrentEffectiveDate
				,@MemberCurrentExpirationDate
				,'MSSP'
				,1
FROM			[adi].[Steward_MSSPAnnualmembership_HALRBASE]
WHERE			YearNBR = 2019

END


COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
/*
USAGE 
EXEC [ast].[Load_StgFctMembership2] 2019,1,'2019-01-01','2019-01-31','2019-01-01','2019-12-31'
@MbrYear,@MbrMonth,@RwEffectiveDate ,@RwExpirationDate, @MemberCurrentEffectiveDate, @MemberCurrentExpirationDate
*/


