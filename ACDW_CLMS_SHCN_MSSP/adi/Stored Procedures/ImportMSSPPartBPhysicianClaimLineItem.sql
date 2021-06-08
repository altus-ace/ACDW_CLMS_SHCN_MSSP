-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartBPhysicianClaimLineItem]
    @SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID [varchar](50) NULL,
	@LineNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS varchar(10),
	@RenderingProviderTypeCD [varchar](10) NULL,
	@RenderingProviderTypeDSC [varchar](500) NULL,
	@RenderingProviderFIPSStateCD [varchar](10) NULL,
	@ProviderSpecialtyCD [varchar](10) NULL,
	@ServiceTypeCD [varchar](10) NULL,
	@ServiceTypeDSC [varchar](500) NULL,
	@PlaceOfServiceCD [varchar](10) NULL,
	@PlaceOfServiceNM [varchar](50) NULL,
	@StartDTS varchar(10),
	@EndDTS varchar(10),
	@HCPCS [varchar](50) NULL,
	@PaymentAMT varchar(10),
	@PrimaryPayerCD [varchar](10) NULL,
	@PrimaryPayerDSC [varchar](500) NULL,
	@PrincipalICDDiagnosisCD [varchar](10) NULL,
	@ClaimTaxID [varchar](50) NULL,
	@RenderingProviderNPI [varchar](50) NULL,
	@CarrierPaymentDispositionCD [varchar](10) NULL,
	@CarrierPaymentDispositionDSC [varchar](500) NULL,
	@LineProcessingIndicatorCD [varchar](10) NULL,
	@LineProcessingIndicatorDSC [varchar](500) NULL,
	@AdjustmentTypeCD [varchar](10) NULL,
	@AdjustmentTypeDSC [varchar](500) NULL,
	@ProcessingDTS varchar(10),
	@RepositoryLoadDTS varchar(10),
	@ControlNBR [varchar](50) NULL,
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@AllowedAMT varchar(10),
	@AllowedUnitCNT varchar(5),
	@HCPCSModifier01CD [varchar](50) NULL,
	@HCPCSModifier02CD [varchar](50) NULL,
	@HCPCSModifier03CD [varchar](50) NULL,
	@HCPCSModifier04CD [varchar](50) NULL,
	@HCPCSModifier05CD [varchar](50) NULL,
	@ClaimDispositionCD [varchar](50) NULL,
	@ClaimDispositionDSC [varchar](500) NULL,
	@ClaimICDDiagnosis01CD [varchar](50) NULL,
	@ClaimICDDiagnosis02CD [varchar](50) NULL,
	@ClaimICDDiagnosis03CD [varchar](50) NULL,
	@ClaimICDDiagnosis04CD [varchar](50) NULL,
	@ClaimICDDiagnosis05CD [varchar](50) NULL,
	@ClaimICDDiagnosis06CD [varchar](50) NULL,
	@ClaimICDDiagnosis07CD [varchar](50) NULL,
	@ClaimICDDiagnosis08CD [varchar](50) NULL,
	@ICDRevisionCD varchar (50) NULL,
	@ClaimICDDiagnosis09CD [varchar](50) NULL,
	@ClaimICDDiagnosis10CD [varchar](50) NULL,
	@ClaimICDDiagnosis11CD [varchar](50) NULL,
	@ClaimICDDiagnosis12CD [varchar](50) NULL,
	@HCPCSBerensonEggersTypeOfServiceCD [varchar](50) NULL,
	@FileNM [varchar](50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
    IF (@ClaimID <> '')
	BEGIN
	INSERT INTO [adi].[Steward_MSSPPartBPhysicianClaimLineItem]
    (
	[SrcFileName]  ,
	[CreateDate] ,
	[CreateBy]  ,
	[OriginalFileName]  ,
	[LastUpdatedBy]  ,
	[LastUpdatedDate] ,
	[DataDate]  ,
	[ClaimID]  ,
	[LineNBR]  ,
	[MedicareBeneficiaryID]  ,
	[HealthInsuranceClaimNBR]  ,
	[ClaimTypeCD]  ,
	[ClaimTypeDSC]  ,
	[ClaimStartDTS]  ,
	[ClaimEndDTS]  ,
	[RenderingProviderTypeCD]  ,
	[RenderingProviderTypeDSC]  ,
	[RenderingProviderFIPSStateCD]  ,
	[ProviderSpecialtyCD]  ,
	[ServiceTypeCD]  ,
	[ServiceTypeDSC]  ,
	[PlaceOfServiceCD]  ,
	[PlaceOfServiceNM]  ,
	[StartDTS]  ,
	[EndDTS]  ,
	[HCPCS]  ,
	[PaymentAMT] ,
	[PrimaryPayerCD]  ,
	[PrimaryPayerDSC]  ,
	[PrincipalICDDiagnosisCD]  ,
	[ClaimTaxID]  ,
	[RenderingProviderNPI]  ,
	[CarrierPaymentDispositionCD]  ,
	[CarrierPaymentDispositionDSC]  ,
	[LineProcessingIndicatorCD]  ,
	[LineProcessingIndicatorDSC]  ,
	[AdjustmentTypeCD]  ,
	[AdjustmentTypeDSC]  ,
	[ProcessingDTS]  ,
	[RepositoryLoadDTS]  ,
	[ControlNBR]  ,
	[UmbrellaHealthInsuranceClaimNBR]  ,
	[AllowedAMT] ,
	[AllowedUnitCNT] ,
	[HCPCSModifier01CD]  ,
	[HCPCSModifier02CD]  ,
	[HCPCSModifier03CD]  ,
	[HCPCSModifier04CD]  ,
	[HCPCSModifier05CD]  ,
	[ClaimDispositionCD]  ,
	[ClaimDispositionDSC]  ,
	[ClaimICDDiagnosis01CD]  ,
	[ClaimICDDiagnosis02CD]  ,
	[ClaimICDDiagnosis03CD]  ,
	[ClaimICDDiagnosis04CD]  ,
	[ClaimICDDiagnosis05CD]  ,
	[ClaimICDDiagnosis06CD]  ,
	[ClaimICDDiagnosis07CD]  ,
	[ClaimICDDiagnosis08CD]  ,
	[ICDRevisionCD]  ,
	[ClaimICDDiagnosis09CD]  ,
	[ClaimICDDiagnosis10CD]  ,
	[ClaimICDDiagnosis11CD]  ,
	[ClaimICDDiagnosis12CD]  ,
	[HCPCSBerensonEggersTypeOfServiceCD]  ,
	[FileNM]  
	)
		
 VALUES  (
       @SrcFileName ,
	   GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	GETDATE(),
    --@DateFromFile,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate) 
	END,
	@ClaimID ,
	@LineNBR ,
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
	@RenderingProviderTypeCD ,
	@RenderingProviderTypeDSC ,
	@RenderingProviderFIPSStateCD ,
	@ProviderSpecialtyCD ,
	@ServiceTypeCD ,
	@ServiceTypeDSC ,
	@PlaceOfServiceCD ,
	@PlaceOfServiceNM , 
	CASE WHEN @StartDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@StartDTS,1, 10)) 
	END,
	CASE WHEN @EndDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@EndDTS ,1, 10)) 
	END,

	@HCPCS ,
	CASE WHEN @PaymentAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @PaymentAMT)
	END, 
	@PrimaryPayerCD ,
	@PrimaryPayerDSC ,
	@PrincipalICDDiagnosisCD ,
	@ClaimTaxID ,
	@RenderingProviderNPI ,
	@CarrierPaymentDispositionCD ,
	@CarrierPaymentDispositionDSC ,
	@LineProcessingIndicatorCD ,
	@LineProcessingIndicatorDSC ,
	@AdjustmentTypeCD ,
	@AdjustmentTypeDSC ,
	CASE WHEN @ProcessingDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ProcessingDTS,1, 10)) 
	END,
	CASE WHEN @RepositoryLoadDTS   = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@RepositoryLoadDTS  ,1, 10)) 
	END,

	@ControlNBR ,
	@UmbrellaHealthInsuranceClaimNBR ,
	CASE WHEN @AllowedAMT   = ''
	THEN NULL
	ELSE CONVERT(money, @AllowedAMT) 
	END,
--	CASE WHEN @AllowedUnitCNT = ''
--	THEN NULL
	--ELSE CONVERT(INT, @AllowedUnitCNT) 
	--END,
	@AllowedUnitCNT ,
	@HCPCSModifier01CD ,
	@HCPCSModifier02CD ,
	@HCPCSModifier03CD ,
	@HCPCSModifier04CD ,
	@HCPCSModifier05CD ,
	@ClaimDispositionCD ,
	@ClaimDispositionDSC ,
	@ClaimICDDiagnosis01CD ,
	@ClaimICDDiagnosis02CD ,
	@ClaimICDDiagnosis03CD ,
	@ClaimICDDiagnosis04CD ,
	@ClaimICDDiagnosis05CD ,
	@ClaimICDDiagnosis06CD ,
	@ClaimICDDiagnosis07CD ,
	@ClaimICDDiagnosis08CD ,
	@ICDRevisionCD ,
	@ClaimICDDiagnosis09CD ,
	@ClaimICDDiagnosis10CD ,
	@ClaimICDDiagnosis11CD ,
	@ClaimICDDiagnosis12CD ,
	@HCPCSBerensonEggersTypeOfServiceCD ,
	@FileNM 
   
)
   END


  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END
