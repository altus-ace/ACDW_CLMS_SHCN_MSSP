




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[z_sp_2020_Calc_QM_ACE_HEDIS_ACO_BCS] 
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
	--DECLARE @qmdate date ='2020-05-15'
	-- Declare Variables
	DECLARE @Metric				Varchar(20)		= 'ACE_HEDIS_ACO_BCS'
	DECLARE @Year				INT			    = Year(Getdate())
	DECLARE @RunDate			Date		    = @QMDATE --Getdate()
	DECLARE @RunTime			Datetime	    = Getdate()
	DECLARE @Today				INT		        = CONVERT(INT, Getdate())
	DECLARE @TodayMth			Int			    = Month(Getdate())
	DECLARE @TodayDay			Int			    = Day(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	    = CONCAT('10/1/',@MeasurementYear-2)
	DECLARE @PrimSvcDate_End	Varchar(20)	    = CONCAT('12/31/',@MeasurementYear)
	DECLARE @CodeSetEffective	Varchar(20)		= CONCAT('01/01/',@MeasurementYear) 
	
		
	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date, SEQ_CLAIM_ID Varchar(20),SVC_TO_DATE DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)	
					
	-- TmpTable to store Denominator 
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT			DISTINCT a.Subscriber_ID
	FROM			(
	SELECT DISTINCT	SUBSCRIBER_ID 
	FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@RunDate)
	WHERE			AGE BETWEEN 51 AND 74
	AND				GENDER = 'F'
					)a
	JOIN			
					(SELECT SUBSCRIBER_ID,PROCEDURE_CODE FROM adw.Claims_Details
					WHERE PROCEDURE_CODE BETWEEN  '99201' AND '99499' AND SVC_TO_DATE
					BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End)cpt
	ON				a.SUBSCRIBER_ID = cpt.SUBSCRIBER_ID

	--Generating and Calculating Values for Exclusions
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID
    FROM			 [adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions](@RunDate) a	 
	JOIN			
					(
						SELECT DISTINCT	o.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Frailty', '',  '','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) o
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Acute Inpatient', 'HEDIS_ACO_Advanced Illness',  'Dementia Medications','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) n
						ON				o.SUBSCRIBER_ID = n.SUBSCRIBER_ID
					)b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.AGE >=66
	AND				a.Gender = 'F'

	--Generating and Calculating Values for Exclusions 2
	--1
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Bilateral Mastectomy','','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective)
	UNION
	--2
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','Unilateral Mastectomy','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('','','HEDIS_ACO_Bilateral Modifier','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	UNION
	----3
	SELECT DISTINCT	a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Unilateral Mastectomy','',''
													,'',@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective) a
	JOIN			adw.Claims_Details b
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	GROUP BY		a.SUBSCRIBER_ID
	HAVING			COUNT(a.SEQ_CLAIM_ID) = 2
	
	UNION 
	--4
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_History of Bilateral Mastectomy','Hospice Intervention','Hospice encounter'
															,@PrimSvcDate_Start, @PrimSvcDate_End,@CodeSetEffective)
	UNION
	--5
	SELECT DISTINCT	c.SUBSCRIBER_ID
	FROM			(	SELECT DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID 
						FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('','Unilateral Mastectomy','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
						LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_Bilateral Modifier','HEDIS_ACO_Right Modifier','HEDIS_ACO_Left Modifier',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
						ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
						WHERE			b.SUBSCRIBER_ID IS NULL
					)c
	JOIN			(	SELECT	DISTINCT SUBSCRIBER_ID ,SEQ_CLAIM_ID
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_Unilateral Mastectomy Left','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) 
					)z
	ON				c.SUBSCRIBER_ID = c.SUBSCRIBER_ID
	UNION
	--6
	SELECT DISTINCT	c.SUBSCRIBER_ID
	FROM			(	SELECT a.SUBSCRIBER_ID ,a.SEQ_CLAIM_ID
						FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('','Unilateral Mastectomy','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) a
						LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_Bilateral Modifier','HEDIS_ACO_Right Modifier','HEDIS_ACO_Left Modifier',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) b
						ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
						WHERE			b.SUBSCRIBER_ID IS NULL
					)c
	JOIN			(	SELECT	SUBSCRIBER_ID 
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('','HEDIS_ACO_Unilateral Mastectomy Right','','',@PrimSvcDate_Start
										, @PrimSvcDate_End,@CodeSetEffective) 
					)z
	ON				c.SUBSCRIBER_ID = c.SUBSCRIBER_ID

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

	-- Generating Values to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('HEDIS_ACO_Mammography','','','',@PrimSvcDate_Start,@PrimSvcDate_End,@CodeSetEffective)

	-- Insert into Numerator Header 
	INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b

	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate,a.SEQ_CLAIM_ID,a.SVC_TO_DATE 
	FROM			@TmpTable1 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a 
	LEFT JOIN		@TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID is null 
		
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
EXEC [adw].[sp_2020_Calc_QM_ACE_HEDIS_ACO_BCS] '[adw].[QM_ResultByMember_History]','2020-05-15','2020-01-01',2020,16
***/

