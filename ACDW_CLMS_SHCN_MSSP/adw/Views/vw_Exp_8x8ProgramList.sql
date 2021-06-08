
CREATE VIEW [adw].[vw_Exp_8x8ProgramList]
AS																							 
    SELECT --, Ahs_PrefPhone.Phone_number	
	---TOP 2    														
	     Mbr.ClientMemberKey			    AS [MembersIDNumber]											
	   , Mbr.FirstName				    AS [CustomersFirst_name]										
	   , Mbr.LastName				    AS [CustomersLast_name]										
	   , 'add email to fct' 			    AS [CustomersEmail]											
        , concat(1,Mbr.MemberCellPhone)			    AS [CustomersAlternative]										
	   ,  concat(1,Mbr.MemberHomePhone)			    AS [CustomersVoice]											
	   , Mbr.DOB					    AS [DateOfBirth]											
        , Mbr.MemberHomeAddress + ' ' + Mbr.MemberHomeAddress1 AS [PrimaryAddress]							
	   , Mbr.MemberHomeCity			    AS [MemberHomeCity]											
	   , Mbr.MemberHomeState			    AS [MemberHomeState]											
	   , Mbr.MemberHomeZip			    AS [MEMBERHOMEZIP]											
        , AHS_PrefAddress.PrimaryAddress    AS [SecondaryAddress]										
	   , AHS_PrefAddress.PrimaryCity	    AS [SecondaryCity]											
	   , AHS_PrefAddress.PrimaryState	    AS [ScondaryState]											
	   , AHS_PrefAddress.PrimaryZip	    AS [SecondaryZip]											
        , Mbr.gender				    AS [gender]
        , PcpDetails.PCP_Name			    AS [PCPName]
        ,  concat(1,PcpDetails.PcpPhoneNumber)	    AS [PCPPhone]
	   , Mbr.Contract				    AS [MCO]
        , CONVERT(VARCHAR(10), Mbr.MemberCurrentEffectiveDate, 101) AS [MCOEffectiveDate]	   
	   , mbr.LOB		   			    AS MCOProduct
	   , mbr.ProviderChapter			    AS LineOfBusiness
        , ProgEnr.ProgramName			    AS HEDISGap
        --, Concat(CONVERT(VARCHAR(10), Mbr.MemberCurrentEffectiveDate, 101), '-', CONVERT(VARCHAR(10), Mbr.MemberCurrentExpirationDate, 101)) AS HedisDateRange 
	   , Concat(CONVERT(VARCHAR(10), ProgEnr.EnrollmentStartDate, 101), '-', CONVERT(VARCHAR(10), ProgEnr.EnrollmentStopDate, 101)) AS HedisDateRange 
        , ProgEnr.ProgramStatus		    AS HEDISStatus
        , Mbr.CurrentAge				    AS [Age]
        , Mbr.LanguageCode			    AS [Language]
        --, Activities.outcomenotes		    AS Comments	   
        --, CONVERT(VARCHAR(10), App.AppointmentDate, 101)				 AS [AppointmentDate]
        , ''						    AS CaregiverName  --Confirm from DEE
        , CASE WHEN (Mbr.ClientRiskScoreLevel = 1.00) then 'Y'ELSE 'N'END	 AS PatientidentifiedHighRisk
	   , Ranking.RankNo AS Rank
    FROM adw.MbrProgramEnrollments ProgEnr
        JOIN adw.vw_Dashboard_Membership Mbr
    	   ON ProgEnr.ClientMemberKey = Mbr.ClientMemberKey
        LEFT JOIN (SELECT patient_id, CLIENT_PATIENT_ID FROM ahs_altus_prod.dbo.PATIENT_DETAILS) AhsMemberToAceMember 
    	   ON AhsMemberToAceMember.client_patient_id = Mbr.ClientMemberKey  -- Link AHS Member ID to ACE ClientMemberKey
        LEFT JOIN (SELECT DISTINCT  PATIENT_ID,    LTRIM(RTRIM(Concat(REPLACE(REPLACE(ADDRESS_TEXT, CHAR(13), ''), CHAR(10), ''), ', '))) AS PrimaryAddress, 
    				    REPLACE(REPLACE(CITY, CHAR(13), ''), CHAR(10), '') AS PrimaryCity, REPLACE(REPLACE(STATE, CHAR(13), ''), CHAR(10), '') AS PrimaryState, 
    				    REPLACE(REPLACE(ZIP, CHAR(13), ''), CHAR(10), '') AS PrimaryZip
    			 FROM ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS]
    			 WHERE Deleted_on IS NULL) AHS_PrefAddress 
    	   ON AHS_PrefAddress.PATIENT_ID = AhsMemberToAceMember.PATIENT_ID
        LEFT JOIN (SELECT DISTINCT patient_id, replace(PHONE_NUMBER, '-', '') AS Phone_number 
    			 FROM ahs_altus_prod.dbo.PATIENT_PHONE 
    			 WHERE IS_PREFERRED = 1) AS Ahs_PrefPhone 
    		  ON AhsMemberToAceMember.PATIENT_ID = Ahs_PrefPhone.PATIENT_ID   
        LEFT JOIN(SELECT DISTINCT PatPhys.patient_id, Concat(PhysDemo.FIRST_NAME, ' ', PhysDemo.LAST_NAME) AS PCP_Name, PhysDemo.Work_phone AS PCPPhoneNumber, PhysDemo.physician_id
    			 FROM ahs_altus_prod.[dbo].[PATIENT_PHYSICIAN] PatPhys
    				LEFT JOIN  ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY  PhysDemo
    				    ON PhysDemo.physician_ID = PatPhys.physician_ID	 
    			 WHERE PatPhys.CARE_TEAM_ID = 2 AND PatPhys.IS_PCP = 1 AND PatPhys.END_DATE >= GETDATE()	) PcpDetails 
    			 ON PcpDetails.PATIENT_ID = AhsMemberToAceMember.PATIENT_ID  
        LEFT JOIN(SELECT srcActivities.OutcomeNotes, srcActivities.clientmemberkey, srcActivities.arn
    				FROM(SELECT DISTINCT mbrAct.OutcomeNotes, mbrAct.clientmemberkey, ROW_NUMBER() OVER(PARTITION BY clientmemberkey ORDER BY activitycreateddate DESC) arn
    				        FROM adw.mbrActivities mbrAct
    				        WHERE OutcomeNotes IS NOT NULL) srcActivities
    				WHERE srcActivities.arn = 1 ) Activities
    			 ON Activities.clientmemberkey = Mbr.ClientMemberKey 
	   LEFT JOIN (SELECT Appts.ClientMemberKey, Appts.AppointmentDate, Appts.arn
    				    FROM (SELECT MbrAppts.ClientMemberKey, MbrAppts.AppointmentDate, ROW_NUMBER() OVER(PARTITION BY MbrAppts.ClientMemberKey ORDER BY MbrAppts.AppointmentDate DESC) arn
    						  FROM adw.MbrAppointments MbrAppts
    						  WHERE MbrAppts.AppointmentDate IS NOT NULL) Appts
    				    WHERE Appts.arn = 1) app 
    			 ON app.ClientMemberKey = Mbr.ClientMemberKey    AND app.AppointmentDate IS NOT NULL
	   LEFT JOIN (SELECT AWV.RankNo, awv.ClientMemberKey
				    FROM adw.vw_Dashboard_CY_AWV_Needed AWV) Ranking
				    ON mbr.ClientMemberKey = ranking.ClientMemberKey 
    where Mbr.active = 1 
        AND Mbr.DOD ='1900-01-01' -- Has not expired
