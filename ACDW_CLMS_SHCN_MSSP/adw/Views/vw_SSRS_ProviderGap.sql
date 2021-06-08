



CREATE VIEW [adw].[vw_SSRS_ProviderGap]
AS
  -- OBJECTIVE: Gets care gaps for a provider for the Current month (active members only, with current PCP etc)
 SELECT src.[ClientMemberKey],	 	   
            src.ahr_qm_desc AS [QmMsr_Tb_Desc], 		  
            src.[QmMsrId], 
            src.[QMDate], 
            src.LOB, 
            src.QM_DESC AS MeasureDesc,
            CASE
                WHEN src.[QmCntCat] = 'DEN'
                THEN 1
                ELSE 0
            END AS MbrDEN,
            CASE
                WHEN src.[QmCntCat] = 'NUM'
                THEN 1
                ELSE 0
            END AS MbrNUM,
            CASE
                WHEN src.[QmCntCat] = 'COP'
                THEN 1
                ELSE 0
            END AS MbrCOP, 
            src.[AGE], 
            src.[PCP_PRACTICE_TIN], 
            src.[PCP_PRACTICE_NAME], 		  
		  src.DATE_OF_BIRTH,
		  src.GENDER,
		  src.MEMBER_HOME_PHONE,		   
		  src.PCP_NAME, 
		  src.NPI,
		  src.[PCP_PHONE], 		  
		  src.[MEMBER NAME],
            src.NPI AS PCP_NPI,
		 src.MemberHomeAddress  --Concatenanted fileds of all address --uncomment for next run
		, src.MemberMailingAddress --Concatenanted fileds of all address --uncomment for next run
          ,  CASE
                WHEN src.MeasureID IS NULL
                THEN 'Not Contracted'
                ELSE 'Contracted'
            END AS 'Contract?',
            CASE
                WHEN src.ClientMemberKey IS NULL
                THEN 'NOT ACE_MBR'
                ELSE 'ACE MBR'
            END AS 'ACE MBR?', 
            YEAR(src.ExpirationDate) AS ExpirationYear, 
            src.Score_A / 100 AS Target, 
            src.clientshortname AS Client, 
            src.[Zone],
		  src.ClientKey
     FROM(SELECT DISTINCT
                QM.[ClientMemberKey],
                QM.clientkey, 
                QM.[QmMsrId], 
                --QM.[QmCntCat], 
			 CASE WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'NUM') THEN 'COP'
						WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'COP') THEN 'NUM'
						ELSE qm.QmCntCat END qmCntCat,
                QM.[QMDate],
                Client.CS_Export_LobName LOB, 
                LQM.QM, 
                LQM.QM_DESC, 
				--CASE WHEN QM = 'ACE_ACO_FS' THEN 'Fall Risk Screening'
				--    WHEN QM = 'ACE_ACO_TSC' THEN 'Tobacco Screening and Cessation Intervention'
				--    WHEN QM = 'ACE_ACO_SCD' THEN 'Screening for Depression and Follow-Up Plan '
				--    ELSE lqm.ahr_qm_desc END AS ahr_qm_desc,
				CASE WHEN QM = 'ACE_ACO_FS' THEN 'Fall Risk Screening'
                    WHEN QM = 'ACE_ACO_TSC' THEN 'Tobacco Screening and Cessation Intervention'
                    WHEN QM = 'ACE_ACO_SCD' THEN 'Screening for Depression and Follow-Up Plan '
                    when qm = 'ACE_HEDIS_ACO_CDC_9'THEN 'Diabetes: Hemoglobin A1c Control (<=9)'
                    WHEN qm = 'ACE_ACO_FLU' THEN 'Preventive Care and Screening: Influenza Immunization'
                    WHEN qm = 'ACE_HEDIS_ACO_CBP' THEN 'Controlling High Blood Pressure (<140/90)'
                    WHEN qm = 'ACE_HEDIS_ACO_BCS' THEN 'Breast Cancer Screening'
                    WHEN qm = 'ACE_HEDIS_ACO_COL' THEN 'Colorectal Cancer Screening'
                    WHEN qm='ACE_NQF_DPR12' THEN    'Depression Remission at Twelve Months: 12 years and older'
                    WHEN qm = 'ACE_CMS_SPC' THEN 'Statin Therapy for the Prevention and Treatment of Cardiovascular Disease'
				ELSE lqm.ahr_qm_desc END AS ahr_qm_desc,
		          -- lqm.ahr_qm_desc , remove after 8/17 run of ahr
                ActiveMembers.AvgAge AS AGE,
			 ActiveMembers.DOB AS DATE_OF_BIRTH,
			 ActiveMembers.GENDER,
			 ActiveMembers.MemberPhone AS MEMBER_HOME_PHONE,
                ActiveMembers.PcpPracticeTIN AS [PCP_PRACTICE_TIN], 
                ActiveMembers.ProviderPracticeName AS [PCP_PRACTICE_NAME], 
			 ActiveMembers.ProviderLastName + ', ' + ProviderFirstName PCP_NAME, 
                ActiveMembers.NPI,
                ActiveMembers.ProviderPhone AS [PCP_PHONE],                 
			 ActiveMembers.LastName + ', ' + ActiveMembers.FirstName AS 'MEMBER NAME',
				 MemberHomeAddress + ', ' + ActiveMembers.MemberHomeAddress1 + ' ' + ActiveMembers.MemberHomeCity + ', ' + ActiveMembers.MemberHomeState AS MemberHomeAddress
				, ActiveMembers.MemberMailingAddress + ', ' + ActiveMembers.MemberMailingAddress1  + ' ' +  
				ActiveMembers.MemberMailingCity + ', ' + ActiveMembers.MemberMailingState + ', ' + ActiveMembers.MemberMailingZip AS MemberMailingAddress
			    , CareOpToPlan.MeasureID,                 
                lstScore.ExpirationDate, 
                lstScore.Score_A,
                Client.ClientShortName,			 			 
                ActiveMembers.ProviderChapter AS [Zone]			 
			 --ActiveMembers.ProviderPOD AS [Zone]			 	   
	   FROM [adw].[QM_ResultByMember_History]  QM 
	       JOIN adw.[vw_Dashboard_Membership] ActiveMembers
	   	   ON QM.ClientMemberKey = ActiveMembers.ClientMemberKey 
			 AND ActiveMembers.clientKey = 16
			 AND QMDate BETWEEN ActiveMembers.RwEffectiveDate AND ActiveMembers.RwExpirationDate
	       JOIN lst.List_Client Client ON Client.ClientKey = qm.ClientKey
	       JOIN ACEMasterData.lst.LIST_QM_Mapping LQM 
	   	   ON LQM.QM = QM.[QmMsrId]
	   		  AND QM.QMDate BETWEEN LQM.EffectiveDate AND LQM.ExpirationDate	       
	       JOIN ACEMasterData.[lst].[lstCareOpToPlan] CareOpToPlan --where active = 'Y' and clientkey = 16 order by measureID, csPlan
	   		  ON QM.[QmMsrId] = CareOpToPlan.[MeasureID] 
	   		  AND ActiveMembers.ProviderChapter = 'Tx - ' + CareOpToPlan.CsPlan  /* this is dumb but it fixes the view for now GK/JK : REMOVED FOR TESTING: 5/6/2021*/
			 -- AND ActiveMembers.ProviderChapter = CareOpToPlan.CsPlan  
	   		  AND CareOpToPlan.ACTIVE = 'Y'
	   		  AND qm.QMDate BETWEEN CareOpToPlan.EffectiveDate and CareOpToPlan.ExpirationDate
	   		  AND CareOpToPlan.ClientKey = QM.ClientKey     
	       LEFT JOIN (SELECT DISTINCT lstScore.MeasureID, lstScore.ExpirationDate, lstScore.EffectiveDate, lstScore.Score_A, lstScore.lstScoringSystemKey
	   				, ROW_NUMBER() OVER (PARTITION BY lstScore.MeasureID ORDER BY lstScore.CreatedDate DESC) aRowNum
	   			 FROM [lst].[lstScoringSystem] lstScore 
	   			 WHERE lstScore.ClientKey = 16) lstScore
	   	   ON lstScore.MeasureID = QM.[QmMsrId] AND lstScore.aRowNum = 1 
	   		  --AND YEAR(SCOR.ExpirationDate) = YEAR(QM.QMDate)
	   		  AND QM.qmDate BETWEEN lstScore.EffectiveDate and lstScore.ExpirationDate	       
	   WHERE QM.ClientKey = 16 
	       AND LQM.ACTIVE = 'Y'
	       /* get care ops for this Year only */
	       --AND qm.QMDate > DateFromParts(Year(getdate()), 1, 1) 
		  AND qm.QMDate  = (SELECT MAX(Qm.QMDate) AS MaxQmDate FROM adw.QM_ResultByMember_History QM WHERE qm.ClientKey = 16)
    )  SRC	 
