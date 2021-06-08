-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[Import_tmp_MemberListValidation]
    @SrcFileName [varchar](100) NULL,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	
	@MBI_ID varchar(50) NULL,
	@HICN varchar(50) NULL,
	@PatientFirstName varchar(50) NULL,
	@PatientLastName varchar(50) NULL,
	@DOB varchar(20) NULL,
	@Gender varchar(10) NULL,
	@AttributedNPI varchar(50) NULL,
	@ProviderName varchar(50) NULL, 
	@HCCRiskScore varchar(10) NULL ,
	@New_2020_Patient varchar(5) NULL,
	@PatientEMvisitwithSHCNProvider varchar(5) NULL,
	@PatientEligibleCMSDiabetesProgra varchar(5) NULL,
	@PatientenrolledChronicComplexPatientManagementprogram_2019 varchar(50) NULL,
	
	@PatientidentifiedHighRisk varchar(5) NULL
            
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
	
	
    INSERT INTO [adi].[tmp_MemberListValidation]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate],
	[MBI_ID] ,
	[HICN] ,
	[PatientFirstName] ,
	[PatientLastName] ,
	[DOB] ,
	[Gender] ,
	[AttributedNPI] ,
	[ProviderName] , 
	[HCCRiskScore]  ,
	[New_2020_Patient] ,
	[PatientEMvisitwithSHCNProvider] ,
	[PatientEligibleCMSDiabetesProgra] ,
	[PatientenrolledChronicComplexPatientManagementprogram_2019] ,
	[PatientidentifiedHighRisk] 
	)
 VALUES  (
   
    @SrcFileName ,
	-- [CreateDate] [datetime] NULL,
	GETDATE(),
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	GETDATE(),
    CONVERT(DATE, @DataDate),
	@MBI_ID ,
	@HICN ,
	@PatientFirstName ,
	@PatientLastName ,
	CASE WHEN @DOB  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@DOB ,1, 10)) 
	END,
	@Gender ,
	@AttributedNPI ,
	@ProviderName , 
	CASE WHEN @HCCRiskScore   = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2), @HCCRiskScore) 
	END,
	@New_2020_Patient ,
	@PatientEMvisitwithSHCNProvider ,
	@PatientEligibleCMSDiabetesProgra ,
	@PatientenrolledChronicComplexPatientManagementprogram_2019 ,
	
	@PatientidentifiedHighRisk 


    
            
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


