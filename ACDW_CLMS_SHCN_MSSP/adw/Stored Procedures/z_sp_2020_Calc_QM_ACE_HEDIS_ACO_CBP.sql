﻿




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z_sp_2020_Calc_QM_ACE_HEDIS_ACO_CBP] 
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
	@QMDATE						DATE,
	@CodeEffectiveDate			DATE,
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN

	--	DECLARE @ClientKeyID			Varchar(2) = '16'
	--	DECLARE @MeasurementYear INT = 2020
	--	DECLARE @CodeEffectiveDate date = '2020-01-01'
	--	DECLARE @qmdate date ='2020-09-15'								
	--  Declare Variables
	DECLARE @Metric				Varchar(20)			= 'ACE_HEDIS_ACO_CBP'
	DECLARE @RunDate			Date				= @QMDATE --Getdate()
	DECLARE @RunTime			Datetime			= Getdate()
	DECLARE @Today				Date				= Getdate()
	DECLARE @TodayMth			Int					= Month(Getdate())
	DECLARE @TodayDay			Int					= Day(Getdate())
	DECLARE @Year				INT					=Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)			=CONCAT('01/1/',@MeasurementYear)
	DECLARE @PrimSvcDate_End	Varchar(20)			= CONCAT('12/31/',@MeasurementYear)
	DECLARE @StartDatePriorToMeasurementYear Date	= CONCAT('01/1/', @MeasurementYear - 1)
	DECLARE @CodeSetEffective  VARCHAR(20)			= @CodeEffectiveDate

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, '0', '0', ''
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@RunDate) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('', ''
					,'','HEDIS_ACO_Essential Hypertension', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE BETWEEN 18 AND 85

	--Generating and Calculating Values for Exclusions for ages between 66 - 80
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID--,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@RunDate) a	 
	JOIN			
					(
						SELECT DISTINCT	o.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Frailty', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Acute Inpatient', 'HEDIS_ACO_Advanced Illness',  'Dementia Medications','',@StartDatePriorToMeasurementYear
										, @PrimSvcDate_End,@CodeSetEffective) n
						ON				o.SUBSCRIBER_ID = n.SUBSCRIBER_ID
						UNION
						SELECT DISTINCT a.Subscriber_ID
						FROM			adw.[2020_tvf_Get_ClaimsByValueSet]('Hospice Intervention','Hospice encounter','','',@MeasurementYear,@PrimSvcDate_End,@CodeSetEffective)a
					)b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE BETWEEN 66 AND 80

	--Generating and Calculating Values for Exclusions for ages 81 and above
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID--,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@RunDate) a	 
	JOIN			
					(
						SELECT DISTINCT	o.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Frailty', 'Hospice Intervention','Hospice encounter','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
					)b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE >=81
		
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
	
	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,MaxDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, MAX(a.PRIMARY_SVC_DATE) AS MAXDATE
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Outpatient Without UBREV', 'HEDIS_ACO_Telephone Visits'
					, 'HEDIS_ACO_Online Assessments','HEDIS_ACO_Essential Hypertension', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Systolic Less Than 140', '', '', '',@PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Diastolic Less Than 80', 'HEDIS_ACO_Diastolic 80-89', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) c
	ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
    GROUP BY		a.SUBSCRIBER_ID
    HAVING			COUNT(DISTINCT a.PRIMARY_SVC_DATE) >= 2
		

	--TmpTable to store Numerator Values for Details
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID,MaxDate, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT DISTINCT a.SUBSCRIBER_ID,MAX(a.PRIMARY_SVC_DATE), a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID,a.SVC_TO_DATE
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Outpatient Without UBREV', 'HEDIS_ACO_Telephone Visits'
					, 'HEDIS_ACO_Online Assessments','HEDIS_ACO_Essential Hypertension', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Systolic Less Than 140', '', '', '',@PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Diastolic Less Than 80', 'HEDIS_ACO_Diastolic 80-89', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) c
	ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
    GROUP BY		a.SUBSCRIBER_ID,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID,a.SVC_TO_DATE

		
  -- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
	SELECT			DISTINCT a.SUBSCRIBER_ID 
	FROM			@TmpTable2 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID,a.SVC_TO_DATE
	FROM		    @TmpTable4 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	--select * from @TmpNumDetail
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			a.SUBSCRIBER_ID 
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
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() ,'',''
	FROM			@TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() ,SEQ_CLAIM_ID,SVC_TO_DATE
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
EXEC [adw].[sp_2020_Calc_QM_ACE_HEDIS_ACO_CBP]'[adw].[QM_ResultByMember_Testing]','2020-09-15','2020-01-01',2020,16
***/
