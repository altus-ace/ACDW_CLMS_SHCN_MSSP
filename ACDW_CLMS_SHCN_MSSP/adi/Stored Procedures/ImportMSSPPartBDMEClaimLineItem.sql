-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartBDMEClaimLineItem]
    @SrcFileName [varchar](100) NULL,
--	[CreateDate] [datetime] NULL,
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
	@PaidProviderNPI [varchar](50) NULL,
	@OrderingProviderNPI [varchar](50) NULL,
	@CarrierPaymentDispositionCD [varchar](10) NULL,
	@CarrierPaymentDispositionDSC [varchar](500) NULL,
	@LineProcessingIndicatorCD [varchar](10) NULL,
	@LineProcessingIndicatorDSC [varchar](500) NULL,
	@AdjustmentTypeCD [varchar](10) NULL,
	@AdjustmentTypeDSC [varchar](50) NULL,
	@ProcessingDTS varchar(10),
	@RepositoryLoadDTS varchar(10),
	@ControlNBR [varchar](50) NULL,
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@AllowedAMT varchar(10),
	@ClaimDispositionCD [varchar](10) NULL,
	@ClaimDispositionDSC [varchar](500) NULL,
	@FileNM [varchar](50) NULL
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPPartBDMEClaimLineItem]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ClaimID] ,
	[LineNBR] ,
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[ClaimTypeCD] ,
	[ClaimTypeDSC] ,
	[ClaimStartDTS] ,
	[ClaimEndDTS] ,
	[ServiceTypeCD] ,
	[ServiceTypeDSC] ,
	[PlaceOfServiceCD] ,
	[PlaceOfServiceNM] ,
	[StartDTS] ,
	[EndDTS] ,
	[HCPCS] ,
	[PaymentAMT] ,
	[PrimaryPayerCD] ,
	[PrimaryPayerDSC] ,
	[PaidProviderNPI] ,
	[OrderingProviderNPI] ,
	[CarrierPaymentDispositionCD] ,
	[CarrierPaymentDispositionDSC] ,
	[LineProcessingIndicatorCD] ,
	[LineProcessingIndicatorDSC] ,
	[AdjustmentTypeCD] ,
	[AdjustmentTypeDSC] ,
	[ProcessingDTS] ,
	[RepositoryLoadDTS] ,
	[ControlNBR] ,
	[UmbrellaHealthInsuranceClaimNBR] ,
	[AllowedAMT] ,
	[ClaimDispositionCD] ,
	[ClaimDispositionDSC] ,
	[FileNM] 
	)
		
 VALUES  (
   
    @SrcFileName ,
    GETDATE(),
--	[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	GETDATE(),
    CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	--@DateFromFile,
	@ClaimID ,
	@LineNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	CASE WHEN @ClaimStartDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimStartDTS ,1, 10)) 
	END,
	CASE WHEN @ClaimEndDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimEndDTS ,1, 10)) 
	END,
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
	@PaidProviderNPI ,
	@OrderingProviderNPI ,
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
	CASE WHEN @RepositoryLoadDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@RepositoryLoadDTS ,1, 10)) 
	END,
	 
	@ControlNBR ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@AllowedAMT ,
	@ClaimDispositionCD ,
	@ClaimDispositionDSC ,
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
