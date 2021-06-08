






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_ACO_ACR] 
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
	DECLARE @Metric				Varchar(20)			= 'ACE_ACO_ACR'
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
	DECLARE @MbrAceEffectiveDate	DATE			= @MbrEffectiveDate
	

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,CalcF INT,SEQ_CLAIM_ID VARCHAR(50)
									,SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50)
									,SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,MaxDate DATE,SEQ_CLAIM_ID VARCHAR(50)
									,SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(50),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(50), ValueCodeSystem Varchar(50), ValueCode Varchar(50), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
	
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID)
	SELECT			DISTINCT COH.SUBSCRIBER_ID,coh.SEQ_CLAIM_ID
	FROM			(
						SELECT DISTINCT a.SUBSCRIBER_ID
						FROM			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate) a
						JOIN			adw.Claims_Details cdt
						ON				a.SUBSCRIBER_ID=cdt.SUBSCRIBER_ID
						WHERE			a.AGE >=65
						AND				PLACE_OF_SVC_CODE1 <> 26
					)mbr

	JOIN			(	SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACE_ACO8_ACR_Cohort CCS_PCS', 'ACE_ACO8_ACR_Cohort CCS_CM'
										,'ACE_ACO8_ACR_Cohort_ICD-10-PCS','', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) b
					)coh
	ON				mbr.SUBSCRIBER_ID = coh.SUBSCRIBER_ID
	
	JOIN			(	SELECT DISTINCT c.ClientMemberKey,c.SEQ_CLAIM_ID
						FROM  (
								SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID
								FROM			adw.Claims_Headers ch
								WHERE			DISCHARGE_DISPO =20
							    UNION
								SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID
								FROM			adw.Claims_Headers ch
								WHERE			DISCHARGE_DISPO <> 2 
							  )t
						JOIN		
							  ( SELECT			DISTINCT ClientMemberKey, '' SEQ_CLAIM_ID--,MedicarePartABeneficiaryEnrollmentBeginDTS,PRIMARY_SVC_DATE
										---, DATEDIFF(MM,[MedicarePartABeneficiaryEnrollmentBeginDTS],PRIMARY_SVC_DATE)CalcFd 
								FROM		(
								SELECT		ClientMemberKey--MedicareBeneficiaryID,
														--,MedicarePartABeneficiaryEnrollmentBeginDTS
								FROM		(
												SELECT DISTINCT  MedicareBeneficiaryID,ClientMemberKey,[MedicarePartABeneficiaryEnrollmentBeginDTS]
																, ROW_NUMBER()OVER(PARTITION BY MedicareBeneficiaryID ORDER BY datadate DESC) RwCnt
												FROM			 [ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPBeneficiaryDemographic] a
												JOIN			 
																(
																SELECT	ClientMemberKey, MbrYear,MbrMonth, Active 
																FROM	adw.FctMembership 
																WHERE	RwEffectiveDate = (SELECT MAX(RwEffectiveDate) FROM adw.FctMembership)
																AND		Active = 1
																) b
												ON 				 a.MedicareBeneficiaryID = b.ClientMemberKey
												WHERE			 [MedicarePartABeneficiaryEnrollmentBeginDTS]  <> ''
											)z					
								WHERE		  RwCnt = 1
								AND			  MedicarePartABeneficiaryEnrollmentBeginDTS BETWEEN @StartDatePriorToMeasurementYear AND @PrimSvcDate_End
									      )a
							  )c
						ON	  t.SUBSCRIBER_ID = c.ClientMemberKey		  
						JOIN			
									 (
									 	SELECT DISTINCT MAX(PRIMARY_SVC_DATE) PRIMARY_SVC_DATE, SUBSCRIBER_ID
									 	FROM		 adw.Claims_Headers
									 	WHERE		 PRIMARY_SVC_DATE between @StartDatePriorToMeasurementYear AND @PrimSvcDate_End
									 	GROUP BY	 SUBSCRIBER_ID
									 )b
	ON              c.ClientMemberKey = b.SUBSCRIBER_ID
					)dis
	ON				mbr.SUBSCRIBER_ID = dis.ClientMemberKey 
								
	JOIN			(	--If the Discharge date/service thru date is the same as the Admit/Prim_SVC date on another claim with the same primary diagnosis, then it is considered as one admission.
						SELECT DISTINCT  SUBSCRIBER_ID,ICD_PRIM_DIAG,SVC_TO_DATE,PRIMARY_SVC_DATE,''x
										,ROW_NUMBER()OVER(PARTITION BY SUBSCRIBER_ID, ICD_PRIM_DIAG,SVC_TO_DATE,PRIMARY_SVC_DATE
														  ORDER BY SUBSCRIBER_ID,ICD_PRIM_DIAG,SVC_TO_DATE,PRIMARY_SVC_DATE) RwCnt
						FROM			 adw.Claims_Headers
						UNION --	If a patient is readmitted to the same VendorName(facility) on the same day of discharge (DischargeDate/ServiceThruDate) for the same diagnosis (ICD_PRIMDiag), consider as one admission.
						SELECT DISTINCT SUBSCRIBER_ID,ICD_PRIM_DIAG,SVC_TO_DATE,PRIMARY_SVC_DATE,VENDOR_ID
										,ROW_NUMBER()OVER(PARTITION BY SUBSCRIBER_ID, VENDOR_ID,ICD_PRIM_DIAG,PRIMARY_SVC_DATE
														  ORDER BY SUBSCRIBER_ID,VENDOR_ID,ICD_PRIM_DIAG,PRIMARY_SVC_DATE) RwCnt
						FROM			adw.Claims_Headers 
						--ORDER BY SUBSCRIBER_ID,VENDOR_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ICD_PRIM_DIAG
					) rig
	ON				mbr.SUBSCRIBER_ID = rig.SUBSCRIBER_ID
	WHERE			RwCnt = 1
	AND			    PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
	AND				PRIMARY_SVC_DATE <> SVC_TO_DATE
		
	/*
	Exclude Member If there is no other IP claim within 30 days of discharge date in non-Federal, short-stay acute-care or critical access hospitals
	members who do not receive another ip claim within 30days from the first should be excluded
	So members that receive another claim within 30days shud be included. ie if Datediff is over 30days, then Exclude
	*/
	--Generating and Calculating Values for Exclusions 
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID)
	SELECT			 DISTINCT e.SUBSCRIBER_ID,SEQ_CLAIM_ID--,CalcF
	FROM			 (
	SELECT			 DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID--, DATEDIFF(DD,DischargeDate,AdmissionDate)CalcF
					 --,PRIMARY_SVC_DATE,SVC_TO_DATE
	FROM			 (
						SELECT		SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE,SVC_TO_DATE 
									,LAG(SVC_TO_DATE) OVER (PARTITION BY SUBSCRIBER_ID ORDER BY SVC_TO_DATE ) DischargeDate
									,LEAD(PRIMARY_SVC_DATE) OVER (PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE) AdmissionDate
						FROM		adw.Claims_Headers
						WHERE		PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
					 )z
	WHERE			 DATEDIFF(DD,DischargeDate,AdmissionDate) >30 
	AND				 PRIMARY_SVC_DATE <> SVC_TO_DATE
					 ) e
	JOIN			(	SELECT		SUBSCRIBER_ID ,AGE
						FROM		[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate) 
					)b
	ON				e.Subscriber_id = b.SUBSCRIBER_ID
	UNION
	/*Admissions for patients lacking a complete enrollment history for the 12 months prior to admission-- 
	Lacking Enrollment history- so if they aren’t are members 12 month prior to the admission date*/
	SELECT			DISTINCT ClientMemberKey,''--,0
	FROM			(
	SELECT			ClientMemberKey,MinRwEffectiveDate,MaxRwEffectiveDate,MinPRIMARY_SVC_DATE,MaxPRIMARY_SVC_DATE,
					DATEDIFF(MM,MINRWEFFECTIVEDATE,MAXPRIMARY_SVC_DATE)Calc 
	FROM			(
	SELECT			DISTINCT ClientMemberKey, MIN(a.RwEffectiveDate)MinRwEffectiveDate, MAX(a.RwEffectiveDate)MaxRwEffectiveDate
					, MIN(PRIMARY_SVC_DATE)MinPRIMARY_SVC_DATE, MAX(PRIMARY_SVC_DATE)MaxPRIMARY_SVC_DATE
	FROM			adw.vw_Dashboard_Membership a
	JOIN			adw.Claims_Headers b
	ON				a.ClientMemberKey = b.SUBSCRIBER_ID
	JOIN			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@RunDate) e
	ON				a.ClientMemberKey = e.SUBSCRIBER_ID
	WHERE			PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End
	AND				PRIMARY_SVC_DATE <> b.SVC_TO_DATE
	GROUP BY		ClientMemberKey
					)A 
					)z
	--Uncomment and get more result set			
	WHERE			Calc >12

	UNION
	--OR Admissions for patients discharged against medical advice (AMA) Discharge Disposition = 7
	--OR Admissions for patients to a PPS-exempt cancer hospital Discharge Disposition = 5
	--OR Admissions for rehabilitation care Discharge Disposition = 62
	SELECT			DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID--,''--PRIMARY_SVC_DATE,SVC_TO_DATE
	FROM			adw.Claims_Headers a
	JOIN			[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate) b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			DISCHARGE_DISPO IN (7,5,62)
		
	
	--Inserting Values for DEN with Exclusion
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID)
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID
	FROM			@TmpTable1
	EXCEPT
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID
	FROM			@TmpTable2
	   	 	
	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2


	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers --Changes applied here
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode,SVC_PROV_NPI)
	/*Include only All-cause unplanned readmission within 30 days of discharge date of a first admission*/
	SELECT			 e.SUBSCRIBER_ID,e.SEQ_CLAIM_ID,e.SVC_TO_DATE,e.PRIMARY_SVC_DATE,'' x,ICD_PRIM_DIAG,SVC_PROV_NPI
	FROM			 (
	SELECT			 DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ICD_PRIM_DIAG
					 ,DATEDIFF(DD,DischargeDate,AdmissionDate)CalcF,SVC_PROV_NPI
	FROM			 (
						SELECT		SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE,SVC_TO_DATE,ICD_PRIM_DIAG 
									,LAG(SVC_TO_DATE) OVER (PARTITION BY SUBSCRIBER_ID ORDER BY SVC_TO_DATE ) DischargeDate
									,LEAD(PRIMARY_SVC_DATE) OVER (PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE) AdmissionDate
									,SVC_PROV_NPI
						FROM		adw.Claims_Headers
						WHERE		SVC_TO_DATE <> '1900-01-01'
						AND			DISCHARGE_DISPO <> 26 
						AND			CLAIM_TYPE IN ('71','60','72')
						AND			PRIMARY_SVC_DATE BETWEEN @PrimSvcDate_Start AND @PrimSvcDate_End --CHANGE
						AND			PRIMARY_SVC_DATE <> SVC_TO_DATE
					 )z
	WHERE			 DATEDIFF(DD,DischargeDate,AdmissionDate) <=30 
					 ) e
	JOIN			(	SELECT		SUBSCRIBER_ID ,AGE
						FROM		[adw].[2020_tvf_Get_ActiveMembers_WithQMExclusions] (@MbrAceEffectiveDate) 
					)b
	ON				e.Subscriber_id = b.SUBSCRIBER_ID
	
	--Generating Exclusions for NUMs
	/**1.A procedure is performed that is in one of the procedure categories that are always planned regardless of diagnosis (ACO PAA PA1_CCS_Category) value set
		OR 2.	The principal diagnosis is in one of the diagnosis categories that are always planned (ACO PAA PA2_CCS_Category) value set
	*/
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode)
	SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,PRIMARY_SVC_DATE,ValueCodeSystem,ValueCode
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA1_CCS_Category', 'ACO PAA PA2_CCS_Category', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	WHERE			PRIMARY_SVC_DATE <> SVC_TO_DATE
	UNION
	/* OR 3.	A procedure is performed that is in one of the potentially planned procedure categories (or partial categories) (ACO PAA PA3_CCS_Category) OR (ACO PAA PA3_ICD-10-PCS) value sets
	AND the principal/primary diagnosis is not in the list of acute discharge diagnoses (ACO PAA PA4_CCS_Category) OR (ACO PAA PA4_ICD-10-CM) value sets*/
	SELECT DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.SVC_TO_DATE,a.ValueCodeSvcDate,a.ValueCodeSystem,a.ValueCode
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA3_CCS_Category', 'ACO PAA PA3_ICD-10-PCS', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('ACO PAA PA4_CCS_Category', 'ACO PAA PA4_ICD-10-CM', '', ''
					, @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffective)	b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			a.PRIMARY_SVC_DATE <> a.SVC_TO_DATE

	--Inserting Values for NUM with Exclusion 
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode)
	SELECT DISTINCT	SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode
	FROM			@TmpTable1
	EXCEPT
	SELECT			SUBSCRIBER_ID,SEQ_CLAIM_ID,SVC_TO_DATE,ValueCodeSvcDate,ValueCodeSystem,ValueCode
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
	EXEC [adw].[sp_2020_Calc_QM_ACE_ACO_ACR] @ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
											 @QMDATE				= '2021-05-15',
											 @CodeEffectiveDate		= '2021-01-01',
											 @MeasurementYear		= 2021,
											 @ClientKeyID			= 16,
											 @MbrEffectiveDate		= '2021-04-01'
***/