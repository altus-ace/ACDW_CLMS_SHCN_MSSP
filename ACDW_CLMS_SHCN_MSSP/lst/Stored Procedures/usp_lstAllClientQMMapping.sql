

CREATE PROCEDURE	[lst].[usp_lstAllClientQMMapping]
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
	'[QmKey] [INT] PRIMARY KEY IDENTITY(1,1),'+
	'[QM] [varchar](20) NOT NULL,'+
	'[QM_DESC] [varchar](500) NULL,	'+
	'[AHR_QM_DESC] [varchar](500) NULL,	'+
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
		, [QmKey], [QM], [QM_DESC], [AHR_QM_DESC], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [QmKey], [QM], [QM_DESC], [AHR_QM_DESC], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_QM_Mapping]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_QM_Mapping]
	--Targets
	/*
	--SELECT * FROM ACDW_CLMS_OKC.lst.LIST_QM_Mapping
	--SELECT * FROM ACDW_CLMS_SHCN.lst.LIST_QM_Mapping
	--SELECT * FROM ACDW_CLMS_UHC.lst.LIST_QM_Mapping
	--SELECT * FROM ACDW_CLMS_WLC.lst.LIST_QM_Mapping
	--SELECT * FROM ACECAREDW_TEST.lst.LIST_QM_Mapping
	  SELECT * FROM ACECAREDW.lst.LIST_QM_Mapping
	  SELECT * FROM DEV_ACECAREDW.lst.LIST_QM_Mapping
	  SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_QM_Mapping
	  SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_QM_Mapping
	  SELECT * FROM ACDW_CLMS_WLC_ECAP.lst.LIST_QM_Mapping
	  SELECT * FROM [ACDW_CLMS_SHCN_MSSP].lst.LIST_QM_Mapping
	*/