

CREATE  VIEW [adw].[vw_Exp_QmPrograms_Old_11252020]
AS
    /*     GET ACTIVE_Members: fct mbrship
			 join QM That are active for those member
			 filter for qm mapping
			 filter Plan
			 fiter Program
    */

    SELECT Client.CS_Export_LobName
        , CONVERT(NVARCHAR(1000), CareOpToPrograms.DESTINATION_PROGRAM_NAME) PROGRAM_NAME        
        , dateadd(day, -1*day(CONVERT(DATE, CareOp.CreateDate, 101))+1,CONVERT(DATE,CareOp.CreateDate, 101)) AS ENROLL_DATE 			 
        , CareOp.CreateDate AS CREATE_DATE        
	   , CONVERT(NVARCHAR, ActiveMembers.ClientMemberKey) AS MEMBER_ID
        , CASE WHEN (ActiveMembers.WCV_IsLess16Months = 1) THEN ActiveMembers.WCV_ProgramEndDate
    				--ELSE CONVERT(DATE, '12/31/' + convert(VARCHAR(4),YEar(GETDATE())), 101) 
				ELSE CONVERT(DATE, '12/31/2099')
    				END AS ENROLL_END_DATE 
        , 'ACTIVE' AS PROGRAM_STATUS
        , 'Enrolled in a Program' AS REASON_DESCRIPTION        
        , 'ACE CareOpps' AS REFERAL_TYPE		
	   , Client.ClientKey         	   
    FROM (SELECT fMbr.ClientMemberKey, fmbr.PlanID, fMbr.PlanName, fmbr.ProviderPOD AS CsPlanName
	   	   , fmbr.DOB, fMbr.DOD, DATEADD(Month, 15, fMbr.DOB) AS WCV_ProgramEndDate	   
	   	   , CASE WHEN (DATEDIFF(Month, fMbr.DOB, fMbr.LoadDate)<=15) THEN 1 ELSE 0 END AS WCV_IsLess16Months    
	   	   --select top 100 * 
	       FROM adw.FctMembership fMbr
	       WHERE (SELECT Max(LoadDate) FROM adw.FctMembership) BETWEEN fMbr.RwEffectiveDate and fMbr.RwExpirationDate
	   		 AND getdate()  <  CASE WHEN (fMbr.DOD = '1900-01-01') then '12/31/2199' ELSE fMbr.DOD END
		  ) AS ActiveMembers
        JOIN (/* Care Ops */
    		  SELECT COP.QM_ResultByMbr_HistoryKey, cop.ClientKey, cop.QmMsrId
		  	   , CASE WHEN (cop.QmCntCat = 'NUM') THEN 'EXPCOP' END as QmCntCat
		  	   , COP.QMDate, cop.ClientMemberKey, cop.CreateDate
		  	   , QmList.QM_DESC
		  	   ,row_NUMBER() OVER (PARTITION BY cop.ClientMemberKey, cop.QmMsrID, cop.QmCntCat ORDER BY cop.[QMDate] DESC) arn
		      FROM  adw.QM_ResultByMember_History COP
		  	   JOIN lst.LIST_QM_Mapping QmList ON COP.QmMsrId = QmList.QM AND QmList.ACTIVE = 'Y'
		  	   JOIN (SELECT MAX(qm.QmDate) MaxQmDate, DATEFROMPARTS(Year(Max(qm.QMDate)), 1, Month(MAX(qm.QmDate))) aQmDate , qm.ClientKey
		      				FROM adw.QM_ResultByMember_History qm                
		      		  		GROUP BY qm.ClientKey
		  			) QmDate ON cop.ClientKey = QmDate.ClientKey AND cop.QMDate >= QmDate.aQmDate
		      WHERE COP.QmCntCat = 'NUM'    		  	
		  )AS CareOp ON ActiveMembers.ClientMemberKey = CareOp.ClientMemberKey AND CareOp.arn = 1        
	   JOIN lst.List_Client Client ON CareOp.ClientKey = Client.ClientKey    
        JOIN acemasterdata.lst.lstCareOpToPlan AS CareOpToPlan
    		  ON --ActiveMembers.PlanName = CareOpToPlan.CsPlan for Acecaredw- with CsPlan
			 ActiveMembers.CsPlanName = CareOpToPlan.CsPlan
    			 AND Client.ClientKey = CareOpToPlan.ClientKey 
			 AND CareOp.QmMsrId = CareOpToPlan.MeasureID     		  
    			 AND GETDATE() BETWEEN CareOpToPlan.EffectiveDate and CareOpToPlan.ExpirationDate    
        JOIN lst.lstMapCareoppsPrograms AS CareOpToPrograms
    		  ON   CareOpToPrograms.is_active = 1
    			 AND CareOpToPlan.MeasureDesc = CareOpToPrograms.SOURCE_MEASURE_NAME 
    			 AND CareOpToPlan.SubMeasure = CareOpToPrograms.SOURCE_SUB_MEASURE_NAME					
    			 AND CareOpToPrograms.DESTINATION = 'ALTRUISTA'	
