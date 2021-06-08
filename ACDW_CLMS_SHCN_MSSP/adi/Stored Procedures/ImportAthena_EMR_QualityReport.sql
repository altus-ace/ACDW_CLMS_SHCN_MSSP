-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportAthena_EMR_QualityReport]
    @ProgramName [varchar](50),
	@MeasureName [varchar](50) ,
	@ProviderName [varchar](50),
	@ProviderUsername [varchar](50) ,
	@NPI [varchar](11) ,
	@PatientID [varchar](50) ,
	@LastName [varchar](50),
	@FirstName [varchar](50),
	@DOB varchar(10),
	@Age varchar(5),
	@Sex [char](1) ,
	@Phone [varchar](20),
	@RAFScore varchar(10),
	@GAPScore varchar(10),
	@Race [varchar](50),
	@Ethnicity [varchar](50) ,
	@Language [varchar](50),
	@Department_Last_Encounter [varchar](100) ,
	@LastEncounter [varchar](100) ,
	@NextAppointment varchar(10),
	@ResultStatus [varchar](50),
	@Result [varchar](50) ,
	@SatisfiedDate varchar(10) ,
	@SupportingDocumentation [varchar](100),
	@PrimaryInsurance [varchar](50),
	@PrimaryInsurancePackageType [varchar](50) ,
	@PrimaryInsurancePolicyNumber [varchar](50) ,
	@SecondaryInsurance [varchar](100),
	@SecondaryInsurancePackageType [varchar](50),
	@SecondaryInsurancePolicyNumber [varchar](50),
	@DateRun varchar(10),
	@LoadDate varchar(10),
	@DataDate varchar(10),
	@srcFileName [varchar](100) ,
	--[CreatedDate] [datetime] ,
	@CreatedBy [varchar](50) ,
	@LastUpdatedBy [varchar](100) 
	--[LastUpdatedDate] 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
    INSERT INTO [adi].[Athena_EMR_QualityReport]
    (
	  [ProgramName]
      ,[MeasureName]
      ,[ProviderName]
      ,[ProviderUsername]
      ,[NPI]
      ,[PatientID]
      ,[LastName]
      ,[FirstName]
      ,[DOB]
      ,[Age]
      ,[Sex]
      ,[Phone]
      ,[RAFScore]
      ,[GAPScore]
      ,[Race]
      ,[Ethnicity]
      ,[Language]
      ,[Department_Last_Encounter]
      ,[LastEncounter]
      ,[NextAppointment]
      ,[ResultStatus]
      ,[Result]
      ,[SatisfiedDate]
      ,[SupportingDocumentation]
      ,[PrimaryInsurance]
      ,[PrimaryInsurancePackageType]
      ,[PrimaryInsurancePolicyNumber]
      ,[SecondaryInsurance]
      ,[SecondaryInsurancePackageType]
      ,[SecondaryInsurancePolicyNumber]
      ,[DateRun]
      ,[LoadDate]
      ,[DataDate]
      ,[srcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]

	)
		
 VALUES  (
    @ProgramName ,
	@MeasureName ,
	@ProviderName ,
	@ProviderUsername ,
	@NPI ,
	@PatientID ,
	@LastName ,
	@FirstName ,
    CASE WHEN @DOB = ''
	THEN NULL
	ELSE CONVERT(DATE,@DOB)
	END,
 --   CASE WHEN @Age = ''
	--THEN NULL
	--ELSE CONVERT(smallint, @Age)
	--END,
	@Age,
	@Sex  ,
	@Phone ,
	CASE WHEN @RAFScore = ''
    THEN NULL
	ELSE CONVERT(decimal(10,3) ,@RAFScore)
	END,
	CASE WHEN @GAPScore = ''
    THEN NULL
	ELSE CONVERT(decimal(10,3),@GAPScore)
	END,
	@Race ,
	@Ethnicity  ,
	@Language ,
	@Department_Last_Encounter ,
	@LastEncounter,
	@NextAppointment,
 --   CASE WHEN @NextAppointment  = ''
	--THEN NULL
	--ELSE CONVERT(DATE, 	@NextAppointment )
	--END,
	@ResultStatus ,
	@Result ,
    CASE WHEN @SatisfiedDate = ''
	THEN NULL
	ELSE CONVERT(DATE,	@SatisfiedDate)
	END,
	@SupportingDocumentation ,
	@PrimaryInsurance ,
	@PrimaryInsurancePackageType ,
	@PrimaryInsurancePolicyNumber ,
	@SecondaryInsurance ,
	@SecondaryInsurancePackageType ,
	@SecondaryInsurancePolicyNumber ,
    CASE WHEN 	@DateRun  = ''
	THEN NULL
	ELSE CONVERT(DATE, 	@DateRun)
	END,
 --   CASE WHEN 	@LoadDate   = ''
	--THEN NULL
	--ELSE CONVERT(DATE, 	@LoadDate)
	--END,
	GETDATE(),
    CASE WHEN @DateRun  = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateRun)
	END,
	@srcFileName ,
	GETDATE(),
	--[CreatedDate] [datetime] ,
	@CreatedBy ,
	@LastUpdatedBy ,
	GETDATE() 
	--[LastUpdatedDate] 
)
END
END
