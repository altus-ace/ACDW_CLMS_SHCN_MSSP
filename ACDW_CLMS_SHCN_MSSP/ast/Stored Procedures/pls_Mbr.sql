/****** Script for SelectTopNRows command from SSMS  ******/

	CREATE PROCEDURE ast.pls_Mbr

	AS

	BEGIN
	INSERT INTO ast.MbrModelMbrData(
						SrcFileName
						,DataDate
						,ClientSubscriberId
						,mbrFirstName
						,mbrLastName
						,mbrGENDER
						,mbrDob
						,mbrDOD
						,prvNPI)
	SELECT 
						[SrcFileName]
						,[DataDate]
						,[MedicareBeneficiaryID]
						,[FirstNM]
						,[LastNM]
						,[SexCD]
						,[BirthDTS]
						,[DeathDTS]
						,[NPIMapping]
	FROM [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPRiskPopulation]
	WHERE				DataDate = (SELECT MAX(DataDate) 
									FROM [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPRiskPopulation])

	END