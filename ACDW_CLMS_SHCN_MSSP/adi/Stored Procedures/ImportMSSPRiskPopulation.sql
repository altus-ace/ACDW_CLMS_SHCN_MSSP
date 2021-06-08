-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPRiskPopulation]
    @SrcFileName varchar(100) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	--LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@YearNBR varchar(4) ,
	@Region varchar(50),
	@MedicareBeneficiaryID varchar(50),
	@HealthInsuranceClaimNBR [varchar](50),
	@FirstNM varchar(50),
	@LastNM varchar(50),
	@SexCD varchar(1) ,
	@BirthDTS varchar(10) ,
	@DeathDTS varchar(10),
	@CountyNM varchar(50),
	@HomeStateCD varchar(50) ,
	@CountyNBR varchar(50) ,
	@NPIMapping varchar(50),
	@BeneLivesinTX_LA_AR varchar(1),
	@FileNM 	[varchar](50) 
            
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
	
    INSERT INTO [adi].[Steward_MSSPRiskPopulation]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	YearNBR ,
	Region ,
	MedicareBeneficiaryID ,
	HealthInsuranceClaimNBR ,
	FirstNM ,
	LastNM ,
	SexCD ,
	BirthDTS ,
	DeathDTS ,
	CountyNM ,
	HomeStateCD ,
	CountyNBR ,
	NPIMapping ,
	BeneLivesinTX_LA_AR ,
	FileNM 	

	)
		
 VALUES  (
   
   @SrcFileName ,
   GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--LastUpdatedDate [datetime] NULL,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	@YearNBR ,
	@Region ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@FirstNM ,
	@LastNM ,
	@SexCD ,
	CASE WHEN @BirthDTS is NULL
	THEN NULL
	ELSE CONVERT(DATE, @BirthDTS)
	END,
	CASE WHEN 	@DeathDTS = 'NULL'
	THEN NULL
	ELSE CONVERT(DATE, 	@DeathDTS )
	END,
	@CountyNM,
	@HomeStateCD ,
	@CountyNBR  ,
	@NPIMapping ,
	@BeneLivesinTX_LA_AR ,
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
