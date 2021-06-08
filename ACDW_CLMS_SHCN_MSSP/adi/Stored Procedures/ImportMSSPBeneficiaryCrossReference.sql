-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPBeneficiaryCrossReference]
   @SrcFileName varchar(100),
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100),
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	@DataDate varchar(12),
	@IdentifierTypeCD varchar(10),
	@CurrentHealthInsuranceClaimNBR varchar(50) ,
	@PreviousHealthInsuranceClaimNBR varchar(50),
	@PreviousHealthInsuranceClaimNumberStartDTS varchar(12),
	@PreviousHealthInsuranceClaimNumberEndDTS varchar(12),
	@RailroadBoardNBR varchar(50),
	@FileNM varchar(50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)

	DECLARE @DateFromFile DATE
	SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_MSSPBeneficiaryCrossReference]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[IdentifierTypeCD] ,
	[CurrentHealthInsuranceClaimNBR] ,
	[PreviousHealthInsuranceClaimNBR] ,
	[PreviousHealthInsuranceClaimNumberStartDTS] ,
	[PreviousHealthInsuranceClaimNumberEndDTS] ,
	[RailroadBoardNBR] ,
	[FileNM] 

	)
		
 VALUES  (
     @SrcFileName ,
	 GETDATE(),
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
    CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	-- @DateFromFile,  
	@IdentifierTypeCD ,
	@CurrentHealthInsuranceClaimNBR ,
	@PreviousHealthInsuranceClaimNBR ,
	CASE WHEN  @PInsuranceClaimNumberStartDTS  = ''
	THEN NULL
	ELSE CONVERT(DATE, @PInsuranceClaimNumberStartDTS )
	END, 
	CASE WHEN @PInsuranceClaimNumberEndDTS   = ''
	THEN NULL
	ELSE CONVERT(DATE, @PInsuranceClaimNumberEndDTS )
	END, 
	@RailroadBoardNBR ,
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
