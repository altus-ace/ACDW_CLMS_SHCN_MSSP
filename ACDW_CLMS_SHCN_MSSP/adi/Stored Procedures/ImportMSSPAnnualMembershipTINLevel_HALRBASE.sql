-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPAnnualMembershipTINLevel_HALRBASE]
    @SrcFileName [varchar](100) NULL,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	
	@YearNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@FirstNM [varchar](20) NULL,
	@LastNM [varchar](50) NULL,
	@SexCD [varchar](10) NULL,
	@BirthDTS varchar(10) NULL,
	@DeathDTS varchar(10) NULL,
	@TIN varchar(50) NULL ,
	@PrimaryCareServicesCNT varchar(10) NULL ,
	@EDWLastModifiedDTS varchar(10) NULL,
	@FileNM varchar(100) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF

	DECLARE @DateFromFile DATE
	SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPAnnualMembershipTINLevel_HALRBASE]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate],

	[YearNBR],
	[MedicareBeneficiaryID] ,
	[HealthInsuranceClaimNBR] ,
	[FirstNM] ,
	[LastNM] ,
	[SexCD] ,
	[BirthDTS] ,
	[DeathDTS] ,
	[TIN] ,
	[PrimaryCareServicesCNT] ,
	[EDWLastModifiedDTS],
	[FileNM] 

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
    @DateFromFile,
	@YearNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@FirstNM ,
	@LastNM ,
	@SexCD ,
	CASE WHEN @BirthDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@BirthDTS ,1, 10)) 
	END,
	CASE WHEN @DeathDTS = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@DeathDTS,1, 10)) 
	END,
	@TIN  ,
	@PrimaryCareServicesCNT ,

	CASE WHEN @EDWLastModifiedDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, SUBSTRING(@EDWLastModifiedDTS ,1, 10)) 
	END,
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
