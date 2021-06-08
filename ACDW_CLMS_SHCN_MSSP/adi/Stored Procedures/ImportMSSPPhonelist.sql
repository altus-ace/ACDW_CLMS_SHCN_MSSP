-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPhonelist]
    @SrcFileName [varchar](100) NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	@DataDate varchar(10) NULL,
	@incoming_custacc [varchar](50) NULL,
	@incoming_fname [varchar](20) NULL,
	@incoming_mname [varchar](20) NULL,
	@incoming_lastname [varchar](20) NULL,
	@incoming_fullname [varchar](100) NULL,
	@incoming_suffix [varchar](10) NULL,
	@incoming_ssn [varchar](10) NULL,
	@incoming_address1 [varchar](100) NULL,
	@incoming_address2 [varchar](100) NULL,
    @incoming_city [varchar](100) NULL,
    @incoming_state [varchar](50) NULL,
    @incoming_zip [varchar](15) NULL,
	@incoming_dob vARCHAR(10) NULL,
	@incoming_phone varchar(20) NULL,
	@incoming_client varchar(50) NULL,
	@subj_phone varchar(20) NULL,
    @subj_phone_listing_name varchar(50) NULL,
    @subj_phone_possible_relationship varchar(20) NULL,
    @subj_date_first_seen VARCHAR(10) NULL,
    @subj_date_last_seen VARCHAR(10) NULL,
	@subj_phone_type varchar(50) NULL,
	@subj_phone_duplicate_to_input_flag varchar(10) NULL,
    @subj_phone_line_type varchar(50) NULL,
	@subj_phone_ported_date varchar(10) NULL,
	@subj_phone2 VARCHAR(50) NULL,
	@subj_phone_listing_name2 varchar(50) NULL,
	@subj_phone_possible_relationship2 varchar(50), 
	@subj_date_first_seen2 VARCHAR(10) NULL,
    @subj_date_last_seen2 VARCHAR(10) NULL,
	@subj_phone_type2 varchar(20) NULL,
	@subj_phone_duplicate_to_input_flag2 varchar(20) NULL ,
	@subj_phone_line_type2 VARCHAR(20) NULL,
	@subj_phone_ported_date2 VARCHAR(10) NULL,
	@subj_phone3 varchar(50) NULL,
    @subj_phone_listing_name3 varchar(50) NULL,
	@subj_phone_possible_relationship3 varchar(50) NULL, 
	@subj_date_first_seen3 VARCHAR(10) NULL,
	@subj_date_last_seen3 VARCHAR(10) NULL,
	@subj_phone_type3 varchar(50) NULL,
    @subj_phone_duplicate_to_input_flag3 varchar(50) NULL,
	@subj_phone_line_type3 varchar(50) NULL,
	@subj_phone_ported_date3 VARCHAR(10) NULL	

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)

	
    INSERT INTO [adi].[Steward_MSSPPhonelist]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,

	[incoming_custacc] ,
	[incoming_fname] ,
	[incoming_mname] ,
	[incoming_lastname] ,
	[incoming_fullname] ,
	[incoming_suffix] ,
	[incoming_ssn] ,
	[incoming_address1] ,
	[incoming_address2] ,
    [incoming_city] ,
    [incoming_state] ,
    [incoming_zip] ,
	[incoming_dob] ,
	[incoming_phone] ,
	[incoming_client] ,
	[subj_phone] ,
    [subj_phone_listing_name] ,
    [subj_phone_possible_relationship] ,
    [subj_date_first_seen] ,
    [subj_date_last_seen] ,
	[subj_phone_type] ,
	[subj_phone_duplicate_to_input_flag] ,
    [subj_phone_line_type] ,
	[subj_phone_ported_date] ,
	[subj_phone2],
	[subj_phone_listing_name2] ,
	[subj_phone_possible_relationship2] , 
	[subj_date_first_seen2] ,
    [subj_date_last_seen2] ,
	[subj_phone_type2] ,
	[subj_phone_duplicate_to_input_flag2] ,
	[subj_phone_line_type2] ,
	[subj_phone_ported_date2],
	[subj_phone3] ,
    [subj_phone_listing_name3] ,
	[subj_phone_possible_relationship3] , 
	[subj_date_first_seen3] ,
	[subj_date_last_seen3] ,
	[subj_phone_type3] ,
    [subj_phone_duplicate_to_input_flag3] ,
	[subj_phone_line_type3] ,
	[subj_phone_ported_date3] 

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
	ELSE CONVERT(DATE,@DataDate)
	END ,

	@incoming_custacc ,
	@incoming_fname ,
	@incoming_mname ,
	@incoming_lastname ,
	@incoming_fullname ,
	@incoming_suffix ,
	@incoming_ssn ,
	@incoming_address1 ,
	@incoming_address2 ,
    @incoming_city ,
    @incoming_state ,
    @incoming_zip ,

	CASE WHEN @incoming_dob = ''
	THEN NULL
	ELSE CONVERT(DATE,@incoming_dob)
	END ,
	@incoming_phone ,
	@incoming_client ,
	@subj_phone ,
    @subj_phone_listing_name ,
    @subj_phone_possible_relationship ,
	@subj_date_first_seen,
 --   CASE WHEN @subj_date_first_seen = '' OR LEN(@subj_date_first_seen) = 6
	--THEN NULL
	--ELSE CONVERT(DATE,@subj_date_first_seen )
	--END ,
	--CASE WHEN  @subj_date_last_seen = ''OR LEN(@subj_date_last_seen) = 6
	--THEN NULL
	--ELSE CONVERT(DATE, @subj_date_last_seen)
	--END ,
   @subj_date_last_seen,
	@subj_phone_type ,
	@subj_phone_duplicate_to_input_flag ,
    @subj_phone_line_type ,
	@subj_phone_ported_date,
	--CASE WHEN @subj_phone_ported_date = '' OR @subj_phone_ported_date = '0'
	--THEN NULL
	--ELSE CONVERT(DATE, @subj_phone_ported_date)
	--END ,
	@subj_phone2 ,
	@subj_phone_listing_name2 ,
	@subj_phone_possible_relationship2 , 
	 @subj_date_first_seen2 ,

	--CASE WHEN  @subj_date_first_seen2 = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @subj_date_first_seen2)
	--END ,
	--CASE WHEN     @subj_date_last_seen2 = ''
	--THEN NULL
	--ELSE CONVERT(DATE,    @subj_date_last_seen2)
	--END , 
    @subj_date_last_seen2,
	@subj_phone_type2 ,
	@subj_phone_duplicate_to_input_flag2  ,
	@subj_phone_line_type2 ,
	--CASE WHEN @subj_phone_ported_date2  = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @subj_phone_ported_date2 )
	--END , 
   @subj_phone_ported_date2,
	@subj_phone3 ,
    @subj_phone_listing_name3 ,
	@subj_phone_possible_relationship3 , 
	@subj_date_first_seen3,
	--CASE WHEN @subj_date_first_seen3  = ''
	--THEN NULL
	--ELSE CONVERT(DATE,@subj_date_first_seen3)
	--END ,
	--CASE WHEN @subj_date_last_seen3   = ''
	--THEN NULL
	--ELSE CONVERT(DATE,@subj_date_last_seen3)
	--END ,
	@subj_date_last_seen3,
	@subj_phone_type3 ,
    @subj_phone_duplicate_to_input_flag3 ,
	@subj_phone_line_type3 ,
	--CASE WHEN 	@subj_phone_ported_date3  = ''
	--THEN NULL
	--ELSE CONVERT(DATE, 	@subj_phone_ported_date3)
	--END   
	@subj_phone_ported_date3        
)

END


