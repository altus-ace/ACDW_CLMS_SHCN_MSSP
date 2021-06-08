

CREATE PROCEDURE [adw].[z_CalcfctADWVisits]
	(
	@ClientKeyID	VARCHAR(2),
	@RunDate			DATE,
	@KPIStartDate	DATE,
	@KPIEndDate		DATE
	)
AS    
BEGIN
    SET NOCOUNT ON;

DECLARE @PrevYearDate [Date] = ( SELECT CAST(DATEADD(year, -1, @RunDate) AS DATE) )

INSERT INTO [adw].[FctAWVVisits]
         (
          [SrcFileName]
         ,[LoadDate]
         ,[DataDate]
         ,[ClientKey]
         ,[ClientMemberKey]
         ,[EffectiveAsOfDate]
         ,[ClaimID]
         ,[PrimaryServiceDate]
		   ,[AWVType]
		   ,[AWVCode]
         ,[SVCProviderNPI]
         ,[SVCProviderName]
         ,[SVCProviderSpecialty]
		   ,[AttribNPI]
		   ,[AttribTIN])

	SELECT  CONCAT('[adw].[CalcfctAWVVisits] ',@KPIStartDate,'-',@KPIEndDate) as [SrcFileName]
			,GETDATE()		as [LoadDate]
			,@RunDate		as DataDate
			,a.ClientKey
			,a.[ClientMemberKey]
			,@RunDate		as EffectiveAsOfDate
			,b.SEQ_CLAIM_ID
			,b.PRIMARY_SVC_DATE
			,b.AWV_TYPE
			,b.AWV_CODE
			,b.SVC_PROV_NPI
			,svcnpi.LegalBusinessName	as LBN
			,b.PROV_SPEC
			,a.NPI AS AttribNPI
			,a.PcpPracticeTIN AS AttribTIN
		FROM [adw].[2020_tvf_Get_ActiveMembersFull]	(@RunDate) a
		--LEFT JOIN [adw].[2020_tvf_Get_ActiveMembersFull]	(@PrevYearDate) c			-- Member was active in Prev Year
		--	ON	a.ClientKey = c.ClientKey
		--	AND a.ClientMemberKey = c.ClientMemberKey
		JOIN [adw].[2020_tvf_Get_AWVisits] (@KPIStartDate,@KPIEndDate,@RunDate) b
			ON a.[ClientMemberKey] = b.SUBSCRIBER_ID
		LEFT JOIN adw.[2020_tvf_Get_DataFromNPPES] (getdate()) svcnpi
			ON b.SVC_PROV_NPI = svcnpi.NPI

WAITFOR DELAY '00:00:02'; 
UPDATE [adw].[FctAWVVisits]
	SET LastAWVKey =  lstawv.FctAWVVisitsSkey,
		LastAWVDate = lstawv.PrimaryServiceDate,
		LastAWVNPI =  lstawv.SVCProviderNPI
	FROM [adw].[FctAWVVisits] a, (SELECT ClientMemberKey, FctAWVVisitsSkey, PrimaryServiceDate, SVCProviderNPI FROM [adw].[2020_tvf_Get_MembersLastAWVisit] (getdate())) lstawv
	WHERE a.ClientMemberKey = lstawv.ClientMemberKey
	
END;												

/***
EXEC [adw].[CalcfctADWVisits] 16,'10-14-2020','01-01-2020','03-31-2020'

SELECT *
FROM [adw].[FctAWVVisits]
WHERE EffectiveAsOfDate = '10-14-2020'
***/

