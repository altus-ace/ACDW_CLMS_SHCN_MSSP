






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_ACO_PQI_ASCAC] 
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
		--DECLARE @qmdate date ='2020-11-15'
	--  Declare Variables
	DECLARE @Metric				Varchar(20)			= 'ACE_ACO_PQI_ASCAC'
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
	

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE
			, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable1a as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE
			, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,CalcF INT,SEQ_CLAIM_ID VARCHAR(50)
			,SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50)
			,SVC_TO_DATE DATE,VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50)
			,SVC_TO_DATE DATE, VENDOR_ID VARCHAR(50),SVC_PROV_NPI VARCHAR(50))				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(50),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE
			,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT			DISTINCT a.ClientMemberKey
	FROM			(/*•	Beneficiary must be enrolled full-time in Part A during the measurement period, and enrolled full-time in both Part A and B during the year prior to the measurement period.*/
	SELECT			MedicareBeneficiaryID,ClientMemberKey,CurrentAge
					,MedicarePartABeneficiaryEnrollmentBeginDTS
	FROM			(
							SELECT DISTINCT  MedicareBeneficiaryID,ClientMemberKey,[MedicarePartABeneficiaryEnrollmentBeginDTS],CurrentAge
											 , ROW_NUMBER()over(partition by MedicareBeneficiaryID order by datadate desc) RwCnt
							FROM			 [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPBeneficiaryDemographic] z
							JOIN			 (
												SELECT	ClientMemberKey, MbrYear,MbrMonth, Active,CurrentAge 
												FROM	adw.FctMembership 
												WHERE	RwEffectiveDate = (SELECT MAX(RwEffectiveDate) FROM adw.FctMembership)
												AND		Active = 1
											 ) e
							ON 				 z.MedicareBeneficiaryID = e.ClientMemberKey
							WHERE			 [MedicarePartABeneficiaryEnrollmentBeginDTS]  <> ''
							OR				 [MedicarePartABeneficiaryEnrollmentBeginDTS] IS NOT NULL
						)z					
	WHERE				RwCnt = 1  --ORDER BY MedicarePartABeneficiaryEnrollmentBeginDTS DESC
	AND					MedicarePartABeneficiaryEnrollmentBeginDTS BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
				)a


	JOIN
				(
						SELECT		t.ClientMemberKey,MedicarePartABeneficiaryEnrollmentBeginDTS,MedicarePartBBeneficiaryEnrollmentBeginDTS
						FROM			(
											SELECT				MedicareBeneficiaryID,ClientMemberKey
																,MedicarePartABeneficiaryEnrollmentBeginDTS,CurrentAge
											FROM				
																(
																	SELECT DISTINCT MedicareBeneficiaryID,ClientMemberKey
																					,[MedicarePartABeneficiaryEnrollmentBeginDTS], CurrentAge
																					, ROW_NUMBER()OVER(PARTITION BY MedicareBeneficiaryID ORDER BY datadate DESC) RwCnt
																	FROM	[ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPBeneficiaryDemographic] c
											JOIN			 
																(
																	SELECT	ClientMemberKey, MbrYear,MbrMonth, Active, CurrentAge 
																	FROM	adw.FctMembership 
																	WHERE	RwEffectiveDate = (SELECT MAX(RwEffectiveDate) FROM adw.FctMembership)
																	AND		Active = 1
																) d
											ON 					c.MedicareBeneficiaryID = d.ClientMemberKey
											WHERE				[MedicarePartABeneficiaryEnrollmentBeginDTS]  <> ''
											OR					[MedicarePartABeneficiaryEnrollmentBeginDTS] IS NOT NULL
																)z					
						WHERE				RwCnt = 1 
										)t
						JOIN
										(
											SELECT				MedicareBeneficiaryID,ClientMemberKey
																, MedicarePartBBeneficiaryEnrollmentBeginDTS 
											FROM				(
																	SELECT DISTINCT  MedicareBeneficiaryID,ClientMemberKey
																					 ,[MedicarePartBBeneficiaryEnrollmentBeginDTS]
																					 , ROW_NUMBER()OVER(PARTITION BY MedicareBeneficiaryID ORDER BY datadate DESC) RwCnt
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
						ON				t.ClientMemberKey = b.ClientMemberKey
						AND				MedicarePartABeneficiaryEnrollmentBeginDTS BETWEEN  @StartDatePriorToMeasurementYear AND @PrimSvcDate_End
						AND				MedicarePartBBeneficiaryEnrollmentBeginDTS BETWEEN  @StartDatePriorToMeasurementYear AND @PrimSvcDate_End 
				)p
	ON			a.ClientMemberKey = p.ClientMemberKey
	WHERE		a.CurrentAge >18

		
	--Inserting Values for DEN 
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT	SUBSCRIBER_ID
	FROM			@TmpTable1
		   	 	 
	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	--DELETE FROM		@TmpTable2

		
	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers

	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT			SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode,SVC_PROV_NPI --COUNT(RwCnt), 
					/*DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode*/
	FROM			(	
	/*•	Number of discharges per 100 person years from an acute care hospital or critical access hospital with 
	a principal diagnosis of dehydration, bacterial pneumonia or urinary tract infection identified by (Table1_Bacterial_pneumonia) OR (Table1_Urinary_tract_infection) */
						SELECT			e.SUBSCRIBER_ID,e.SEQ_CLAIM_ID,e.SVC_TO_DATE,e.PRIMARY_SVC_DATE,e.ValueCodeSystem,e.ValueCode
										,ROW_NUMBER()OVER(PARTITION BY e.SUBSCRIBER_ID, e.SVC_TO_DATE ORDER BY e.SVC_TO_DATE )RwCnt
										,e.SVC_PROV_NPI
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Table1_Bacterial_pneumonia', 'Table1_Urinary_tract_infection', '', ''
										, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)e
						JOIN			
						(				--•	If the member has 2 or more claims with the same hospital and same discharge dates with different diagnosis codes from these value sets- COUNT as only ONE discharge
										SELECT			DISTINCT c.SUBSCRIBER_ID,c.SVC_TO_DATE,VENDOR_ID,'' x
										FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Table1_Bacterial_pneumonia', 'Table1_Urinary_tract_infection', '', ''
														,@PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
										JOIN			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@RunDate) b
										ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID	
										JOIN			adw.Claims_Headers c
										ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID			
										UNION			
											--•	If on the same claim you have two or more of the value set diagnosis codes, then count as ONE discharge
										SELECT			DISTINCT c.SUBSCRIBER_ID,'',c.ICD_PRIM_DIAG,''
										FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Table1_Bacterial_pneumonia', 'Table1_Urinary_tract_infection', '', ''
														,@PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a	
										JOIN			adw.Claims_Headers c
										ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID					
						)f
						ON				e.SUBSCRIBER_ID = f.SUBSCRIBER_ID
						WHERE			PRIMARY_SVC_DATE <> e.SVC_TO_DATE
					)g
					WHERE				PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
		--CHANGES		--GROUP BY		SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode,RwCnt	
						--HAVING			g.RwCnt = (365 / COUNT(RwCnt))
	
	--Generating Exclusions for NUMs
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode)
	SELECT DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Table2_Sickle_cell_anemia_or_HB-S disease'
					, 'Table2_Kidney/urinary_tract_disorder', 'Table2_Immunocompromised_state', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	WHERE			PRIMARY_SVC_DATE <> SVC_TO_DATE

	--Inserting Values for NUM with Exclusion 
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI
	FROM			@TmpTable1
	EXCEPT
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI
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
	SELECT			a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.ValueCodeSvcDate,a.ValueCodeSystem,a.ValueCode,SVC_PROV_NPI
	FROM		    @TmpTable3 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
		
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
	SELECT			DISTINCT @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() ,'',''
	FROM			@TmpDenHeader*/
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
					,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
	SELECT			DISTINCT @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() ,SEQ_CLAIM_ID
					,SVC_TO_DATE,SVC_PROV_NPI
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
EXEC [adw].[sp_2020_Calc_QM_ACE_ACO_PQI_ASCAC]	@ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
												@QMDATE				= '2021-05-15',
												@CodeEffectiveDate		= '2020-01-01',
												@MeasurementYear		= 2021,
												@ClientKeyID			= 16,
												@MbrEffectiveDate		= '2021-04-01'
***/
