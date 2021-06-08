-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimBenefitEnhancement]
    @SrcFileName varchar(100),
	--[CreateDate [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID varchar(50) ,
	@MedicareBeneficiaryID varchar(10) ,
	@HealthInsuranceClaimNBR [varchar](50),
	@ClaimTypeCD [varchar](10) ,
	@ClaimAdmissionDTS varchar(10),
	@PopulationBasedPaymentBenefitEnhancementFLG varchar(10) ,
	@PostDischargeHomeVisitBenefitEnhancementFLG [varchar](10),
	@SNFThreeDayWaiverBenefitEnhancementFLG [varchar](10) ,
	@TelehealthBenefitEnhancementFLG [varchar](10) ,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG [varchar](10),
	@FirstProgramDemonstrationNBR [varchar](50) ,
	@SecondProgramDemonstrationNBR [varchar](50) ,
	@ThirdProgramDemonstrationNBR [varchar](50) ,
	@FourthProgramDemonstrationNBR [varchar](50) ,
	@FifthProgramDemonstrationNBR [varchar](50) ,
	@PopulationBasedPaymentInclusionAMT varchar(10),
	@PopulationBasedPaymentReductionAMT varchar(10) ,
	@PlaceHolderTXT [varchar](500) NULL,
	@FileNM [varchar](50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPPartAClaimBenefitEnhancement]
    (
	[SrcFileName],
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ClaimID] ,
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[ClaimTypeCD] ,
	[ClaimAdmissionDTS] ,
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
	[PlaceHolderTXT],
	[FileNM]

	)
		
 VALUES  (
    @SrcFileName ,
	GETDATE(),
	--[CreateDate [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
    CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	--@DateFromFile,  
	@ClaimID ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	CASE WHEN @ClaimAdmissionDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimAdmissionDTS,1, 10)) 
	END,

	@PopulationBasedPaymentBenefitEnhancementFLG  ,
	@PostDischargeHomeVisitBenefitEnhancementFLG ,
	@SNFThreeDayWaiverBenefitEnhancementFLG  ,
	@TelehealthBenefitEnhancementFLG ,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG ,
	@FirstProgramDemonstrationNBR ,
	@SecondProgramDemonstrationNBR ,
	@ThirdProgramDemonstrationNBR ,
	@FourthProgramDemonstrationNBR  ,
	@FifthProgramDemonstrationNBR ,
	CASE WHEN @PopulationBasedPaymentInclusionAMT= ''
	THEN NULL
	ELSE CONVERT(money, @PopulationBasedPaymentInclusionAMT)
	END, 
	CASE WHEN 	@PopulationBasedPaymentReductionAMT= ''
	THEN NULL
	ELSE CONVERT(money, 	@PopulationBasedPaymentReductionAMT)
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
