






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_ACO_MCC] 
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
		--DECLARE @qmdate date ='2020-11-30'								
	--  Declare Variables
	DECLARE @Metric				Varchar(20)			= 'ACE_ACO_MCC'
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
	DECLARE @MbrAceEffectiveDate	DATE		    = @MbrEffectiveDate
	

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable1a as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,CalcF INT,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(50),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(50),ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1a(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode)
	SELECT			DISTINCT z.SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
	FROM			(
	SELECT				MedicareBeneficiaryID,ClientMemberKey
						,MedicarePartABeneficiaryEnrollmentBeginDTS,CurrentAge
	 FROM				(/*•	Beneficiaries must also be enrolled full-time in both Medicare Part A and B during the year prior to the measurement period. */
							SELECT DISTINCT  MedicareBeneficiaryID,ClientMemberKey,[MedicarePartABeneficiaryEnrollmentBeginDTS], CurrentAge
											 , ROW_NUMBER()over(partition by MedicareBeneficiaryID order by datadate desc) RwCnt
							FROM			 [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPBeneficiaryDemographic] a
							JOIN			 (
												SELECT	ClientMemberKey, MbrYear,MbrMonth, Active, CurrentAge 
												FROM	adw.FctMembership 
												WHERE	RwEffectiveDate = (SELECT MAX(RwEffectiveDate) FROM adw.FctMembership)
												AND		Active = 1
											 ) b
							ON 				 a.MedicareBeneficiaryID = b.ClientMemberKey
							WHERE			 [MedicarePartABeneficiaryEnrollmentBeginDTS]  <> ''
							OR				 [MedicarePartABeneficiaryEnrollmentBeginDTS] IS NOT NULL
						)z					
	 WHERE				RwCnt = 1 
						)a
	 JOIN
						(
							SELECT				MedicareBeneficiaryID,ClientMemberKey
												, MedicarePartBBeneficiaryEnrollmentBeginDTS 
							FROM				(
													SELECT DISTINCT  MedicareBeneficiaryID,ClientMemberKey
																	 ,[MedicarePartBBeneficiaryEnrollmentBeginDTS]
																	 , ROW_NUMBER()over(partition by MedicareBeneficiaryID order by datadate desc) RwCnt
													FROM			 [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPBeneficiaryDemographic] a
													JOIN			 (
																		SELECT	ClientMemberKey, MbrYear,MbrMonth, Active 
																		FROM	adw.FctMembership 
																		WHERE	RwEffectiveDate = (SELECT MAX(RwEffectiveDate) FROM adw.FctMembership)
																		AND		Active = 1
																	 ) b
													ON 				 a.MedicareBeneficiaryID = b.ClientMemberKey
													WHERE			 [MedicarePartBBeneficiaryEnrollmentBeginDTS]  <> ''
													OR				 [MedicarePartBBeneficiaryEnrollmentBeginDTS] IS NOT NULL
												)z
							WHERE				RwCnt = 1 
						)b	
	 ON				a.ClientMemberKey = b.ClientMemberKey
	 JOIN			(	SELECT	SUBSCRIBER_ID, SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
								,ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID ORDER BY SEQ_CLAIM_ID) RwCnt--, COUNT(SEQ_CLAIM_ID)SEQ_CLAIM_ID,SUBSCRIBER_ID
						FROM	
						(	
							SELECT	DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
							FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('ACE_AC38_MCC_Cohort_AMI', 'ACE_AC38_MCC_Cohort_ALZ'
									, 'ACE_AC38_MCC_Cohort_AFIB', 'ACE_AC38_MCC_Cohort_CKD'
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) 
							UNION
							SELECT	DISTINCT e.SUBSCRIBER_ID,e.SEQ_CLAIM_ID,e.SVC_TO_DATE,e.PRIMARY_SVC_DATE,e.ValueCodeSystem,e.ValueCode
							FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('ACE_AC38_MCC_Cohort_COPD', ''
									, '', ''
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) e
							JOIN	[adw].[2020_tvf_Get_ClaimsByValueSet]('(ACE_AC38_MCC_Cohort_AST', ''
									, '', ''
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) f
							ON		e.SUBSCRIBER_ID = f.SUBSCRIBER_ID
							UNION
							SELECT	DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
							FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('ACE_AC38_MCC_Cohort_DPR', 'ACE_AC38_MCC_Cohort_HF'
									, 'ACE_AC38_MCC_Cohort_TIA', ''
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)
							UNION
							SELECT	DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
							FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('', ''
									, 'ACE_AC38_MCC_Cohort_TIA', ''
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)
							EXCEPT
							SELECT	DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
							FROM 	[adw].[2020_tvf_Get_ClaimsByValueSet]('ACE_AC38_MCC_Cohort_TIA_Ex', ''
									, '', ''
									, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)
							UNION
							SELECT	DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,'' ,ICD_PRIM_DIAG
							FROM	adw.Claims_Headers
							WHERE	ICD_PRIM_DIAG = 'Z51.89'
							AND		PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
						)dr
							WHERE	PRIMARY_SVC_DATE <> SVC_TO_DATE
							--GROUP BY SUBSCRIBER_ID
							--HAVING	 COUNT(SEQ_CLAIM_ID)>=2
					)z
	ON				b.ClientMemberKey=z.SUBSCRIBER_ID	
	WHERE			a.CurrentAge >65
	AND				z.RwCnt >=2
	AND				MedicarePartABeneficiaryEnrollmentBeginDTS BETWEEN  @StartDatePriorToMeasurementYear AND @PrimSvcDate_End
	AND				MedicarePartBBeneficiaryEnrollmentBeginDTS BETWEEN  @StartDatePriorToMeasurementYear AND @PrimSvcDate_End 
			
	--Inserting Values for DEN 
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID)
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID
	FROM			@TmpTable1a --select distinct SUBSCRIBER_ID,SEQ_CLAIM_ID from @TmpDenHeader order by SUBSCRIBER_ID,SEQ_CLAIM_ID

		   	 	 
	-- Clear out tmpTables to reuse
	--DELETE FROM		@TmpTable1
	--DELETE FROM		@TmpTable2

	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers

	--•	The outcome measured for each beneficiary is the number of acute unplanned admissions per 100 person-years at risk for admission. 
	--•	Persons are considered at risk for admission 
	--3.Outcome includes only unplanned admissions
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT			SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI--COUNT(RwCnt),
									--SEQ_CLAIM_ID
	FROM			(
	SELECT			SUBSCRIBER_ID, SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI
					,ROW_NUMBER()OVER(PARTITION BY SUBSCRIBER_ID, SVC_TO_DATE ORDER BY SVC_TO_DATE )RwCnt
	FROM			@TmpTable1a
					)g
	--CHANGE	--GROUP BY		SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,RwCnt	
				--HAVING			g.RwCnt = (365 / COUNT(RwCnt))
		
	--Generating Exclusions for NUMs
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.PRIMARY_SVC_DATE,a.ValueCodeSystem,a.ValueCode,a.SVC_PROV_NPI
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA1_CCS_Category'
					, '', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA2_CCS_Category'
					, '', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.PRIMARY_SVC_DATE <> b.SVC_TO_DATE
	UNION
	SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode,SVC_PROV_NPI
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA3_CCS_Category'
					, 'ACO PAA PA3_ICD-10-PCS', 'ACO PAA PA4_CCS_Category', 'ACO PAA PA4_ICD-10-CM'
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)
	WHERE			PRIMARY_SVC_DATE <> SVC_TO_DATE				
	--Inserting Values for NUM with Exclusion 
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI
	FROM			@TmpTable1
	EXCEPT
	SELECT			SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI
	FROM			@TmpTable2 
						
  -- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
	SELECT			DISTINCT a.SUBSCRIBER_ID 
	FROM			@TmpTable3 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b
								
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT			a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.ValueCodeSvcDate,a.ValueCodeSystem,a.ValueCode,a.SVC_PROV_NPI
	FROM		    @TmpTable3 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			DISTINCT a.SUBSCRIBER_ID 
	FROM			@TmpDenHeader a 
	LEFT JOIN		@TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID IS NULL 
		
	
	IF				@ConnectionStringProd = @ConnectionStringProd
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			DISTINCT @ClientKeyID,SUBSCRIBER_ID, @Metric , 'DEN' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			DISTINCT @ClientKeyID,SUBSCRIBER_ID, @Metric , 'NUM' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			DISTINCT @ClientKeyID,SUBSCRIBER_ID, @Metric , 'COP' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	/*INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE)
	SELECT			DISTINCT @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() ,SEQ_CLAIM_ID,SVC_TO_DATE
	FROM			@TmpDenHeader*/
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT			DISTINCT @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
					,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI
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
EXEC [adw].[sp_2020_Calc_QM_ACE_ACO_MCC]	 @ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
											 @QMDATE				= '2021-05-15',
											 @CodeEffectiveDate		= '2020-01-01',
											 @MeasurementYear		= 2021,
											 @ClientKeyID			= 16,
											 @MbrEffectiveDate		= '2021-04-01'
***/
