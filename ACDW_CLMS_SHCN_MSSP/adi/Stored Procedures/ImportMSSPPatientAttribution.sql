-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPatientAttribution](
    @SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](100) ,
	@DataDate varchar(10) ,
	@MBI_ID [varchar](50),
	@PatientFirstName [varchar](50) ,
	@PatientLastName [varchar](50) ,
	@DOB VARCHAR(10),
	@Sex [varchar](10) ,
	@AttributedNPI [varchar](50) ,
	@ProviderName [varchar](50) ,
	@HCCRiskScore varchar(10) ,
	@NEW_2021_Patient [varchar](10) ,
	@Patient_AWV_Last_12Month varchar(10) ,
	@UnplannedIPVisit_12Month varchar(10) ,
	@PatientIdentified_High_Risk [varchar](10) ,
	@PatientDiagnosedDiabetes [varchar](10) 
 )           
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
    INSERT INTO [adi].[MSSPPatientAttributionList]
    (
	  [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[DataDate]
      ,[MBI_ID]
      ,[PatientFirstName]
      ,[PatientLastName]
      ,[DOB]
      ,[Sex]
      ,[AttributedNPI]
      ,[ProviderName]
      ,[HCCRiskScore]
      ,[NEW_2021_Patient]
      ,[Patient_AWV_Last_12Month]
      ,[UnplannedIPVisit_12Month]
      ,[PatientIdentified_High_Risk]
      ,[PatientDiagnosedDiabetes]
	
	)
		
 VALUES  (
     @SrcFileName  ,
	 GETDATE(),
	--[CreateDate] [datetime] ,
	@CreateBy  ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@DataDate)
	END,	
	@MBI_ID ,
	@PatientFirstName ,
	@PatientLastName  ,
	CASE WHEN @DOB = ''
	THEN NULL
	ELSE CONVERT(DATE,@DOB)
	END,
	@Sex  ,
	@AttributedNPI  ,
	@ProviderName ,
	CASE WHEN 	@HCCRiskScore   = ''
	THEN NULL
	ELSE CONVERT(DECIMAL(5,2), 	@HCCRiskScore )
	END,
	@NEW_2021_Patient  ,
	CASE WHEN @Patient_AWV_Last_12Month  = '0'
	THEN NULL
	ELSE CONVERT(DATE, @Patient_AWV_Last_12Month)
	END,
	CASE WHEN @UnplannedIPVisit_12Month  = ''
	THEN NULL
	ELSE CONVERT(SMALLINT, @UnplannedIPVisit_12Month )
	END,
	@PatientIdentified_High_Risk  ,
	@PatientDiagnosedDiabetes  
   
)
END

END
