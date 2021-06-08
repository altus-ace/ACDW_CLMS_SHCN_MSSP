-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportSteward_MSSPQtrExclusionsBNEX]
    @SrcFileName [varchar](100) NULL,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),

	@CurrentMBI [varchar](50) NULL,
	@YearNBR [varchar](50) NULL,
	@QuarterNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@FirstNM [varchar](50) NULL,
	@LastNM [varchar](50) NULL,
	@SexCD [varchar](5) NULL,
	@BirthDTS  VARCHar(10) NULL,
	@DeathDTS VARCHAR(10) NULL,
	@CountyNM [varchar](50) NULL,
	@HomeStateCD [varchar](50) NULL,
	@CountyNBR [varchar](50) NULL,
	@VoluntaryAlignmentFLG [varchar](10) NULL,
	@VoluntaryAlignmentTIN [varchar](50) NULL,
	@VoluntaryAlignmentNPI [varchar](50) NULL,
	@ClaimsBasedAssignmentFLG [varchar](10) NULL,
	@AssignmentStepCD [varchar](50) NULL,
	@NewlyAssignedBeneficiaryFLG [varchar](10) NULL,
	@PartDMonthsEnrolledNBR [varchar](50) NULL,
	@ExcludedFLG [varchar](10) NULL,
	@DeceasedExcludedFLG [varchar](10) NULL,
	@MissingIDExcludedFLG [varchar](10) NULL,
	@PartAandBOnlyExcludeFLG [varchar](10) NULL,
	@EmployerGroupHealthPlanExcludedFLG [varchar](10) NULL,
	@OutsideUSExcludedFLG [varchar](10) NULL,
	@OtherSharedSavingsInitiativesFLG [varchar](50) NULL,
	@MonthlyEligibility01CD [varchar](50) NULL,
	@MonthlyEligibility02CD [varchar](50) NULL,
	@MonthlyEligibility03CD [varchar](50) NULL,
	@MonthlyEligibility04CD [varchar](50) NULL,
	@MonthlyEligibility05CD [varchar](50) NULL,
	@MonthlyEligibility06CD [varchar](50) NULL,
	@MonthlyEligibility07CD [varchar](50) NULL,
	@MonthlyEligibility08CD [varchar](50) NULL,
	@MonthlyEligibility09CD [varchar](50) NULL,
	@MonthlyEligibility10CD [varchar](50) NULL,
	@MonthlyEligibility11CD [varchar](50) NULL,
	@MonthlyEligibility12CD [varchar](50) NULL,
	@CMSHCCRiskScoreESRDNBR [varchar](50) NULL,
	@CMSHCCRiskScoreDisabledStatusNBR [varchar](50) NULL,
	@CMSHCCRiskScoreAgedDualStatusNBR [varchar](50) NULL,
	@CMSHCCRiskScoreAgedNondualStatusNBR [varchar](50),
	@EDWLastModifiedDTS varchaR(10),
	@FileNM [varchar](50)
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPQtrExclusionsBNEX]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[CurrentMBI] ,
	[YearNBR] ,
	[QuarterNBR] ,
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[FirstNM] ,
	[LastNM] ,
	[SexCD] ,
	[BirthDTS] ,
	[DeathDTS] ,
	[CountyNM] ,
	[HomeStateCD] ,
	[CountyNBR] ,
	[VoluntaryAlignmentFLG] ,
	[VoluntaryAlignmentTIN] ,
	[VoluntaryAlignmentNPI] ,
	[ClaimsBasedAssignmentFLG] ,
	[AssignmentStepCD] ,
	[NewlyAssignedBeneficiaryFLG] ,
	[PartDMonthsEnrolledNBR] ,
	[ExcludedFLG] ,
	[DeceasedExcludedFLG] ,
	[MissingIDExcludedFLG] ,
	[PartAandBOnlyExcludeFLG] ,
	[EmployerGroupHealthPlanExcludedFLG] ,
	[OutsideUSExcludedFLG] ,
	[OtherSharedSavingsInitiativesFLG] ,
	[MonthlyEligibility01CD] ,
	[MonthlyEligibility02CD] ,
	[MonthlyEligibility03CD] ,
	[MonthlyEligibility04CD] ,
	[MonthlyEligibility05CD] ,
	[MonthlyEligibility06CD] ,
	[MonthlyEligibility07CD] ,
	[MonthlyEligibility08CD] ,
	[MonthlyEligibility09CD] ,
	[MonthlyEligibility10CD] ,
	[MonthlyEligibility11CD] ,
	[MonthlyEligibility12CD] ,
	[CMSHCCRiskScoreESRDNBR] ,
	[CMSHCCRiskScoreDisabledStatusNBR] ,
	[CMSHCCRiskScoreAgedDualStatusNBR] ,
	[CMSHCCRiskScoreAgedNondualStatusNBR] ,
	[EDWLastModifiedDTS] ,
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
	CASE WHEN @DataDate    = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate )
	END,

	@CurrentMBI ,
	@YearNBR ,
	@QuarterNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@FirstNM ,
	@LastNM ,
	@SexCD ,
	CASE WHEN @BirthDTS   = ''
	THEN NULL
	ELSE CONVERT(DATE, @BirthDTS)
	END,
	--CASE WHEN @DeathDTS    = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @DeathDTS)
	--END,
	@DeathDTS,
	@CountyNM ,
	@HomeStateCD ,
	@CountyNBR ,
	@VoluntaryAlignmentFLG ,
	@VoluntaryAlignmentTIN ,
	@VoluntaryAlignmentNPI ,
	@ClaimsBasedAssignmentFLG ,
	@AssignmentStepCD ,
	@NewlyAssignedBeneficiaryFLG ,
	@PartDMonthsEnrolledNBR ,
	@ExcludedFLG ,
	@DeceasedExcludedFLG ,
	@MissingIDExcludedFLG ,
	@PartAandBOnlyExcludeFLG ,
	@EmployerGroupHealthPlanExcludedFLG ,
	@OutsideUSExcludedFLG ,
	@OtherSharedSavingsInitiativesFLG ,
	@MonthlyEligibility01CD ,
	@MonthlyEligibility02CD ,
	@MonthlyEligibility03CD ,
	@MonthlyEligibility04CD ,
	@MonthlyEligibility05CD ,
	@MonthlyEligibility06CD ,
	@MonthlyEligibility07CD ,
	@MonthlyEligibility08CD ,
	@MonthlyEligibility09CD ,
	@MonthlyEligibility10CD ,
	@MonthlyEligibility11CD ,
	@MonthlyEligibility12CD ,
	@CMSHCCRiskScoreESRDNBR ,
	@CMSHCCRiskScoreDisabledStatusNBR ,
	@CMSHCCRiskScoreAgedDualStatusNBR ,
	@CMSHCCRiskScoreAgedNondualStatusNBR ,
	@EDWLastModifiedDTS,
	--CASE WHEN  @EDWLastModifiedDTS = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @EDWLastModifiedDTS)
	--END,
	@FileNM 
	

  
)


    
END
