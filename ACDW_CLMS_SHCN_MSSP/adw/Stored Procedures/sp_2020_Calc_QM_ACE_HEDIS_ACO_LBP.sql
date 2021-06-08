

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_HEDIS_ACO_LBP]
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
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
	--DECLARE @qmdate date ='2020-05-15'
			--Declare Variables
	DECLARE @Metric				Varchar(20)		='ACE_HEDIS_ACO_LBP'
	DECLARE @Year				INT			    = Year(Getdate())
	DECLARE @RunDate			Date		    = @QMDATE --Getdate()
	DECLARE @RunTime			Datetime	    = Getdate()
	DECLARE @Today				INT		        = CONVERT(INT, Getdate())
	DECLARE @TodayMth			Int			    = Month(Getdate())
	DECLARE @TodayDay			Int			    = Day(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	    = CONCAT('01/1/',@MeasurementYear)
	DECLARE @PrimSvcDate_End	Varchar(20)	    = CONCAT('12/31/',@MeasurementYear)
	DECLARE @CodeSetEffDate		Varchar(20)		= @CodeEffectiveDate
	DECLARE @MbrAceEffectiveDate	DATE		= @MbrEffectiveDate

	
	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date
									,NoOfDaysInt INT,LowBackSvcDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,POS VARCHAR(3),SEQ_CLAIM_ID VARCHAR(50)
									,SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE
									,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE
									,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	-- TmpTable to store Denominator 
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT			DISTINCT ac.SUBSCRIBER_ID 
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate) ac
	JOIN			
					(	SELECT lb.SUBSCRIBER_ID
						FROM
									[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Uncomplicated Low Back Pain','','',''
									,CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), @CodesetEffDate)lb
						LEFT JOIN 				
									(		
									SELECT DISTINCT SUBSCRIBER_ID
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Observation', 'HEDIS_ACO_ED', 'HEDIS_ACO_Outpatient', 'HEDIS_ACO_Inpatient Stay'
									,CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), @CodesetEffDate)
									UNION 
									SELECT DISTINCT SUBSCRIBER_ID
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Osteopathic and Chiropractic Manipulative Treatment', 'HEDIS_ACO_Physical Therapy'
									, 'HEDIS_ACO_Online Assessments','HEDIS_ACO_Telephone Visits'
									,CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), @CodesetEffDate)
									)ot
						ON			lb.SUBSCRIBER_ID = ot.SUBSCRIBER_ID
					)a
	ON			ac.SUBSCRIBER_ID =a.SUBSCRIBER_ID
	WHERE		ac.AGE BETWEEN 18 AND 50

	--Generating and Calculating Values for Exclusions
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT a.Subscriber_ID
	FROM			adw.[2020_tvf_Get_ClaimsByValueSet]('Hospice Intervention','Hospice encounter','','',@PrimSvcDate_Start,@PrimSvcDate_End,@CodesetEffDate)a
	
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
	
	INSERT INTO @TmpTable1 (SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate,LowBackSvcDate,NoOfDaysInt,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT			src.SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ImagingSVC,LowBackSvcDate,NoOfDaysInt,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI
	FROM			
					(
	SELECT DISTINCT a.SUBSCRIBER_ID,b.SUBSCRIBER_ID AS ImagingSubID,a.ValueCodeSvcDate AS LowBackSvcDate
					,b.ValueCodeSvcDate AS ImagingSVC,a.ValueCodeSystem, a.ValueCode
					,b.ValueCode AS ImagingValueCode
					, DATEDIFF(DD,a.ValueCodeSvcDate,a.ValueCodeSvcDate) NoOfDaysInt,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.SVC_PROV_NPI
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Uncomplicated Low Back Pain','','','',@PrimSvcDate_Start,@PrimSvcDate_End,@CodesetEffDate )a 
	LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_Imaging Study','','',@PrimSvcDate_Start,@PrimSvcDate_End,@CodesetEffDate) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			b.SUBSCRIBER_ID IS NOT NULL
					)src
	WHERE			NoOfDaysInt <= 28
	--AND				NoOfDaysInt NOT LIKE '-%'
	

		-- Insert into Numerator Header using TmpTable
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable1

	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate ,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI
	FROM			@TmpTable1
	
	-- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable2 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.SVC_PROV_NPI 
	FROM			@TmpTable3 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a LEFT JOIN @TmpNumHeader b 
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
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),'','' 
	FROM			@TmpDenHeader*/
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),SEQ_CLAIM_ID
					,SVC_TO_DATE ,SVC_PROV_NPI
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
EXEC [adw].[sp_2020_Calc_QM_ACE_HEDIS_ACO_LBP] @ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
											   @QMDATE				    = '2021-05-15',
											   @CodeEffectiveDate		= '2020-01-01',
											   @MeasurementYear		    = 2021,
											   @ClientKeyID			    = 16,
											   @MbrEffectiveDate		= '2021-04-01'
***/




