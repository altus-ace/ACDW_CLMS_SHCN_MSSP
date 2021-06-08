-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimLineItem]
 	@SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10) NULL,
	@ClaimID [varchar](50) NULL,
	@LineNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@StartDTS varchar(50),
	@EndDTS varchar(50),
	@RevenueCenterCD [varchar](50) NULL,
	@RevenueCenterDSC [varchar](500) NULL,
	@RevenueCenterDTS varchar(50),
	@HCPCS [varchar](50) NULL,
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@CMSCertificationNBR [varchar](50) NULL,
	@ClaimStartDTS varchar(50),
	@ClaimEndDTS varchar(50),
	@AllowedUnitCNT varchar(5),
	@PaymentAMT varchar(10),
	@HCPCSModifier01CD [varchar](10) NULL,
	@HCPCSModifier02CD [varchar](10) NULL,
	@HCPCSModifier03CD [varchar](10) NULL,
	@HCPCSModifier04CD [varchar](10) NULL,
	@HCPCSModifier05CD [varchar](10) NULL,
	@RevenueAPCHIPPSCD [varchar](10) NULL,
	@FileNM [varchar](50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- DECLARE @DateFromFile DATE
   -- SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))

	
    INSERT INTO [adi].[Steward_MSSPPartAClaimLineItem]
    (
	   [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      ,[ClaimID]
      ,[LineNBR]
      ,[MedicareBeneficiaryID]
      ,[HealthInsuranceClaimNBR]
      ,[ClaimTypeCD]
      ,[ClaimTypeDSC]
      ,[StartDTS]
      ,[EndDTS]
      ,[RevenueCenterCD]
      ,[RevenueCenterDSC]
      ,[RevenueCenterDTS]
      ,[HCPCS]
      ,[UmbrellaHealthInsuranceClaimNBR]
      ,[CMSCertificationNBR]
      ,[ClaimStartDTS]
      ,[ClaimEndDTS]
      ,[AllowedUnitCNT]
      ,[PaymentAMT]
      ,[HCPCSModifier01CD]
      ,[HCPCSModifier02CD]
      ,[HCPCSModifier03CD]
      ,[HCPCSModifier04CD]
      ,[HCPCSModifier05CD]
      ,[RevenueAPCHIPPSCD]
      ,[FileNM]

	)
		
 VALUES  (
   @SrcFileName,
	--[CreateDate] [datetime] NULL,
	GETDATE(),
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
	CASE WHEN @StartDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@StartDTS,1, 10)) 
	END,
	CASE WHEN @EndDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@EndDTS ,1, 10)) 
	END,
	@RevenueCenterCD ,
	@RevenueCenterDSC ,
		CASE WHEN @RevenueCenterDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@RevenueCenterDTS ,1, 10)) 
	END,
	@HCPCS ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@CMSCertificationNBR ,
	CASE WHEN @ClaimStartDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimStartDTS,1, 10)) 
	END,
	CASE WHEN @ClaimEndDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@ClaimEndDTS,1, 10)) 
	END,
	@AllowedUnitCNT,
	--CASE WHEN @AllowedUnitCNT = ''
	--THEN NULL
	--ELSE CONVERT(INT, @AllowedUnitCNT) 
	--END,
	CASE WHEN @PaymentAMT  = ''
	THEN NULL
	ELSE CONVERT(money, @PaymentAMT)
	END, 
	@HCPCSModifier01CD ,
	@HCPCSModifier02CD ,
	@HCPCSModifier03CD ,
	@HCPCSModifier04CD ,
	@HCPCSModifier05CD ,
	@RevenueAPCHIPPSCD ,
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
