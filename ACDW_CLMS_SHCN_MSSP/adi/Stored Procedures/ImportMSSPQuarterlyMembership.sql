-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPQuarterlyMembership]
    @SrcFileName varchar(100) ,
	--CreateDate datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
	--LastUpdatedDate datetime ,
	@DataDate varchar(10) ,
	@YearNBR varchar(10) ,
	@QuarterNBR varchar(10) ,
	@MedicareBeneficiaryID varchar(50) ,
	@HealthInsuranceClaimNBR varchar(50) ,
	@FirstNM varchar(50) ,
	@LastNM varchar(50) ,
	@SexCD varchar(5) ,
	@BirthDTS varchar(10) ,
	@DeathDTS varchar(10) ,
	@CountyNM varchar(50) ,
	@HomeStateCD varchar(5) ,
	@CountyNBR varchar(50) ,
	@VoluntaryAlignmentFLG varchar(5) ,
	@VoluntaryAlignmentTIN varchar(20) ,
	@VoluntaryAlignmentNPI varchar(20) ,
	@ClaimsBasedAssignmentFLG varchar(5) ,
	@AssignmentStepCD varchar(5) ,
	@NewlyAssignedBeneficiaryFLG varchar(5) ,
	@PartDMonthsEnrolledNBR varchar(50) ,
	@ExcludedFLG varchar(5) ,
	@DeceasedExcludedFLG varchar(5) ,
	@MissingIDExcludedFLG varchar(5) ,
	@PartAandBOnlyExcludeFLG varchar(5) ,
	@EmployerGroupHealthPlanExcludedFLG varchar(5) ,
	@OutsideUSExcludedFLG varchar(5) ,
	@OtherSharedSavingsInitiativesFLG varchar(5) ,
	@MonthlyEligibility01CD varchar(5) ,
	@MonthlyEligibility02CD varchar(5) ,
	@MonthlyEligibility03CD varchar(5) ,
	@MonthlyEligibility04CD varchar(5) ,
	@MonthlyEligibility05CD varchar(5) ,
	@MonthlyEligibility06CD varchar(5) ,
	@MonthlyEligibility07CD varchar(5) ,
	@MonthlyEligibility08CD varchar(5) ,
	@MonthlyEligibility09CD varchar(5) ,
	@MonthlyEligibility10CD varchar(5) ,
	@MonthlyEligibility11CD varchar(5) ,
	@MonthlyEligibility12CD varchar(5) ,
	@CMSHCCRiskScoreESRDNBR varchar(50) ,
	@CMSHCCRiskScoreDisabledStatusNBR varchar(50) ,
	@CMSHCCRiskScoreAgedDualStatusNBR varchar(50) ,
	@CMSHCCRiskScoreAgedNondualStatusNBR varchar(50) ,
	@FileNM varchar(50) 
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF

	--0DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)
	
	
    INSERT INTO [adi].[Steward_MSSPQuarterlyMembership]
    (
       [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      ,[YearNBR]
      ,[QuarterNBR]
      ,[MedicareBeneficiaryID]
      ,[HealthInsuranceClaimNBR]
      ,[FirstNM]
      ,[LastNM]
      ,[SexCD]
      ,[BirthDTS]
      ,[DeathDTS]
      ,[CountyNM]
      ,[HomeStateCD]
      ,[CountyNBR]
      ,[VoluntaryAlignmentFLG]
      ,[VoluntaryAlignmentTIN]
      ,[VoluntaryAlignmentNPI]
      ,[ClaimsBasedAssignmentFLG]
      ,[AssignmentStepCD]
      ,[NewlyAssignedBeneficiaryFLG]
      ,[PartDMonthsEnrolledNBR]
      ,[ExcludedFLG]
      ,[DeceasedExcludedFLG]
      ,[MissingIDExcludedFLG]
      ,[PartAandBOnlyExcludeFLG]
      ,[EmployerGroupHealthPlanExcludedFLG]
      ,[OutsideUSExcludedFLG]
      ,[OtherSharedSavingsInitiativesFLG]
      ,[MonthlyEligibility01CD]
      ,[MonthlyEligibility02CD]
      ,[MonthlyEligibility03CD]
      ,[MonthlyEligibility04CD]
      ,[MonthlyEligibility05CD]
      ,[MonthlyEligibility06CD]
      ,[MonthlyEligibility07CD]
      ,[MonthlyEligibility08CD]
      ,[MonthlyEligibility09CD]
      ,[MonthlyEligibility10CD]
      ,[MonthlyEligibility11CD]
      ,[MonthlyEligibility12CD]
      ,[CMSHCCRiskScoreESRDNBR]
      ,[CMSHCCRiskScoreDisabledStatusNBR]
      ,[CMSHCCRiskScoreAgedDualStatusNBR]
      ,[CMSHCCRiskScoreAgedNondualStatusNBR]
      ,[FileNM]
	)
		
 VALUES  (
     @SrcFileName  ,
	 GETDATE(),
	--CreateDate datetime ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
	GETDATE(),
	--LastUpdatedDate datetime ,
	CASE WHEN @DataDate =''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END  ,
	@YearNBR  ,
	@QuarterNBR  ,
	@MedicareBeneficiaryID  ,
	@HealthInsuranceClaimNBR  ,
	@FirstNM  ,
	@LastNM  ,
	@SexCD  ,
	CASE WHEN @BirthDTS  =''
	THEN NULL
	ELSE CONVERT(DATE, @BirthDTS )
	END  ,
	CASE WHEN @DeathDTS =''
	THEN NULL
	ELSE CONVERT(DATE, @DeathDTS )
	END  ,	
	
	@CountyNM  ,
	@HomeStateCD  ,
	@CountyNBR  ,
	@VoluntaryAlignmentFLG  ,
	@VoluntaryAlignmentTIN  ,
	@VoluntaryAlignmentNPI  ,
	@ClaimsBasedAssignmentFLG  ,
	@AssignmentStepCD  ,
	@NewlyAssignedBeneficiaryFLG  ,
	@PartDMonthsEnrolledNBR  ,
	@ExcludedFLG  ,
	@DeceasedExcludedFLG  ,
	@MissingIDExcludedFLG  ,
	@PartAandBOnlyExcludeFLG  ,
	@EmployerGroupHealthPlanExcludedFLG  ,
	@OutsideUSExcludedFLG  ,
	@OtherSharedSavingsInitiativesFLG  ,
	@MonthlyEligibility01CD  ,
	@MonthlyEligibility02CD  ,
	@MonthlyEligibility03CD  ,
	@MonthlyEligibility04CD  ,
	@MonthlyEligibility05CD  ,
	@MonthlyEligibility06CD  ,
	@MonthlyEligibility07CD  ,
	@MonthlyEligibility08CD  ,
	@MonthlyEligibility09CD  ,
	@MonthlyEligibility10CD  ,
	@MonthlyEligibility11CD  ,
	@MonthlyEligibility12CD  ,
	@CMSHCCRiskScoreESRDNBR  ,
	@CMSHCCRiskScoreDisabledStatusNBR  ,
	@CMSHCCRiskScoreAgedDualStatusNBR  ,
	@CMSHCCRiskScoreAgedNondualStatusNBR  ,
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
