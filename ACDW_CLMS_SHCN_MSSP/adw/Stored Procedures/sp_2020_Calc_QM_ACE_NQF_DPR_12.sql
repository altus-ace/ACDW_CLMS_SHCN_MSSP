

CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ACE_NQF_DPR_12]  
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
		DECLARE @Metric					Varchar(20)		= 'ACE_NQF_DPR12'
		DECLARE @RunDate				Date			= @QMDATE 
		DECLARE @RunTime				Datetime		= Getdate()
		DECLARE @Today					Date			= Getdate()
		DECLARE @TodayMth				Int				= Month(Getdate())
		DECLARE @TodayDay				Int				= Day(Getdate())
		DECLARE @Year					INT				=Year(Getdate())
		DECLARE @Month					int				= MONTH(GETDATE())
		DECLARE @day					int				= DAY(GETDATE())
		DECLARE @FrstDY					INT				= 1
		DECLARE @FrsDM					INT				= 1
		DECLARE @PrimSvcDate_Start		VarChar(20)		= CONCAT('01/1/',@MeasurementYear)
		DECLARE @PrimSvcDate_End		Varchar(20)		=CONCAT('12/31/',@MeasurementYear)
		DECLARE @CodeSetEffDate			Varchar(20)		= @CodeEffectiveDate
		DECLARE @MbrAceEffectiveDate	DATE		    = @MbrEffectiveDate
		
		DECLARE @Table1 as Table (SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50)) 
		DECLARE @Table2 as Table (SUBSCRIBER_ID Varchar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))				
		DECLARE @Tableden as Table (SUBSCRIBER_ID Varchar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE)					
		DECLARE @Tablenumt as Table (SUBSCRIBER_ID Varchar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))					
		DECLARE @Tablenum as Table (SUBSCRIBER_ID Varchar(20),SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))				
		DECLARE @Tablecareop as Table (SUBSCRIBER_ID Varchar(20))
		DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(50),SVC_TO_DATE DATE,SVC_PROV_NPI VARCHAR(50))
		
		
		INSERT INTO @Table1(SUBSCRIBER_ID)
		SELECT	DISTINCT a.SUBSCRIBER_ID 
		FROM	adw.[2020_tvf_Get_ActiveMembers_WithQMExclusions](@MbrAceEffectiveDate) a
		JOIN	[adw].[2020_tvf_Get_ClaimsByValueSet]('Major Depression and Dysthymia', '','','', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffDate) b 
		ON		a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		WHERE	AGE >=12
				
		--Generating and Calculating Values for Exclusions
		INSERT INTO		@Table2(SUBSCRIBER_ID)
		SELECT DISTINCT a.Subscriber_ID
		FROM			adw.[2020_tvf_Get_ClaimsByValueSet]('Hospice Intervention','Hospice encounter','','',@MeasurementYear,@PrimSvcDate_End,@CodesetEffDate)a
		
			--Inserting Values for DEN with Exclusion
		INSERT INTO		@Tableden(SUBSCRIBER_ID)
		SELECT DISTINCT	SUBSCRIBER_ID
		FROM			@Table1
		EXCEPT
		SELECT			SUBSCRIBER_ID
		FROM			@Table2

		-- Clear out tmpTables to reuse
		DELETE FROM		@Table1
		DELETE FROM		@Table2
		
		
		--TmpTable to store Numerator Values
		INSERT INTO		 @Table1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI) 
		SELECT DISTINCT  A.SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI
		FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('ACO_DepressionScreening', '','','', @PrimSvcDate_Start, @PrimSvcDate_End, @CodeSetEffDate) a 

		-- Insert into Numerator Header 
		INSERT INTO		@Tablenum(SUBSCRIBER_ID)
		SELECT			a.SUBSCRIBER_ID 
		FROM			@Table1 a 
		INTERSECT    
		SELECT			b.SUBSCRIBER_ID 
		FROM			@Tableden  b
		
						
		---- Insert into Numerator Detail using TmpTable
		INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
		SELECT			a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate, a.SEQ_CLAIM_ID, a.SVC_TO_DATE,a.SVC_PROV_NPI
		FROM			@Table1 a 
		
		
		-- Insert into CareOpp Header
		INSERT INTO		@Tablecareop
		SELECT			a.SUBSCRIBER_ID
		FROM			@Tableden a 
		LEFT JOIN		@Tablenum b 
		ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
		WHERE			b.SUBSCRIBER_ID is null 
		
		IF				@ConnectionStringProd = @ConnectionStringProd
		BEGIN
		---Insert into Target Table, Inserting Population as DEN at Header Level
		INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
		SELECT			@ClientKeyID,SUBSCRIBER_ID, @Metric , 'DEN' ,@QMDATE ,@RUNTIME , SUSER_NAME() 
		FROM			@Tableden
		
		---Insert into Target Table, Inserting Members with Numerator at Header Level
		INSERT INTO	    [adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
		SELECT		    @ClientKeyID,SUBSCRIBER_ID, @Metric , 'NUM' ,@QMDATE,@RUNTIME , SUSER_NAME() 
		FROM			@Tablenum
		
		--Insert into Target Table, Inserting Members with CAREOPPS at Header Level
		INSERT INTO		[adw].[QM_ResultByMember_History]([ClientKey],[ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
		SELECT			@ClientKeyID,*, @Metric , 'COP' ,@QMDATE ,@RUNTIME, SUSER_NAME() 
		FROM			@Tablecareop
		
		
		---Insert into Target Table, Inserting Members with Numerator at Detail Level
		INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
						[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
						,SEQ_CLAIM_ID,SVC_TO_DATE,SVC_PROV_NPI)
		SELECT			@ClientKeyID, SUBSCRIBER_ID, ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@QMDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME(),SEQ_CLAIM_ID
						,SVC_TO_DATE ,SVC_PROV_NPI
		FROM			@TmpNumDetail
		
		---Insert into Target Table, Inserting Members with Denominator at Detail Level
		/*INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
						[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode],[ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy]
						,SEQ_CLAIM_ID,SVC_TO_DATE)
		SELECT			@ClientKeyID, SUBSCRIBER_ID,	'0','0','1900-01-01', @Metric ,'DEN',@QMDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME(),'',''
		FROM			@Tableden*/
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
		EXEC [adw].[sp_2020_Calc_QM_ACE_NQF_DPR_12] @ConnectionStringProd	= '[adw].[QM_ResultByMember_History]',
													@QMDATE					= '2021-05-15',
													@CodeEffectiveDate		= '2020-01-01',
													@MeasurementYear		= 2021,
													@ClientKeyID			= 16,
													@MbrEffectiveDate		= '2021-04-01'
		***/
		
		
		

		
	