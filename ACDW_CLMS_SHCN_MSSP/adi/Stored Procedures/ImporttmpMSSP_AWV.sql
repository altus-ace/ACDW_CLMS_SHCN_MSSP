-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImporttmpMSSP_AWV]
    @ProgramName VARCHAR(50) ,
	@MeasureName  VARCHAR(50),
	@ProviderName  VARCHAR(50),
	@ProviderUsername  VARCHAR(50) ,
	@NPI  VARCHAR(11) NULL,
	@PatientID  VARCHAR(50) NULL,
    @LastName  VARCHAR(50) NULL,
	@FirstName  VARCHAR(50) NULL,
	@DOBDATE varchar(10),
	@Age varchar(10),
	@Sex CHAR(1) NULL,
	@Phone varchar(20) NULL,
	@RAFScore varchar(20),
	@GAPScore varchar(20),
	@Race VARCHAR(50) NULL,
	@Ethnicity VARCHAR(50) NULL,
	@Language VARCHAR(50) NULL,
	@Department_Last_Encounter varchar(100) NULL,
	@LastEncounter varchar(100) NULL,
	@NextAppointment varchar(10),
	@ResultStatus varchar(50) NULL ,
	@Result varchar(50) NULL,
	@SatisfiedDate varchar(10),
	@SupportingDocumentation VARCHAR(100) NULL,
	@PrimaryInsurance varchar(50) NULL,
	@PrimaryInsurancePackageType varchar(50) NULL,
	@PrimaryInsurancePolicyNumber varchar(50) NULL,
	@SecondaryInsurance VARCHAR(100) NULL,
	@SecondaryInsurancePackageType VARCHAR(50) NULL,
	@SecondaryInsurancePolicyNumber VARCHAR(50) NULL,
	@DateRun varchar(10), 
	--[LoadDate] [date] NOT NULL,
	@DataDate varchar(10),
	@srcFileName [varchar](100),
	--[CreatedDate] [datetime] NULL,
	@CreatedBy [varchar](50),
	@LastUpdatedBy [varchar](100)
--	[LastUpdatedDate] [datetime] NULL,
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
    INSERT INTO [adi].[tmp_Athena_AWV]
    (
	ProgramName ,
	MeasureName ,                  
	ProviderName ,
	ProviderUsername ,
	NPI ,
	PatientID ,
	LastName  ,
	FirstName ,
	DOBDATE ,
	Age ,
	Sex ,
	Phone ,
	RAFScore ,
	GAPScore ,
	Race ,
	Ethnicity ,
	[Language] ,
	Department_Last_Encounter ,
	LastEncounter ,
	NextAppointment ,
	ResultStatus ,
	Result ,
	SatisfiedDate ,
	SupportingDocumentation ,
	PrimaryInsurance ,
	PrimaryInsurancePackageType ,
	PrimaryInsurancePolicyNumber ,
	SecondaryInsurance ,
	SecondaryInsurancePackageType ,
	SecondaryInsurancePolicyNumber ,
	DateRun , 
	[LoadDate] ,
	[DataDate] ,
	[srcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] 
	
	)
		
 VALUES  (

     @ProgramName ,
	@MeasureName  ,
	@ProviderName  ,
	@ProviderUsername  ,
	@NPI ,
	@PatientID ,
    @LastName ,
	@FirstName ,
	@DOBDATE ,
	--CASE WHEN @Age = ''
 --   THEN NULL
	--ELSE CONVERT(smallint ,@Age )
	--END,
	@Age,
	@Sex ,
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
	@Ethnicity ,
	@Language ,
	@Department_Last_Encounter ,
	@LastEncounter ,
	@NextAppointment ,
	@ResultStatus  ,
	@Result ,
	@SatisfiedDate ,
	@SupportingDocumentation ,
	@PrimaryInsurance ,
	@PrimaryInsurancePackageType ,
	@PrimaryInsurancePolicyNumber ,
	@SecondaryInsurance ,
	@SecondaryInsurancePackageType ,
	@SecondaryInsurancePolicyNumber ,
	@DateRun , 
	GETDATE(),
	--[LoadDate] [date] NOT NULL,
	GETDATE(),
	--CASE WHEN @DataDate = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @DataDate)
	--END,
	@srcFileName ,
	GETDATE(),
	--[CreatedDate] [datetime] NULL,
	@CreatedBy ,
	@LastUpdatedBy,
	GETDATE() 
--	[LastUpdatedDate] [datetime] NULL,
              
)
END
END
