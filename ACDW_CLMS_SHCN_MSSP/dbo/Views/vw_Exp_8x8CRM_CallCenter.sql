


CREATE VIEW [dbo].[vw_Exp_8x8CRM_CallCenter]
AS
	   /* view returns less than 50k rows and the top 100000 clause makes it run in less than 10 seconds. 
			 with distinct it takes > 10 minutes 
			 In order to fix this it will likely need to be converted to a SP 
				so we can use temp tables for the component pieces that coupld very fast
				*/
				/* The objective of the view is to get the records of all members all programs
				 for SHCN_MSSP*/
     SELECT  
	                        --top 10000--DISTINCT 
			AWV.RankNo as Rank_No,				 
            RTRIM(a.ClientMemberKey) AS MembersIDNumber, 
            Concat(RTRIM(a.FIRSTNAME), ' ', RTRIM(a.MiddleName)) [CustomersFirst_name], 
            a.lastname AS [CustomersLast_name], 
            '' AS [CustomersEmail], 
            RTRIM(LTRIM(a.MemberPhone)) AS [CustomersAlternative], --pp.PHONE_NUMBER
            --       ltrim(rtrim(a.Member_Home_phone)) AS [Customers.Voice], -- removing since we have only two fields for phone numbers in 8x8 system.
            ltrim(RTRIM(a.MemberCellPhone)) AS [CustomersVoice],   --m.phonenumber
            --      '' AS [FAX], -- not needed
            --    '' AS [Restrict Customer],  -- not needed
            CONVERT(VARCHAR(10), a.DOB, 101) AS DateOfBirth, 
            Concat(a.MemberHomeAddress, a.MemberHomeAddress1) AS PrimaryAddress, 
            a.MemberHomeCity, 
            a.MemberHomeState, 
            a.MEMBERHOMEZIP , 
            pdd.PrimaryAddress AS [SecondaryAddress], 
            pdd.PrimaryCity AS [SecondaryCity], 
            LTRIM(RTRIM(pdd.PrimaryState)) AS [ScondaryState], 
            pdd.PrimaryZip AS [SecondaryZip],  
            a.gender, 
            Phyd.PCP_Name AS PCPName, 
            Phyd.[PCPPhoneNumber] AS [PCPPhone], 
            a.Contract AS MCO, 
            CONVERT(VARCHAR(10), a.MEMBERCURRENTEFFECTIVEDATE, 101) AS MCOEffectiveDate,
            --    LBP.start_date AS Plan_start_date,
            a.LOB MCOProduct, 
            a.ProviderChapter AS LineOfBusiness, 
		
            PE.[PROGRAM_NAME] AS HEDISGap, 
            Concat(CONVERT(VARCHAR(10), a.MEMBERCURRENTEFFECTIVEDATE, 101), '-', CONVERT(VARCHAR(10), a.MemberCurrentExpirationDate, 101)) AS HedisDateRange, -- Convert into dates
            PE.PROGRAM_STATUS_NAME AS HEDISStatus, 
            a.CurrentAge, 
            a.LanguageCode AS [Language], 
            act.outcomenotes AS Comments, 
            CONVERT(VARCHAR(10), App.appointment_date, 101) AS [AppointmentDate], 
            '' AS CaregiverName,  --Confirm from DEE
			CASE when a.ClientRiskScoreLevel = '1.00' then 'Y'
			     ELSE 'N'END AS PatientidentifiedHighRisk
     
     FROM [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Dashboard_Membership] a 
	-- left join [ACDW_CLMS_SHCN_MSSP].[adi].[tmp_MemberListValidation] Risk_tbl on a.ClientMemberKey=Risk_tbl.MBI_ID
	-- 31534
	   left join(SELECT [ClientMemberKey],[RankNo]
	   FROM [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Dashboard_CY_AWV_Needed] ) AWV
	   ON a.ClientMemberKey=AWV.[ClientMemberKey]
	   LEFT JOIN (SELECT clientmemberkey,  phonenumber, ROW_NUMBER() OVER(PARTITION BY clientmemberkey ORDER BY loaddate DESC) AS marn
				FROM Acecaredw.adi.MPulsePhoneScrubbed a
				)   m ON m.clientmemberkey = a.ClientMemberKey  
				    and  m.marn = 1		  -- 85168
          LEFT JOIN (SELECT client_patient_id,                 start_date,                 end_date,                 program_status_name,                 program_name
				    FROM ahs_altus_prod.dbo.vw_ace_alt_pe
				    WHERE PROGRAM_STATUS_NAME NOT IN('Error', 'Expired', 'Term')
					   AND end_date >= '1/1/2019'
					   --AND YEAR(end_date) >= 2019 this is slow.					   
				) PE ON pe.client_patient_id = a.ClientMemberKey	   -- 60198
          LEFT JOIN (SELECT patient_id,                 CLIENT_PATIENT_ID
				    FROM ahs_altus_prod.dbo.PATIENT_DETAILS
				) PD ON PD.client_patient_id = a.ClientMemberKey  --106105
          LEFT JOIN (SELECT DISTINCT  PATIENT_ID,    LTRIM(RTRIM(Concat(REPLACE(REPLACE(ADDRESS_TEXT, CHAR(13), ''), CHAR(10), ''), ', '))) AS PrimaryAddress, 
				    REPLACE(REPLACE(CITY, CHAR(13), ''), CHAR(10), '') AS PrimaryCity, 
				    REPLACE(REPLACE(STATE, CHAR(13), ''), CHAR(10), '') AS PrimaryState, 
				    REPLACE(REPLACE(ZIP, CHAR(13), ''), CHAR(10), '') AS PrimaryZip
				    FROM ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS]
				    WHERE Deleted_on IS NULL
				) pdd ON PDD.PATIENT_ID = PD.PATIENT_ID	    -- 5501
          LEFT JOIN (SELECT DISTINCT patient_id, replace(PHONE_NUMBER, '-', '') AS Phone_number
				    FROM ahs_altus_prod.dbo.PATIENT_PHONE
				    WHERE IS_PREFERRED = 1
				) AS PP ON PD.PATIENT_ID = PP.PATIENT_ID    -- 3007
          LEFT JOIN(SELECT DISTINCT patient_id, PHYSICIAN_ID
				FROM ahs_altus_prod.[dbo].[PATIENT_PHYSICIAN]
				WHERE CARE_TEAM_ID = 2
				    AND IS_PCP = 1
				    AND END_DATE >= GETDATE()
				) PPhy ON PD.PATIENT_ID = PPhy.PATIENT_ID   --52524
          LEFT JOIN( SELECT DISTINCT Concat(FIRST_NAME, ' ', LAST_NAME) AS PCP_Name, Work_phone AS [PCPPhoneNumber], physician_id
				    FROM ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY
				) PhyD ON PhyD.physician_ID = PPhy.physician_ID	  --1695
          LEFT JOIN(SELECT a.OutcomeNotes, a.clientmemberkey, a.arn
				FROM
				    (   SELECT DISTINCT OutcomeNotes, clientmemberkey, ROW_NUMBER() OVER(PARTITION BY clientmemberkey ORDER BY activitycreateddate DESC) arn
				        FROM [ACECAREDW].[dbo].[tmp_Ahs_PatientActivities]
				        WHERE OutcomeNotes IS NOT NULL
				    ) a
				WHERE a.arn = 1
				) act ON act.clientmemberkey = a.ClientMemberKey --AND act.arn = 1	   --29797
          LEFT JOIN (SELECT a.PATIENT_ID, a.APPOINTMENT_DATE, a.arn
				    FROM (
						  SELECT PATIENT_ID, APPOINTMENT_DATE, ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY appointment_date DESC) arn
						  FROM ahs_altus_prod.dbo.appointment
						  WHERE APPOINTMENT_DATE IS NOT NULL
					   ) a
				    WHERE a.arn = 1		   
				) app ON app.PATIENT_ID = pd.PATIENT_ID	    --16622
				    AND app.appointment_date IS NOT NULL
			 where a.active = 1 AND a.DOD ='1900-01-01'
			 --and a.ClientMemberKey='3E85T27JK55'
			 

