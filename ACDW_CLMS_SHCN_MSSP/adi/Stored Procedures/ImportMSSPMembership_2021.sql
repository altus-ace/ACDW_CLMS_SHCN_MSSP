-- =============================================
-- Author:		Bing Yu
-- Create date: 01/26/2021
-- Description:	Insert new MSMP  member file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPMembership_2021]
    @AlignmentType varchar(50) ,
	@AlignmentNPI varchar(20) ,
	@AlignmentPCPName varchar(50) ,
	@AlignmentChapter varchar(50) ,
	@AlignmentRegion varchar(50) ,
	@SMGOrAffiliate varchar(50) ,
	@PersistingBene varchar(50) ,
	@CurrentMBI varchar(50) ,
	@YearNBR varchar(50) ,
	@MedicareBeneficiaryID varchar(50) ,
	@HealthInsuranceClaimNBR varchar(50) ,
	@FirstNM varchar(50) ,
	@LastNM varchar(50) ,
	@SexCD varchar(10) ,
	@BirthDTS varchar(10),
	@DeathDTS varchar(10),
	@CountyNM varchar(50) ,
	@HomeStateCD varchar(50) ,
	@CountyNBR varchar(50) ,
	@VoluntaryAlignmentFLG varchar(10) ,
	@VoluntaryAlignmentTIN varchar(20) ,
	@VoluntaryAlignmentNPI varchar(20) ,
	@ClaimsBasedAssignmentFLG varchar(10) ,
	@ClaimBasedAssignmentStepFLG varchar(10) ,
	@SrcFileName varchar(100) ,
--	@CreateDate datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
	--@LastUpdatedDate datetime ,
	@DataDate varchar(10)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF

	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)
	
	
    INSERT INTO [adi].[Steward_MSSPMembership_2021]
    (
	  [AlignmentType]
      ,[AlignmentNPI]
      ,[AlignmentPCPName]
      ,[AlignmentChapter]
      ,[AlignmentRegion]
      ,[SMGOrAffiliate]
      ,[PersistingBene]
      ,[CurrentMBI]
      ,[YearNBR]
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
      ,[ClaimBasedAssignmentStepFLG]
      ,[SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
	)
 VALUES  (
    @AlignmentType  ,
	@AlignmentNPI  ,
	@AlignmentPCPName  ,
	@AlignmentChapter  ,
	@AlignmentRegion  ,
	@SMGOrAffiliate  ,
	@PersistingBene  ,
	@CurrentMBI  ,
	@YearNBR  ,
	@MedicareBeneficiaryID  ,
	@HealthInsuranceClaimNBR  ,
	@FirstNM  ,
	@LastNM  ,
	@SexCD  ,
	CASE WHEN @BirthDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, @BirthDTS)
	END ,
	CASE WHEN @DeathDTS  is NULL
	THEN NULL
	ELSE CONVERT(DATE, @DeathDTS )
	END ,
	@CountyNM  ,
	@HomeStateCD  ,
	@CountyNBR  ,
	@VoluntaryAlignmentFLG  ,
	@VoluntaryAlignmentTIN  ,
	@VoluntaryAlignmentNPI  ,
	@ClaimsBasedAssignmentFLG  ,
	@ClaimBasedAssignmentStepFLG  ,
	@SrcFileName  ,
--	@CreateDate datetime ,
    GETDATE(),
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
	GETDATE(),
	--@LastUpdatedDate datetime ,
	CASE WHEN @DataDate   is NULL
	THEN NULL
	ELSE CONVERT(DATE, @DataDate )
	END 
	
            
)


END


