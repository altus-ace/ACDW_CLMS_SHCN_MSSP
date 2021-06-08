




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z_sp_2020_Calc_QM_ACE_HEDIS_SPC] 
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
	@QMDATE DATE,
	@CodeEffectiveDate DATE,
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
		
	--DECLARE @ClientKeyID			Varchar(2) = '16'
	--DECLARE @MeasurementYear INT = 2020
	--DECLARE @CodeEffectiveDate date = '2020-01-01'
	--DECLARE @qmdate date ='2020-07-15'
	-- Declare Variables
	DECLARE @Metric				Varchar(20)		= 'ACE_HEDIS_SPC'
	DECLARE @Year				INT			    = Year(Getdate())
	DECLARE @RunDate			Date		    = @QMDATE --Getdate()
	DECLARE @RunTime			Datetime	    = Getdate()
	DECLARE @Today				INT		        = CONVERT(INT, Getdate())
	DECLARE @TodayMth			Int			    = Month(Getdate())
	DECLARE @TodayDay			Int			    = Day(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	    = CONCAT('01/1/',@MeasurementYear-2)
	DECLARE @PrimSvcDate_End	Varchar(20)	    = CONCAT('12/31/',@MeasurementYear)
	DECLARE @CodeSetEffective	Varchar(20)		= CONCAT('01/01/',@MeasurementYear) 
	DECLARE @StartDatePriorToMeasurementYear Date	= CONCAT('01/1/', @MeasurementYear - 1)
	
		
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
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@RunDate)
	WHERE			AGE BETWEEN 40 AND 75
	AND				GENDER = 'F'
	AND				DOD = '1900-01-01'
	UNION
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE			AGE BETWEEN 21 AND 75
	AND				GENDER = 'M'
	
	
	--Generating and Calculating Values for DEN Events
	--1
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT	src.SUBSCRIBER_ID
	FROM			(
	SELECT DISTINCT  a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('MI', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	UNION
	--2
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('CABG','','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective)
	UNION
	--3
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','PCI','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
	UNION
	--4
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Other Revascularization','',''
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
	
	UNION 
	--5
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','Outpatient',''  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	UNION 
	--6
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','Telephone Visits',''  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	UNION
	--7a
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','Online Assessments',''  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	UNION
	--7b
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			(	
						SELECT a.SUBSCRIBER_ID 
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('','Acute Inpatient',''  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
						ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
					)a
	EXCEPT			(	
						SELECT o.SUBSCRIBER_ID 
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('','Telehealth Modifier','Telehealth POS'  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) o
					)
	
	UNION
	
	--8
	SELECT DISTINCT	u.SUBSCRIBER_ID
	FROM			(	
						SELECT a.SUBSCRIBER_ID 
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('','IVD',''  
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
					)u
					JOIN			
					(
						SELECT	b.SUBSCRIBER_ID 	
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
						EXCEPT
						SELECT	o.SUBSCRIBER_ID 	
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
					)z
	ON				u.SUBSCRIBER_ID = z.SUBSCRIBER_ID
					)src
	JOIN
					(	SELECT			SUBSCRIBER_ID,PLACE_OF_SVC_CODE1 
						FROM			adw.Claims_Details 
						WHERE			PLACE_OF_SVC_CODE1 NOT IN ('31','32','33','34', '')
									)trg
	ON				src.SUBSCRIBER_ID = trg.SUBSCRIBER_ID
	--Generating Values for DEN without Exclusions
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID)   --stores commonalities between sets 1 and 2
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			@TmpTable1 a -- Stores age
	JOIN			@TmpTable2 b  --stores added criteria
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
				
	--Generating and Calculating Values for Exclusions
	--1
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID)
	SELECT DISTINCT  src.SUBSCRIBER_ID
	FROM			(
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','Pregnancy','IVF','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
	UNION
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Dialysis Procedure','','','ESRD Diagnosis',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a --Cirrhosis
	UNION
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Cirrhosis','Muscular Pain and Disease','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a 
	UNION
	--2 Common Exclusions
	SELECT DISTINCT a.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@RunDate) a	 
	JOIN			
					(
						SELECT DISTINCT	o.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Frailty', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Acute Inpatient', 'HEDIS_ACO_Advanced Illness','Dementia Medications'
										,'',@StartDatePriorToMeasurementYear
										, @PrimSvcDate_End,@CodeSetEffective) n
						ON				o.SUBSCRIBER_ID = n.SUBSCRIBER_ID
					)b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE >=66
	UNION
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Cirrhosis','Muscular Pain and Disease','Hospice Intervention','Hospice encounter',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective)
					)src
	JOIN
					(	SELECT			SUBSCRIBER_ID,PLACE_OF_SVC_CODE1 
						FROM			adw.Claims_Details 
						WHERE			PLACE_OF_SVC_CODE1 NOT IN ('31','32','33','34', '')
					)trg
	ON				src.SUBSCRIBER_ID = trg.SUBSCRIBER_ID

	--Inserting Values for DEN with Exclusion
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			@TmpTable3
	EXCEPT
	SELECT			SUBSCRIBER_ID
	FROM			@TmpTable1	

	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable3

	-- Generating Values to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE )
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE 
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('High and Moderate-Intensity Statin Medications','','','',@PrimSvcDate_Start,@PrimSvcDate_End,@CodeSetEffective)

	-- Insert into Numerator Header 
	INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b

	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE )
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate ,a.SEQ_CLAIM_ID,a.SVC_TO_DATE 
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
	SELECT			@ClientKeyID, SUBSCRIBER_ID, @Metric , 'DEN' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID, @Metric , 'NUM' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID, @Metric , 'COP' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),'','' 
	FROM			@TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME(),SEQ_CLAIM_ID,SVC_TO_DATE 
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
EXEC [adw].[sp_2020_Calc_QM_ACE_HEDIS_SPC] '[adw].[QM_ResultByMember_History]','2020-07-15','2020-01-01',2020,16
***/

