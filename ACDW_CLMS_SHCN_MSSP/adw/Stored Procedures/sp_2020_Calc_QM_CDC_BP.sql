﻿


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_CDC_BP] 
	-- Parameters for the stored procedure here
	@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
	--@ConnectionStringTest		Nvarchar(100) = '[adw].[QM_ResultByMember_TESTING]',
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
									--DECLARE @ClientKeyID			Varchar(2) = '6'
									--Declare @MeasurementYear		INT    = 2019
									--DECLARE @ClientKeyID			Varchar(2) = '6'
	-- Declare Variables
	DECLARE @Metric				Varchar(20)	   = 'CDC_BP'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   =Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   =Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   =Datefromparts(YEAR(@MeasurementYear), 12, 31)
	DECLARE @BeginDateOfClaims      Date	   = CONCAT('1/1/', @MeasurementYear)
	DECLARE @StartDateOfMeasurementYear Date   = CONCAT('12/31/', @MeasurementYear)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE)	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	-- TmpTable to Calculate Values for Headers and Details Denominator
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, '0', '0', '' FROM [adw].[2020_tvf_Get_ActiveMembers] (@StartDateOfMeasurementYear)a
	--Generating Claim Values for Denominator for Headers and Details
	JOIN			(
						SELECT DISTINCT 
						SUBSCRIBER_ID
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', @BeginDateOfClaims, @StartDateOfMeasurementYear, CONCAT('12/31/', @MeasurementYear))
					) b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			AGE BETWEEN 18 AND 75
	--Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID
    FROM            (
						SELECT A.*
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					)	A
    INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID,  PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					) B 
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
    GROUP BY		SUBSCRIBER_ID
    HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
	----Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT A.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) B
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT SUBSCRIBER_ID
    FROM            [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear));  
    	-- Insert into Denominator Header using TmpTable	
    INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpTable1 a
    JOIN			@TmpTable2 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	
	---------Calculating claims for DEN Values Details
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM            (
						SELECT A.*
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', concat('1/1/', @year - 1), concat('12/31/', @year), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', concat('1/1/', @year - 1), concat('12/31/', @year), CONCAT('12/31/', @MeasurementYear))
					)	A
    INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID,  PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', concat('1/1/', @year - 1), concat('12/31/', @year), CONCAT('12/31/', @MeasurementYear))
					) B 
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
    GROUP BY		SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
	----Calculating Claims for Den Values for Details
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT A.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) B
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM            [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear));          
    	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate
    FROM			@TmpTable1 a
    JOIN			@TmpTable3 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	---- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1;
    DELETE FROM		@TmpTable2;
	DELETE FROM		@TmpTable3;
	--------------------------------------
	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
    SELECT DISTINCT SUBSCRIBER_ID
    FROM               --readings that are compliant
					(       
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80–89', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
						INTERSECT
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					)	Firsts
    JOIN
					(
						--Most recent bp reading
						SELECT DISTINCT SEQ_CLAIM_ID
						FROM
					(
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, DENSE_RANK() OVER(PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE DESC) AS Ranks
						FROM
                    (
                        SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
                        FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80–89'
										, 'Diastolic Greater Than/Equal To 90','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
                        UNION
                        SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
                        FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', 'Systolic Greater Than/Equal To 140', '',''
										, CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
                    ) b
					) c
						WHERE			c.Ranks = 1
					) Seconds
	ON				Firsts.SEQ_CLAIM_ID = Seconds.SEQ_CLAIM_ID
					--has to be outpatient or nonacute 
    JOIN
					(
						SELECT DISTINCT SEQ_CLAIM_ID
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'Nonacute Inpatient', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					) Thirds 
	ON				Firsts.SEQ_CLAIM_ID = thirds.SEQ_CLAIM_ID;
	 -- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader
	SELECT			a.SUBSCRIBER_ID 
	FROM			@TmpTable1 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b
    -- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			a.SUBSCRIBER_ID 
	FROM			@TmpDenHeader a 
	LEFT JOIN		@TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID IS NULL 
    	--TmpTable to Generate Numerator Values for Details
    INSERT INTO		@TmpTable2(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT SUBSCRIBER_ID, Seconds.ValueCodeSystem, Seconds.ValueCode, Seconds.ValueCodeSvcDate
    FROM               --readings that are compliant
					(       
						SELECT DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80–89', '',''
						, CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))a
						JOIN
						[adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))b
						ON	a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
					)	Firsts
    JOIN
					(
						--Most recent bp reading
						SELECT DISTINCT SEQ_CLAIM_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM
					(
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						, DENSE_RANK() OVER(PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE DESC) AS Ranks
						FROM
                    (
                        SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
                        FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80–89'
										, 'Diastolic Greater Than/Equal To 90','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
                        UNION
                        SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
                        FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', 'Systolic Greater Than/Equal To 140', '',''
										, CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
                    ) b
					) c
						WHERE			c.Ranks = 1
					) Seconds
	ON				Firsts.SEQ_CLAIM_ID = Seconds.SEQ_CLAIM_ID
					--has to be outpatient or nonacute 
    JOIN
					(
						SELECT DISTINCT SEQ_CLAIM_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'Nonacute Inpatient', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					) Thirds 
	ON				Firsts.SEQ_CLAIM_ID = thirds.SEQ_CLAIM_ID;
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate
	FROM		    @TmpTable2 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
		

	IF				@ConnectionStringProd = @ConnectionStringProd
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			@TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
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
EXEC [adw].[sp_2020_Calc_QM_CDC_BP] '[adw].[QM_ResultByMember_HISTORY]',2019,16
***/
