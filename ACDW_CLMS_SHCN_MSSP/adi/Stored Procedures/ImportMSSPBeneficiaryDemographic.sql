-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPBeneficiaryDemographic]
    @SrcFileName varchar(100) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	--LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@MedicareBeneficiaryID varchar(50) ,
	@HealthInsuranceClaimNBR varchar(50),
	@FIPSStateCD varchar(10) ,
	@FIPSCountyCD varchar(10),
	@ZipCD varchar(15) ,
	@BirthDTS varchar(10) ,
	@SexCD varchar(10),
	@RaceCD varchar(10) ,
	@AgeNBR varchar(5),
	@BeneficiaryMedicareStatusCD varchar(10) ,
	@BeneficiaryDualStatusCD varchar(10) ,
	@DeathDTS varchar(10),
	@HospiceStartDTS varchar(10),
	@HospiceEndDTS varchar(10) ,
	@FirstNM varchar(50),
	@MiddleNM varchar(50),
	@LastNM varchar(50),
	@BeneficiaryOriginalEntitlementReasonCD varchar(10),
	@BeneficiaryEntitlementBuyInCD varchar(50),
	@MedicarePartABeneficiaryEnrollmentBeginDTS varchar(10) ,
	@MedicarePartBBeneficiaryEnrollmentBeginDTS varchar(10),
	@MailingAddress01TXT varchar(50) ,
	@MailingAddress02TXT varchar(50) ,
	@MailingAddress03TXT varchar(50),
	@MailingAddress04TXT varchar(50) ,
	@MailingAddress05TXT varchar(50) ,
	@MailingAddress06TXT varchar(50),
	@CityNM varchar(50) ,
	@StateCD varchar(50),
	@PostalZipCD varchar(12),
	@ZipExtensionCD varchar(10) ,
	@FileNM varchar(50)
            
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
	
    INSERT INTO [adi].[Steward_MSSPBeneficiaryDemographic]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate],
	[DataDate] ,
	[MedicareBeneficiaryID],
	[HealthInsuranceClaimNBR] ,
	[FIPSStateCD] ,
	[FIPSCountyCD] ,
	[ZipCD] ,
	[BirthDTS],
	[SexCD] ,
	[RaceCD] ,
	[AgeNBR] ,
	[BeneficiaryMedicareStatusCD] ,
	[BeneficiaryDualStatusCD] ,
	[DeathDTS] ,
	[HospiceStartDTS] ,
	[HospiceEndDTS] ,
	[FirstNM] ,
	[MiddleNM] ,
	[LastNM] ,
	[BeneficiaryOriginalEntitlementReasonCD] ,
	[BeneficiaryEntitlementBuyInCD] ,
	[MedicarePartABeneficiaryEnrollmentBeginDTS] ,
	[MedicarePartBBeneficiaryEnrollmentBeginDTS] ,
	[MailingAddress01TXT] ,
	[MailingAddress02TXT] ,
	[MailingAddress03TXT] ,
	[MailingAddress04TXT] ,
	[MailingAddress05TXT] ,
	[MailingAddress06TXT],
	[CityNM] ,
	[StateCD] ,
	[PostalZipCD] ,
	[ZipExtensionCD], 
	[FileNM] 

	)
		
 VALUES  (
   
     @SrcFileName  ,
	 GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--LastUpdatedDate [datetime] NULL,
	--@DateFromFile,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	@MedicareBeneficiaryID  ,
	@HealthInsuranceClaimNBR ,
	@FIPSStateCD ,
	@FIPSCountyCD ,
	@ZipCD  ,
	CONVERT(DATE, SUBSTRING(@BirthDTS,1, 10)) ,
	@SexCD ,
	@RaceCD ,
	@AgeNBR ,
	@BeneficiaryMedicareStatusCD ,
	@BeneficiaryDualStatusCD ,
	CASE WHEN @DeathDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@DeathDTS,1, 10)) 
	END,
	CASE WHEN @HospiceStartDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@HospiceStartDTS ,1, 10)) 
	END,
	CASE WHEN 	@HospiceEndDTS   = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(	@HospiceEndDTS  ,1, 10)) 
	END,
	@FirstNM ,
	@MiddleNM ,
	@LastNM ,
	@BeneficiaryOriginalEntitlementReasonCD ,
	@BeneficiaryEntitlementBuyInCD ,
	CASE WHEN 
	@MedicarePartABeneficiaryEnrollmentBeginDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(
	@MedicarePartABeneficiaryEnrollmentBeginDTS ,1, 10)) 
	END,
	CASE WHEN @MedicarePartBBeneficiaryEnrollmentBeginDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(	@MedicarePartBBeneficiaryEnrollmentBeginDTS ,1, 10)) 
	END,
	@MailingAddress01TXT ,
	@MailingAddress02TXT ,
	@MailingAddress03TXT ,
	@MailingAddress04TXT ,
	@MailingAddress05TXT  ,
	@MailingAddress06TXT ,
	@CityNM ,
	@StateCD ,
	@PostalZipCD ,
	@ZipExtensionCD ,
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
