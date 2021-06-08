


CREATE PROCEDURE [adw].[sp_Get_tmp_AHRByMember]
	(
	@ClientMemberKey	VARCHAR(50)
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 'Pop',*    FROM [dbo].[tmp_AHR_HL7_Population]			WHERE SUBSCRIBER_ID   = @ClientMemberKey ;
	SELECT 'Header',* FROM [dbo].[tmp_AHR_HL7_Report_Header]		WHERE SubscriberNo    = @ClientMemberKey ;
	SELECT 'Gaps',*   FROM [dbo].[tmp_AHR_HL7_Report_Detail_CG]		WHERE SUBSCRIBER_ID   = @ClientMemberKey ;
	SELECT 'Dx',*     FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]		WHERE SUBSCRIBER_ID   = @ClientMemberKey ;
	SELECT 'IP',*     FROM [dbo].[tmp_AHR_HL7_Report_Detail_IP]		WHERE SUBSCRIBER_ID   = @ClientMemberKey ;
	SELECT 'ER',*     FROM [dbo].[tmp_AHR_HL7_Report_Detail_ER]		WHERE SUBSCRIBER_ID   = @ClientMemberKey ;
	SELECT 'Phy',*	  FROM [dbo].[tmp_AHR_HL7_Report_Detail_Phy]	WHERE ClientMemberKey = @ClientMemberKey ;
	SELECT 'Rx',*	  FROM [dbo].[tmp_AHR_HL7_Report_Detail_Rx]		WHERE SUBSCRIBER_ID   = @ClientMemberKey ;

END

/***
EXEC [adw].[sp_Get_tmp_AHRByMember] '8UT9WA3NR26'

-- Preview Members with a record in each of the table
CREATE TABLE #tmp_pop (SUBSCRIBER_ID VARCHAR(50))
INSERT INTO #tmp_pop (SUBSCRIBER_ID)
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Population]		INTERSECT		
SELECT DISTINCT SubscriberNo     FROM [dbo].[tmp_AHR_HL7_Report_Header]		INTERSECT		
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Report_Detail_CG]	INTERSECT		
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]	INTERSECT		
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Report_Detail_IP]	INTERSECT		
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Report_Detail_ER]	INTERSECT		
SELECT DISTINCT ClientMemberKey  FROM [dbo].[tmp_AHR_HL7_Report_Detail_Phy]	INTERSECT		
SELECT DISTINCT SUBSCRIBER_ID    FROM [dbo].[tmp_AHR_HL7_Report_Detail_Rx]
--
SELECT PCP, COUNT(ID) as Cnt FROM [dbo].[tmp_AHR_HL7_Report_Header] WHERE SubscriberNo IN 
	(SELECT * FROM #tmp_pop)
	GROUP BY PCP
SELECT * FROM [dbo].[tmp_AHR_HL7_Report_Header] 
	WHERE SubscriberNo IN 	(SELECT * FROM #tmp_pop)
	AND PCP = '1669415279'
***/		