-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaim]
    @SrcFileName [varchar](100) NULL,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate [date] NULL,
	@ClaimID [varchar](20) NULL,
	@CMSCertificationNBR [varchar](20) NULL,
	@MedicareBeneficiaryID [varchar](20) NULL,
	@HealthInsuranceClaimNBR [varchar](20) NULL,
	@ClaimTypeCD [varchar](20) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS VARCHAR(10),
	@BillFacilityTypeCD [varchar](20) NULL,
	@BillFacilityTypeDSC [varchar](500) NULL,
	@BillClassificationCD [varchar](20) NULL,
	@BillClassificationDSC [varchar](500) NULL,
	@PrincipalICDDiagnosisCD [varchar](20) NULL,
	@AdmitICDDiagnosisCD [varchar](20) NULL,
	@PaymentDenialReasonCD [varchar](20) NULL,
	@PaymentDenialReasonDSC [varchar](500) NULL,
	@PaymentAMT VARCHAR(10) ,
	@primaryPayerCD [varchar](20) NULL,
	@PrimaryPayerDSC [varchar](500) NULL,
	@FacilityFIPSStateCD [varchar](20) NULL,
	@DischargeStatusCD [varchar](20) NULL,
	@DischargeStatusDSC [varchar](500) NULL,
	@MSDRG [varchar](10) NULL,
	@OutpatientServiceTypeCD [varchar](20) NULL,
	@OutpatientServiceTypeDSC [varchar](500) NULL,
	@FacilityNPI [varchar](20) NULL,
	@OperatingProviderNPI [varchar](20) NULL,
	@AttendingProviderNPI [varchar](20) NULL,
	@OtherProviderNPI [varchar](20) NULL,
	@AdjustmentTypeCD [varchar](20) NULL,
	@AdjustmentTypeDSC [varchar](500) NULL,
	@ProcessingDTS varchar(10),
	@RepositoryLoadDTS varchar(10),
	@UmbrellaHealthInsuranceClaimNBR [varchar](20) NULL,
	@AdmitTypeCD [varchar](20) NULL,
	@AdmitTypeDSC [varchar](500) NULL,
	@AdmitSourceCD [varchar](20) NULL,
	@AdmitSourceDSC [varchar](500) NULL,
	@BillFrequencyCD [varchar](20) NULL,
	@BillFrequencyDSC [varchar](500) NULL,
	@PaymentQueryCD [varchar](20) NULL,
	@PaymentQueryDSC [varchar](20) NULL,
	@ICDRevisionCD [varchar](20) NULL,
	@PopulationBasedPaymentInclusionAMT varchar(10),
	@PopulationBasedPaymentReductionAMT varchar(10),
	@TotalChargeAMT varchar(10),
	@CapitalIndirectMedicalEducationAMT varchar(10),
	@OperationalIndirectMedicalEducationAMT varchar(10),
	@CapitalDisproportionateAMT varchar(10),
	@HIPPSUncompensatedAMT varchar(10),
	@OperationalDisproportionateAMT varchar(10),
	@FileNM varchar(100) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPPartAClaim]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate],
	[ClaimID] ,
	[CMSCertificationNBR] ,
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[ClaimTypeCD] ,
	[ClaimTypeDSC] ,
	[ClaimStartDTS] ,
	[ClaimEndDTS] ,
	[BillFacilityTypeCD] ,
	[BillFacilityTypeDSC] ,
	[BillClassificationCD] ,
	[BillClassificationDSC] ,
	[PrincipalICDDiagnosisCD] ,
	[AdmitICDDiagnosisCD] ,
	[PaymentDenialReasonCD] ,
	[PaymentDenialReasonDSC] ,
	[PaymentAMT] ,
	[PrimaryPayerCD] ,
	[PrimaryPayerDSC] ,
	[FacilityFIPSStateCD] ,
	[DischargeStatusCD] ,
	[DischargeStatusDSC] ,
	[MSDRG] ,
	[OutpatientServiceTypeCD] ,
	[OutpatientServiceTypeDSC] ,
	[FacilityNPI] ,
	[OperatingProviderNPI] ,
	[AttendingProviderNPI] ,
	[OtherProviderNPI] ,
	[AdjustmentTypeCD] ,
	[AdjustmentTypeDSC] ,
	[ProcessingDTS] ,
	[RepositoryLoadDTS] ,
	[UmbrellaHealthInsuranceClaimNBR] ,
	[AdmitTypeCD] ,
	[AdmitTypeDSC] ,
	[AdmitSourceCD] ,
	[AdmitSourceDSC] ,
	[BillFrequencyCD] ,
	[BillFrequencyDSC] ,
	[PaymentQueryCD] ,
	[PaymentQueryDSC] ,
	[ICDRevisionCD] ,
	[PopulationBasedPaymentInclusionAMT] ,
	[PopulationBasedPaymentReductionAMT] ,
	[TotalChargeAMT] ,
	[CapitalIndirectMedicalEducationAMT] ,
	[OperationalIndirectMedicalEducationAMT] ,
	[CapitalDisproportionateAMT] ,
	[HIPPSUncompensatedAMT] ,
	[OperationalDisproportionateAMT], 
	[FileNM] 
	)
		
 VALUES  (
   @SrcFileName ,
   GETDATE(),
	-- [CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
    CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,    
   -- @DateFromFile,
	
	@ClaimID ,
	@CMSCertificationNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	CASE WHEN @ClaimStartDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimStartDTS,1, 10)) 
	END,
	CASE WHEN @ClaimEndDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimEndDTS,1, 10)) 
	END,
	@BillFacilityTypeCD ,
	@BillFacilityTypeDSC ,
	@BillClassificationCD ,
	@BillClassificationDSC ,
	@PrincipalICDDiagnosisCD ,
	@AdmitICDDiagnosisCD ,
	@PaymentDenialReasonCD ,
	@PaymentDenialReasonDSC ,
	CASE WHEN @PaymentAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @PaymentAMT)
	END, 
	@primaryPayerCD ,
	@PrimaryPayerDSC ,
	@FacilityFIPSStateCD ,
	@DischargeStatusCD ,
	@DischargeStatusDSC ,
	@MSDRG ,
	@OutpatientServiceTypeCD ,
	@OutpatientServiceTypeDSC ,
	@FacilityNPI ,
	@OperatingProviderNPI ,
	@AttendingProviderNPI ,
	@OtherProviderNPI ,
	@AdjustmentTypeCD ,
	@AdjustmentTypeDSC ,
	CASE WHEN @ProcessingDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ProcessingDTS,1, 10)) 
	END,
	CASE WHEN @RepositoryLoadDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@RepositoryLoadDTS,1, 10)) 
	END,
	@UmbrellaHealthInsuranceClaimNBR ,
	@AdmitTypeCD ,
	@AdmitTypeDSC,
	@AdmitSourceCD ,
	@AdmitSourceDSC ,
	@BillFrequencyCD ,
	@BillFrequencyDSC ,
	@PaymentQueryCD ,
	@PaymentQueryDSC ,
	@ICDRevisionCD ,
	CASE WHEN 	@PopulationBasedPaymentInclusionAMT = ''
	THEN NULL
	ELSE CONVERT(money, @PopulationBasedPaymentInclusionAMT)
	END, 
	CASE WHEN @PopulationBasedPaymentReductionAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @PopulationBasedPaymentReductionAMT )
	END, 
	CASE WHEN @TotalChargeAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @TotalChargeAMT)
	END, 
	CASE WHEN @CapitalIndirectMedicalEducationAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @CapitalIndirectMedicalEducationAMT)
	END,  
	CASE WHEN @OperationalIndirectMedicalEducationAMT   = ''
	THEN NULL
	ELSE CONVERT(money, @OperationalIndirectMedicalEducationAMT )
	END, 
	CASE WHEN @CapitalDisproportionateAMT   = ''
	THEN NULL
	ELSE CONVERT(money, @CapitalDisproportionateAMT)
	END, 
	CASE WHEN @HIPPSUncompensatedAMT   = ''
	THEN NULL
	ELSE CONVERT(money, @HIPPSUncompensatedAMT)
	END, 
	CASE WHEN @OperationalDisproportionateAMT   = ''
	THEN NULL
	ELSE CONVERT(money, @OperationalDisproportionateAMT)
	END, 
	@FileNM 
            
)

  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END
