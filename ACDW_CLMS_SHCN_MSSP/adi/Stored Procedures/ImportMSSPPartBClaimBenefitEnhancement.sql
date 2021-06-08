-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPartBClaimBenefitEnhancement]
    @SrcFileName varchar(100),
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100) ,
	--LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID [varchar](50) ,
	@LineNBR [varchar](50) ,
	@MedicareBeneficiaryID [varchar](50) ,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@PopulationBasedPaymentBenefitEnhancementFLG [varchar](10) NULL,
	@PostDischargeHomeVisitBenefitEnhancementFLG [varchar](10) NULL,
	@SNFThreeDayWaiverBenefitEnhancementFLG [varchar](10) NULL,
	@TelehealthBenefitEnhancementFLG [varchar](10) NULL,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG [varchar](10) NULL,
	@FirstProgramDemonstrationNBR [varchar](50) NULL,
	@SecondProgramDemonstrationNBR [varchar](50) NULL,
	@ThirdProgramDemonstrationNBR [varchar](50) NULL,
	@FourthProgramDemonstrationNBR [varchar](50) NULL,
	@FifthProgramDemonstrationNBR [varchar](50) NULL,
	@PopulationBasedPaymentInclusionAMT varchar(10),
	@PopulationBasedPaymentReductionAMT varchar(10),
	@PlaceHolderTXT [varchar](500) ,
	@FileNM varchar(50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	
--	DECLARE @DateFromFile DATE
--	SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPPartBClaimBenefitEnhancement]
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
	[PopulationBasedPaymentBenefitEnhancementFLG] ,
	[PostDischargeHomeVisitBenefitEnhancementFLG] ,
	[SNFThreeDayWaiverBenefitEnhancementFLG] ,
	[TelehealthBenefitEnhancementFLG] ,
	[AllInclusivePopulationBasedPaymentBenefitEnhancementFLG] ,
	[FirstProgramDemonstrationNBR] ,
	[SecondProgramDemonstrationNBR] ,
	[ThirdProgramDemonstrationNBR] ,
	[FourthProgramDemonstrationNBR] ,
	[FifthProgramDemonstrationNBR] ,
	[PopulationBasedPaymentInclusionAMT] ,
	[PopulationBasedPaymentReductionAMT] ,
	[PlaceHolderTXT] ,
	[FileNM] 

	)
		
 VALUES  (
     @SrcFileName ,
	  GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName,
	@LastUpdatedBy  ,
	GETDATE(),
	--LastUpdatedDate] [datetime] NULL,
    --@DateFromFile,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	@ClaimID ,
	@LineNBR  ,
	@MedicareBeneficiaryID  ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@PopulationBasedPaymentBenefitEnhancementFLG ,
	@PostDischargeHomeVisitBenefitEnhancementFLG ,
	@SNFThreeDayWaiverBenefitEnhancementFLG ,
	@TelehealthBenefitEnhancementFLG ,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG ,
	@FirstProgramDemonstrationNBR ,
	@SecondProgramDemonstrationNBR ,
	@ThirdProgramDemonstrationNBR ,
	@FourthProgramDemonstrationNBR ,
	@FifthProgramDemonstrationNBR ,
	CASE WHEN 	@PopulationBasedPaymentInclusionAMT= ''
	THEN NULL
	ELSE CONVERT(money, 	@PopulationBasedPaymentInclusionAMT)
	END, 
	CASE WHEN @PopulationBasedPaymentReductionAMT = ''
	THEN NULL
	ELSE CONVERT(money, @PopulationBasedPaymentReductionAMT)
	END, 
	@PlaceHolderTXT ,
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
