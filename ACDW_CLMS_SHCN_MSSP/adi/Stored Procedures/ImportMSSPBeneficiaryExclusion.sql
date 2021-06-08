-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPBeneficiaryExclusion]
    @SrcFileName varchar(100) ,
	--[CreateDate [datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
	--@LastUpdatedDate @datetime ,
	@DataDate varchar(10) ,
	@PerformanceYearNBR varchar(50) ,
	@ReportMonthNBR varchar(50) ,
	@FileCreationDTS varchar(10) ,
	@HealthInsuranceClaimNBR varchar(50) ,
	@MedicareBeneficiaryID varchar(50) ,
	@FirstNM varchar(50) ,
	@MiddleNM varchar(10) ,
	@LastNM varchar(50) ,
	@BirthDTS varchar(10),
	@GenderCD varchar(10) ,
	@GenderDSC varchar(100) ,
	@Reason01CD varchar(10) ,
	@Reason01DSC varchar(100) ,
	@Reason02CD varchar(10) ,
	@Reason02DSC varchar(100) ,
	@Reason03CD varchar(10) ,
	@Reason03DSC varchar(100) ,
	@fileNM varchar(50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)
	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPBeneficiaryExclusion]
    (
	   [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      ,[PerformanceYearNBR]
      ,[ReportMonthNBR]
      ,[FileCreationDTS]
      ,[HealthInsuranceClaimNBR]
      ,[MedicareBeneficiaryID]
      ,[FirstNM]
      ,[MiddleNM]
      ,[LastNM]
      ,[BirthDTS]
      ,[GenderCD]
      ,[GenderDSC]
      ,[Reason01CD]
      ,[Reason01DSC]
      ,[Reason02CD]
      ,[Reason02DSC]
      ,[Reason03CD]
      ,[Reason03DSC]
      ,[fileNM]

	)
		
 VALUES  (
    @SrcFileName ,
	GETDATE(),
	--[CreateDate [datetime ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
	GETDATE(),
	--@LastUpdatedDate @datetime ,
	@DataDate  ,
	@PerformanceYearNBR  ,
	@ReportMonthNBR  ,
	@FileCreationDTS  ,
	@HealthInsuranceClaimNBR  ,
	@MedicareBeneficiaryID  ,
	@FirstNM  ,
	@MiddleNM  ,
	@LastNM  ,
	@BirthDTS ,
	@GenderCD  ,
	@GenderDSC  ,
	@Reason01CD  ,
	@Reason01DSC  ,
	@Reason02CD  ,
	@Reason02DSC  ,
	@Reason03CD  ,
	@Reason03DSC  ,
	@fileNM    
  
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
