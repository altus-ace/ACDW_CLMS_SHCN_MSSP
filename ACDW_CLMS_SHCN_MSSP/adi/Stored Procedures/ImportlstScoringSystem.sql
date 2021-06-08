-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportlstScoringSystem]
    @ClientKey varchar(5),
	@LOB [varchar](20) ,
	@LOB_State [varchar](10),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@Active varchar(5),
	@ScoringType [varchar](10),
	@P4qIndicator [char](1) ,
	@MeasureID [varchar](20) ,
	@MeasureDesc [varchar](80) ,
	@Score_A varchar(10),
	@Score_B varchar(10),
	@Score_C varchar(10),
	@Score_D varchar(10),
	@Score_E varchar(10),
	@Weight_1 varchar(5),
	@Weight_2 varchar(5),
	@Weight_3 varchar(5),
	@Weight_4 varchar(5),
	@Weight_5 varchar(5),
	@AceQmWeight varchar(5),
	@AceCmWeight varchar(5),
	@Pq4BaseValue varchar(10),
	@CreatedDate varchar(10),
	@CreatedBy [varchar](50) ,
	@LastUpdatedDate varchar(10) ,
	@LastUpdatedBy [varchar](50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)
	DECLARE @ScoreAIsMoney tinyint, @ScoreReformat varchar(10) ,@ScoreAIsPercent tinyint, 
	@ScoreAHasCommma tinyint, @ScoreDecimal decimal  
    SET @ScoreAIsMoney = CHARINDEX('$', @Score_A)
	SET @ScoreAIsPercent = CHARINDEX('%', @Score_A) 
	SET @ScoreAHasCommma = CHARINDEX(',', @Score_A) 
	If @ScoreAIsPercent > 0 
	  SET @ScoreReformat = convert(varchar, CONVERT(numeric(9,3), REPLACE(@Score_A, '%', ''))/100) 
    ELSE IF @ScoreAIsMoney > 0
	  SET @ScoreReformat = REPLACE(@Score_A, '$', '')
    ELSE if @ScoreAHasCommma > 0
	  SET @ScoreReformat = REPLACE(@Score_A, ',', '')  
    ELSE 
	  SET @ScoreReformat = @Score_A 

    INSERT INTO [lst].[lstScoringSystem]
    (
	   [ClientKey]
      ,[LOB]
      ,[LOB_State]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[Active]
      ,[ScoringType]
      ,[P4qIndicator]
      ,[MeasureID]
      ,[MeasureDesc]
      ,[Score_A]
      ,[Score_B]
      ,[Score_C]
      ,[Score_D]
      ,[Score_E]
      ,[Weight_1]
      ,[Weight_2]
      ,[Weight_3]
      ,[Weight_4]
      ,[Weight_5]
      ,[AceQmWeight]
      ,[AceCmWeight]
      ,[Pq4BaseValue]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
	)
		
 VALUES  (

    @ClientKey ,
	@LOB  ,
	@LOB_State ,
	CASE WHEN @EffectiveDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @EffectiveDate)
	END,
    CASE WHEN @ExpirationDate  = ''
	THEN NULL
	ELSE CONVERT(DATE, @ExpirationDate )
	END,
    CASE WHEN @Active   = ''
	THEN 1
	ELSE CONVERT(tinyint, @Active)
	END,
	@ScoringType ,
	CASE WHEN @P4qIndicator = '' 
    THEN 'N'
	ELSE @P4qIndicator 
	END,
	@MeasureID ,
	LTRIM(@MeasureDesc) ,

    CASE WHEN @ScoreReformat = ''
	THEN NULL
	ELSE CONVERT(numeric(9,3) ,@ScoreReformat)
	END,	
	CASE WHEN @Score_B = ''
	THEN NULL
	ELSE CONVERT(numeric(9,3) ,@Score_B)
	END,	
    CASE WHEN @Score_C = ''
	THEN NULL
	ELSE CONVERT(numeric(9,3) ,@Score_C)
	END,	
    CASE WHEN @Score_D = ''
	THEN NULL
	ELSE CONVERT(numeric(9,3) ,@Score_D)
	END,
	CASE WHEN @Score_E = ''
	THEN NULL
	ELSE CONVERT(numeric(9,3) ,@Score_E)
	END,	
	CASE WHEN @Weight_1  = ''
	THEN NULL
	ELSE CONVERT(int ,@Weight_1 )
	END,	
	CASE WHEN @Weight_2  = ''
	THEN NULL
	ELSE CONVERT(int ,@Weight_2)
	END,		
	CASE WHEN @Weight_3  = ''
	THEN NULL
	ELSE CONVERT(int ,@Weight_3)
	END,
	CASE WHEN @Weight_4  = ''
	THEN NULL
	ELSE CONVERT(int ,@Weight_4)
	END,
	CASE WHEN @Weight_5  = ''
	THEN NULL
	ELSE CONVERT(int ,@Weight_5)
	END,
	@AceQmWeight ,
	@AceCmWeight ,
	CASE WHEN @Pq4BaseValue  = ''
	THEN NULL
	ELSE CONVERT(int ,@Pq4BaseValue)
	END,
	GETDATE() ,
	@CreatedBy ,
	GETDATE() ,
	@LastUpdatedBy 	    
)

END


--SELECT CONVERT(numeric(9,3), REPLACE('6%','%',''))/100;


--SELECT REPLACE(
--REPLACE(REPLACE('500.00%', '$', ''), '%',''), ',','') 

--SELECT convert(numeric(9,3),
--
--select convert(varchar, 
---select CONVERT(numeric(9,3), REPLACE('14.9%', '%', ''))/100 

