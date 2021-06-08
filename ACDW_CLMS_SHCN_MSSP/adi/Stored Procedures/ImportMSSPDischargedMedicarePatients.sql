-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPDischargedMedicarePatients]
	@SrcFileName [varchar](100),
	---[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10) ,
	@FIN	varchar(50) ,
	@PriInsurance varchar(50),	
	@nsuranceMemberID varchar(50) ,	
	@FName varchar(50),	 	
	@LName varchar(50) ,	
	@Birth varchar(10),	
	@IPAdmit varchar(50),	
	@NurseUnit VARCHAR(50),	 	
	@Room VARCHAR(50),		
	@Address VARCHAR(100),	
	@Phone VARCHAR(50) ,		
	@GMLOS VARCHAR(50) ,		
	@DRG	VARCHAR(50) ,	
	@DRGDescription VARCHAR(100),		
	@Discharge VARCHAR(50) ,	
	@DischargeDisposition VARCHAR(50),		
	@Attending VARCHAR(50) ,		
	@AttendingNPI VARCHAR(50),		
	@Surgeon	VARCHAR(50) ,	
	@Sex	VARCHAR(10) ,	
	@MRN	VARCHAR(50),	
	@Loc	VARCHAR(50),	
	@HospitalName VARCHAR(50),		
	@HospNPI VARCHAR(50), 
	@RunDate varchar(20)  	
	
            
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
	If (LEN(@FIN) > 0)
	BEGIN
    INSERT INTO [adi].[Steward_MSSPDischargedMedicarePatients]
    (

	[SrcFileName] ,
	[CreateDate],
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	FIN	,
	PriInsurance ,	
	InsuranceMemberID ,	
	FName ,	 	
	LName ,	
	Birth ,	
	IPAdmitDateTime ,	
	NurseUnit ,	 	
	Room ,		
	[Address] ,	
	Phone ,		
	GMLOS ,		
	DRG	,	
	DRGDescription ,		
	DischargeDateTime ,	
	DischargeDisposition ,		
	Attending ,		
	AttendingNPI ,		
	Surgeon	,	
	Sex	,	
	MRN	,	
	Loc	,	
	HospitalName ,		
	HospNPI, 	
	RunDate


	)
		
 VALUES  (

   @SrcFileName ,
   GETDATE(),
	---[CreateDate] [datetime] ,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
 --    CASE WHEN @DataDate = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @DataDate)
	--END,
	CONVERT(date, @RunDate)  ,
	@FIN,
	@PriInsurance ,	
	@nsuranceMemberID ,	
	@FName ,	 	
	@LName  ,	
	@Birth ,
	CASE WHEN @IPAdmit = ''
	THEN NULL
	ELSE CONVERT(datetime, @IPAdmit)
	END,		
	@NurseUnit ,	 	
	@Room ,		
	@Address ,	
	@Phone ,		
	@GMLOS ,		
	@DRG ,	
	@DRGDescription ,	
	CASE WHEN @Discharge  = ''
	THEN NULL
	ELSE CONVERT(datetime, @Discharge )
	END,	
	@DischargeDisposition ,		
	@Attending  ,		
	@AttendingNPI ,		
	@Surgeon	,	
	@Sex	 ,	
	@MRN	,	
	@Loc	,	
	@HospitalName ,		
	@HospNPI,
	CONVERT(date, @RunDate)
	  	
   
)

END

--BEGIN 
--  update [adi].[Steward_MSSPDischargedMedicarePatients]
--  SET IPAdmitDateTime = DataDate
--  --where SrcFileName = 'CurrentMedicarePatients_MTZ_2020-07-08-20-00-01.txt' and 
--  Where IPAdmitDateTime is NULL and DischargeDateTime is NULL 

--END 

  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END
