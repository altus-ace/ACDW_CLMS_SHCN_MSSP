




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_CMS_FLU] 
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
	@QMDATE DATE,
	@CodeEffectiveDate DATE,
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2),
	@MbrEffectiveDate			DATE
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
			
	--DECLARE @ClientKeyID			Varchar(2) = '16'
	--DECLARE @MeasurementYear INT = 2020
	--DECLARE @CodeEffectiveDate date = '2020-01-01'
	--DECLARE @qmdate date ='2020-10-15'		DECLARE @MbrEffectiveDate DATE = '2020-12-15'
			--Declare Variables
	DECLARE @Metric				Varchar(20)		= 'ACE_ACO_FLU'
	DECLARE @Year				INT			    = Year(Getdate())
	DECLARE @RunDate			Date		    = @QMDATE --Getdate()
	DECLARE @RunTime			Datetime	    = Getdate()
	DECLARE @Today				INT		        = CONVERT(INT, Getdate())
	DECLARE @TodayMth			Int			    = Month(Getdate())
	DECLARE @TodayDay			Int			    = Day(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	    = CONCAT('01/1/',@MeasurementYear)
	DECLARE @PrimSvcDate_End	Varchar(20)	    = CONCAT('12/31/',@MeasurementYear)
	DECLARE @CodeSetEffDate		Varchar(20)		= @CodeEffectiveDate
	DECLARE @PriorYearOct		Varchar(20)		= CONCAT('10/1/',@MeasurementYear - 1) -- Replaced Param = October1st 2019 to March 31st 2020. Use to be From August Prior year 
	DECLARE @CurrentYearMarch	Varchar(20)		= CONCAT('03/31/',@MeasurementYear )  -- Replaced Param = October1st 2019 to March 31st 2020. Use to be till March of the current year
	DECLARE @PriorYearAugst		Varchar(20)		= CONCAT('08/1/',@MeasurementYear - 1)
	DECLARE @MbrAceEffectiveDate	DATE		= @MbrEffectiveDate
	
	
	--during August of prior year to March of the measurement year Eg. August 1st 2019 to March 31st 2020

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	
	-- TmpTable to store Denominator
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT			DISTINCT a.Subscriber_ID
	FROM			(
	SELECT DISTINCT	SUBSCRIBER_ID 
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@MbrAceEffectiveDate)
	WHERE			AGE >=0
					)a
	JOIN			
					(SELECT SUBSCRIBER_ID,PROCEDURE_CODE FROM adw.Claims_Details
					WHERE PROCEDURE_CODE BETWEEN  '99201' AND '99499' AND SVC_TO_DATE
					BETWEEN @PriorYearOct AND @CurrentYearMarch)cpt
	ON				a.SUBSCRIBER_ID = cpt.SUBSCRIBER_ID

	
	--Generating and Calculating Values for Exclusions
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT a.Subscriber_ID
	FROM			adw.[2020_tvf_Get_ClaimsByValueSet]('Hospice Intervention','Hospice encounter','','',@PriorYearOct,@CurrentYearMarch,@CodesetEffDate)a
	
	--Inserting Values for DEN with Exclusion
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			@TmpTable1
	EXCEPT
	SELECT			SUBSCRIBER_ID
	FROM			@TmpTable2	

	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
	
	-- TmpTable to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE,SVC_PROV_NPI)
	---- THIS to be implemented from April 2021
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE,SVC_PROV_NPI
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization','','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	/*
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_6 months & older','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate) 
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_6 months 35 months','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_2 through 49 years','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_3 years & older','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_4 years & older','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_18 years & older','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	UNION
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_Influenza Immunization_65  years & olde','ACO_Influenza Immunization','','',@PriorYearAugst,@CurrentYearMarch,@CodeSetEffDate)
	*/
	-- Insert into Numerator Header
	INSERT INTO		@TmpNumHeader
	SELECT			a.SUBSCRIBER_ID 
	FROM			@TmpTable1 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b

	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID, SVC_TO_DATE,SVC_PROV_NPI)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID, a.SVC_TO_DATE,a.SVC_PROV_NPI
	FROM			@TmpTable1 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
			
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a 
	LEFT JOIN		@TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID IS NULL 
		
	IF				@ConnectionStringProd = @ConnectionStringProd
	BEGIN    
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'DEN' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'NUM' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'COP' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader    
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	/*INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy],
					SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),'','' 
	FROM			@TmpDenHeader*/
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME()
					,SEQ_CLAIM_ID,SVC_TO_DATE ,SVC_PROV_NPI
	FROM			@TmpNumDetail
	PRINT			'This is a Production Environment'
	END
	ELSE
	
	BEGIN
	PRINT			'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

END  

/***
Usage: 
EXEC [adw].[sp_2020_Calc_QM_ACE_CMS_FLU]	 @ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
											 @QMDATE				= '2021-05-15',
											 @CodeEffectiveDate		= '2020-01-01',
											 @MeasurementYear		= 2021,
											 @ClientKeyID			= 16,
											 @MbrEffectiveDate		= '2021-04-01'
***/

	
	
	