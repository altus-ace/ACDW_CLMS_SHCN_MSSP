-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimProcedureCode]
    @SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID [varchar](50) NULL,
	@ICDProcedureSEQ [varchar](10) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ICDProcedureCD [varchar](10) NULL,
	@ICDProcedureDTS varchar(10),
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@CMSCertificationNBR [varchar](50) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS varchar(10),
	@ICDRevisionCD [varchar](10) NULL,
	@FileNM [varchar](50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))

	
    INSERT INTO [adi].[Steward_MSSPPartAClaimProcedureCode]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ClaimID] ,
	[ICDProcedureSEQ] ,
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[ClaimTypeCD] ,
	[ClaimTypeDSC] ,
	[ICDProcedureCD] ,
	[ICDProcedureDTS] ,
	[UmbrellaHealthInsuranceClaimNBR] ,
	[CMSCertificationNBR] ,
	[ClaimStartDTS] ,
	[ClaimEndDTS] ,
	[ICDRevisionCD] ,
	[FileNM] 
	)
		
 VALUES  (
     @SrcFileName ,
	GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	--@DateFromFile ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	@ClaimID ,
	@ICDProcedureSEQ ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	@ICDProcedureCD ,
	@ICDProcedureDTS ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@CMSCertificationNBR ,
	@ClaimStartDTS ,
	@ClaimEndDTS ,
	@ICDRevisionCD ,
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
