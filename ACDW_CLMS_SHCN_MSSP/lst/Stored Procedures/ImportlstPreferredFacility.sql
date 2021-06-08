
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [lst].[ImportlstPreferredFacility]
   -- CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	--[LoadDate] [date] ,
	@DataDate varchar(10),
	@SourceJobName [varchar](50),
	@ClientKey varchar(5),
	@FacilityName [varchar](50) ,
	@FacilityType [varchar](10) ,
	@State [varchar](35) ,
	@Region [varchar](35),
	@NPI [varchar](10) ,
	@ACTIVE [char](1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    INSERT INTO [lst].[lstPreferredFacility]
    (
	   [CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[LoadDate]
      ,[DataDate]
      ,[SourceJobName]
     
      ,[ClientKey]
      ,[FacilityName]
      ,[FacilityType]
      ,[State]
      ,[Region]
      ,[NPI]
      ,[ACTIVE]
      ,[EffectiveDate]
      ,[ExpirationDate]
	
	)
		
 VALUES  (
     GETDATE(),
      -- CreatedDate] [datetime] NOT NULL,
	@CreatedBy,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	GETDATE(),
	--[LoadDate] [date] ,
	@DataDate ,
	@SourceJobName ,
	@ClientKey ,
	@FacilityName  ,
	@FacilityType  ,
	@State  ,
	@Region ,
	@NPI  ,
	@ACTIVE,
	@EffectiveDate ,
	@ExpirationDate  
          
  
)

 END
