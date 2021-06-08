

CREATE PROCEDURE	[lst].[usp_lstAllClientDrugProduct]
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
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[SrcFileName] [varchar](50) NULL,	'+
	'[lstDrugProductKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[PRODUCTID] [varchar](50) NULL,'+
	'[PRODUCTNDC] [varchar](15) NULL,'+
	'[PRODUCTTYPENAME] [varchar](50) NULL,	'+
	'[PROPRIETARYNAME] [varchar](2500) NULL,'+
	'[PROPRIETARYNAMESUFFIX] [varchar](250) NULL,'+
	'[NONPROPRIETARYNAME] [varchar](1000) NULL,	'+
	'[DOSAGEFORMNAME] [varchar](50) NULL,'+
	'[ROUTENAME] [varchar](500) NULL,	'+
	'[STARTMARKETINGDATE] [varchar](10) NULL,'+
	'[ENDMARKETINGDATE] [varchar](10) NULL,		'+
	'[MARKETINGCATEGORYNAME] [varchar](50) NULL,'+
	'[APPLICATIONNUMBER] [varchar](20) NULL,'+
	'[LABELERNAME] [varchar](400) NULL,	'+
	'[SUBSTANCENAME] [varchar](5000) NULL,	'+
	'[ACTIVE_NUMERATOR_STRENGTH] [varchar](5000) NULL,	'+
	'[ACTIVE_INGRED_UNIT] [varchar](5000) NULL,	'+
	'[PHARM_CLASSES] [varchar](5000) NULL,	'+
	'[DEASCHEDULE] [varchar](10) NULL,	'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [lstDrugProductKey]
		, [PRODUCTID], [PRODUCTNDC], [PRODUCTTYPENAME], [PROPRIETARYNAME], [PROPRIETARYNAMESUFFIX]
		, [NONPROPRIETARYNAME], [DOSAGEFORMNAME], [ROUTENAME], [STARTMARKETINGDATE], [ENDMARKETINGDATE]
		, [MARKETINGCATEGORYNAME], [APPLICATIONNUMBER], [LABELERNAME], [SUBSTANCENAME], [ACTIVE_NUMERATOR_STRENGTH]
		, [ACTIVE_INGRED_UNIT], [PHARM_CLASSES], [DEASCHEDULE], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [lstDrugProductKey]
		, [PRODUCTID], [PRODUCTNDC], [PRODUCTTYPENAME], [PROPRIETARYNAME], [PROPRIETARYNAMESUFFIX]
		, [NONPROPRIETARYNAME], [DOSAGEFORMNAME], [ROUTENAME], [STARTMARKETINGDATE], [ENDMARKETINGDATE]
		, [MARKETINGCATEGORYNAME], [APPLICATIONNUMBER], [LABELERNAME], [SUBSTANCENAME], [ACTIVE_NUMERATOR_STRENGTH]
		, [ACTIVE_INGRED_UNIT], [PHARM_CLASSES], [DEASCHEDULE], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[List_DRUG_PRODUCT]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[List_Drug_Product]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_DRUG_PRODUCT
	SELECT * FROM ACDW_CLMS_NLH.dbo.List_DRUG_PRODUCT
	SELECT * FROM ACECAREDW_TEST.dbo.List_DRUG_PRODUCT
	*/