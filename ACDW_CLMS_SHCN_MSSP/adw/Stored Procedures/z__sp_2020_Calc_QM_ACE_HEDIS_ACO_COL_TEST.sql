


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z__sp_2020_Calc_QM_ACE_HEDIS_ACO_COL_TEST] 
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_Test]',
	@QMDATE						DATE,
	@CodeEffectiveDate			DATE,
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
		--DECLARE @qmdate date ='2021-01-15'	
		--DECLARE @MbrEffectiveDate DATE = '2020-12-15'
	-- Declare Variables
	DECLARE @Metric			    Varchar(20)	   = 'ACE_HEDIS_ACO_COL'
	DECLARE @RunDate		    Date		   = @QMDATE --Getdate()
	DECLARE @RunTime		    Datetime	   = Getdate()
	DECLARE @Today			    Date		   = Getdate()
	DECLARE @TodayMth		    Int			   = Month(Getdate())
	DECLARE @TodayDay		    Int			   = Day(Getdate())
	DECLARE @Year				INT			   =Year(Getdate())
	DECLARE @StartDatePriorToMeasurementYear Date	= CONCAT('01/1/', @MeasurementYear - 1)
	DECLARE @PrimSvcDate_Start	VarChar(20)		=CONCAT('01/1/',@MeasurementYear)
	DECLARE @PrimSvcDate_End	Varchar(20)		= CONCAT('12/31/',@MeasurementYear)
	DECLARE @CodeSetEffective	Varchar(20)		= @CodeEffectiveDate
	DECLARE @MbrAceEffectiveDate	DATE		= @MbrEffectiveDate

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)	
					
	-- TmpTable to store Denominator 
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT			SUBSCRIBER_ID 
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate)
	WHERE			AGE BETWEEN 50 AND 75

	--Generating and Calculating Values for Exclusions
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID--,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@MbrAceEffectiveDate) a	 
	JOIN			
					(
						SELECT DISTINCT	o.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Frailty', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Acute Inpatient', 'HEDIS_ACO_Advanced Illness','Dementia Medications','',@StartDatePriorToMeasurementYear
										, @PrimSvcDate_End,@CodeSetEffective) n
						ON				o.SUBSCRIBER_ID = n.SUBSCRIBER_ID
						UNION
						SELECT DISTINCT Subscriber_ID
						FROM			adw.[2020_tvf_Get_ClaimsByValueSet]('Hospice Intervention','Hospice encounter','','',@StartDatePriorToMeasurementYear,@PrimSvcDate_End,@CodeSetEffective)
					)b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE >=66

	--Inserting Values for DEN with Exclusion
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID)
	SELECT			SUBSCRIBER_ID
	FROM			@TmpTable1
	EXCEPT
	SELECT			SUBSCRIBER_ID
	FROM			@TmpTable2

	-- Insert into Denominator Header using TmpTable
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable3
	
	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
	DELETE FROM		@TmpTable3

	-- TmpTable to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_FOBT','','','',CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear), @CodeSetEffective)
	UNION
	SELECT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Flexible Sigmoidoscopy','','','',CONCAT('1/1/',@MeasurementYear-4), CONCAT('12/31/',@MeasurementYear), @CodeSetEffective)
	UNION
	SELECT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Colonoscopy','','','',CONCAT('1/1/',@MeasurementYear-9), CONCAT('12/31/',@MeasurementYear), @CodeSetEffective)
	UNION
	SELECT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_CT Colonography','','','',CONCAT('1/1/',@MeasurementYear-4), CONCAT('12/31/',@MeasurementYear), @CodeSetEffective)
	UNION
	SELECT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_FIT-DNA','','','',CONCAT('1/1/',@MeasurementYear-2), CONCAT('12/31/',@MeasurementYear), @CodeSetEffective)
	
	-- Insert into Numerator Header using TmpTable
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable1
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM			@TmpTable1
	
	-- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable2 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate ,a.SEQ_CLAIM_ID,a.SVC_TO_DATE
	FROM			@TmpTable3 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a LEFT JOIN @TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID IS NULL 
		

	---Insert DEN into Target Table QM Result By Member
	IF				@ConnectionStringProd = @ConnectionStringProd
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'DEN' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'NUM' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID, @Metric , 'COP' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_TESTING](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),'','' 
	FROM			@TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_TESTING](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
					,SEQ_CLAIM_ID,SVC_TO_DATE
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
EXEC [adw].[sp_2020_Calc_QM_ACE_HEDIS_ACO_COL_TEST]'[adw].[QM_ResultByMember_Testing]','2021-01-15','2020-01-01',2020,16,'2020-12-15'
***/
