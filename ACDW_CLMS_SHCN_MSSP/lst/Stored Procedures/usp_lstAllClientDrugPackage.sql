


CREATE PROCEDURE	[lst].[usp_lstAllClientDrugPackage]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_AET_TX_COM.lst.LIST_ICD10CM'
				DECLARE	@SqlString NVARCHAR(MAX)
				

			-----Step 4
--Drop all Targets A
--Creates all Targets B
--Insert into all Target C

--A Drop all Targets
	SET @SqlString = N'DROP TABLE ' +  @ConnectionString 
	EXECUTE sp_executesql @SqlString
		--PRINT @SqlString
 
--B Create all Targets
  
--Create Triggers 
	SET @SqlString = 
	N'CREATE TABLE ' + @ConnectionString + '(' +
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,	'+
	'[LastUpdated] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[SrcFileName] [varchar](50) NULL,	'+
	'[lstDrugPackageKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[PRODUCTID] [varchar](50) NOT NULL,'+
	'[PRODUCTNDC] [varchar](15) NOT NULL,'+
	'[NDCPACKAGECODE] [varchar](20) NOT NULL,'+
	'[PACKAGEDESCRIPTION] [varchar](1000) NOT NULL,	'+
	'[NDCPACKAGECODE11DIGIT] [varchar](50) NOT NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstDrugPackageKey], [PRODUCTID], [PRODUCTNDC], [NDCPACKAGECODE], [PACKAGEDESCRIPTION]
		, [NDCPACKAGECODE11DIGIT], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstDrugPackageKey], [PRODUCTID], [PRODUCTNDC], [NDCPACKAGECODE], [PACKAGEDESCRIPTION]
		, [NDCPACKAGECODE11DIGIT], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[List_DRUG_PACKAGE]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[List_Drug_Package]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_DRUG_PACKAGE
	SELECT * FROM ACDW_CLMS_NLH.dbo.List_DRUG_PACKAGE
	SELECT * FROM ACECAREDW_TEST.dbo.List_DRUG_PACKAGE
	SELECT * FROM ACECAREDW_TEST.dbo.List_DRUG_PACKAGE2
	SELECT * FROM [ACDW_CLMS_SHCN_MSSP].lst.List_DRUG_PACKAGE
	*/