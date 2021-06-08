

CREATE PROCEDURE [adw].[z_sp_Get_ClaimMember]
	-- Add the parameters for the stored procedure here
	 @ClientMemberKey		VARCHAR(50)
	,@SeqClaimID		VARCHAR(50)
	--,@AttribEffDate			DATE 
AS
BEGIN
	SET NOCOUNT ON;
IF (@ClientMemberKey <> '0' AND @SeqClaimID = '0')
	SELECT 
		Ace_ID
		,ClientMemberKey
		,AltMemberID as AltClientMemberKey
		,CONCAT(FirstName,' ', LastName) as FullName
		,CONCAT(Gender, ' ', DOB) as Gender_DOB
		,CASE WHEN DOD = '1900-01-01' THEN 'N' ELSE CONCAT('Y','-',DOD) END as Expired
		,NPI as AttribNPI
		,TIN as AtrribTIN
		,cm.C_ClientMemberKey
		,cm.C_FullName
		,cm.C_Gender_DOB
	FROM [adw].[tmp_Active_Members] a
	--[adw].[2020_tvf_Get_ActiveMembersFull] (@AttribEffDate) a
	LEFT JOIN (
	SELECT DISTINCT SUBSCRIBER_ID as C_ClientMemberKey
		,[adi].[udf_ConvertToCamelCase] (CONCAT(MEMB_FIRST_NAME, ' ',MEMB_MIDDLE_INITIAL, ' ', MEMB_LAST_NAME)) as C_FullName
		,CONCAT(CASE WHEN Gender = 1 THEN 'M' WHEN Gender = 2 THEN 'F' ELSE 'U' END, ' ', CONVERT(date,DOB)) as C_Gender_DOB
	FROM [adw].[Claims_Member]
	) cm
	ON a.ClientMemberKey = cm.C_ClientMemberKey
	WHERE ClientMemberKey = @ClientMemberKey
ELSE IF (@SeqClaimID <> '0' AND @ClientMemberKey = '0')
	SELECT 
		Ace_ID
		,ClientMemberKey
		,AltMemberID as AltClientMemberKey
		,CONCAT(FirstName,' ', LastName) as FullName
		,CONCAT(Gender, ' ', DOB) as Gender_DOB
		,CASE WHEN DOD = '1900-01-01' THEN 'N' ELSE CONCAT('Y','-',DOD) END as Expired
		,NPI as AttribNPI
		,TIN as AtrribTIN
		,cm.C_ClientMemberKey
		,cm.C_FullName
		,cm.C_Gender_DOB
	FROM [adw].[tmp_Active_Members] a
	LEFT JOIN (
	SELECT DISTINCT SUBSCRIBER_ID as C_ClientMemberKey
		,[adi].[udf_ConvertToCamelCase] (CONCAT(MEMB_FIRST_NAME, ' ',MEMB_MIDDLE_INITIAL, ' ', MEMB_LAST_NAME)) as C_FullName
		,CONCAT(CASE WHEN Gender = 1 THEN 'M' WHEN Gender = 2 THEN 'F' ELSE 'U' END, ' ', CONVERT(date,DOB)) as C_Gender_DOB
	FROM [adw].[Claims_Member]
	) cm
	ON a.ClientMemberKey = cm.C_ClientMemberKey
	JOIN (
	SELECT DISTINCT SUBSCRIBER_ID as C_ClientMemberKey, SEQ_CLAIM_ID
		FROM [adw].[Claims_Headers]
	) ch
	ON cm.C_ClientMemberKey = ch.C_ClientMemberKey
	WHERE ch.SEQ_CLAIM_ID = @SeqClaimID
ELSE
	SELECT 
		Ace_ID
		,ClientMemberKey
		,AltMemberID as AltClientMemberKey
		,CONCAT(FirstName,' ', LastName) as FullName
		,CONCAT(Gender, ' ', DOB) as Gender_DOB
		,CASE WHEN DOD = '1900-01-01' THEN 'N' ELSE CONCAT('Y','-',DOD) END as Expired
		,NPI as AttribNPI
		,TIN as AtrribTIN
		,cm.C_ClientMemberKey
		,cm.C_FullName
		,cm.C_Gender_DOB
	FROM [adw].[tmp_Active_Members] a
	LEFT JOIN (
	SELECT DISTINCT SUBSCRIBER_ID as C_ClientMemberKey
		,[adi].[udf_ConvertToCamelCase] (CONCAT(MEMB_FIRST_NAME, ' ',MEMB_MIDDLE_INITIAL, ' ', MEMB_LAST_NAME)) as C_FullName
		,CONCAT(CASE WHEN Gender = 1 THEN 'M' WHEN Gender = 2 THEN 'F' ELSE 'U' END, ' ', CONVERT(date,DOB)) as C_Gender_DOB
	FROM [adw].[Claims_Member]
	) cm
	ON a.ClientMemberKey = cm.C_ClientMemberKey
	JOIN (
	SELECT DISTINCT SUBSCRIBER_ID as C_ClientMemberKey, SEQ_CLAIM_ID
		FROM [adw].[Claims_Headers]
	) ch
	ON cm.C_ClientMemberKey = ch.C_ClientMemberKey
	WHERE ch.SEQ_CLAIM_ID = @SeqClaimID
	AND ch.C_ClientMemberKey = @ClientMemberKey

END
/***
EXEC [adw].[sp_Get_ClaimMember] '1G08R12880C','D0285S92854263100'
***/


