
CREATE  VIEW [dbo].[vw_Exp_AH_Eligibility]
AS
    /* version history:
    04/26/2020 - first export list created by RA, this doesnot change in an given year unless members switch plans	   
    01/14/2020 - gk: make export show total time member is active as elig: ie first active month through last active month
    01/19/2020 - GK: Fix errors in Plan END data distibution from the Validation below
    04/20/2021 - gk converted to use a table adw.AhsExpEligibilty to provider persistine storage.
    old code
    SELECT DISTINCT 
		 mbr.ClientMemberKey AS [MEMBER_ID], mbr.active,
		 lc.clientshortname AS CLIENT_ID, 
		 lc.CS_Export_LobName AS [LOB],
		 mbr.[BENEFIT PLAN],
		 'E' AS [INTERNAL/EXTERNAL INDICATOR], 
		 mbr.PlanEffDate AS [START_DATE], 
		 mbr.PlanExpDate AS END_DATE  		 
    FROM (SELECT m.ClientMemberKey, m.ClientKey, m.active,
		      CASE WHEN(ISNULL(m.providerpod, '') = '') THEN 'Dummy SHCN_MSSP'
		  			ELSE m.providerpod END AS [BENEFIT PLAN]
		      , GetMinEffDate.MinEffDate AS  PlanEffDate
			 , CASE WHEN (GetMaxEffDate.MaxRwExDate IS NULL) THEN DATEADD(day, -1, GetMinEffDate.MinEffDate)
				ELSE GetMaxEffDate.MaxRwExDate END AS PlanExpDate
--		      , CASE WHEN (GetMaxEffDate.MaxRwExDate is null) THEN '12/31/2099'  -- active
--		  		  ELSE GetMaxEffDate.MaxRwExDate END AS PlanExpDate		 -- inactive    
		  FROM adw.FctMembership m
		      JOIN (SELECT m.ClientMemberKey,min(m.RwEffectiveDate) MinEffDate
		  		  FROM adw.fctmembership m
		  		  WHERE m.RwEffectiveDate >= '01/01/2020' -- records from 2020 into the future
		  		  GROUP BY m.ClientMemberKey ) GetMinEffDate
		  	   ON  m.ClientMemberKey = GetMinEffDate.ClientMemberKey
		      JOIN (SELECT max(m.RwEffectiveDate) MaxEffDate from adw.FctMembership m) GetCurMonth
		  	   ON GetCurMonth.MaxEffDate between m.RwEffectiveDate and m.RwExpirationDate
		      LEFT JOIN (SELECT m.ClientMemberKey,
						  CASE WHEN (max(m.RwExpirationDate) = (SELECT max(RwExpirationDate) FROM adw.FctMembership m)) THEN '12/31/2099'
							 ELSE max(m.RwExpirationDate) END as  MaxRwExDate
		  			   FROM adw.fctmembership m
		  			   WHERE m.Active = 1 AND 
						  m.RwEffectiveDate >= '01/01/2020' -- records from 2020 into the future
						  --and m.ClientMemberKey = '1QA6VP2JY48'
		  			   GROUP BY m.ClientMemberKey) GetMaxEffDate 
		  		  ON m.ClientMemberKey = GetMaxEffDate.ClientMemberKey
	   ) mbr
	   INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
	   */

    SELECT 
	   /* this columns are for export */
	  ahs.Exp_MEMBER_ID					   as MEMBER_ID					 , 
       ahs.Exp_LOB						   as LOB						 , 
       ahs.[Exp_BENEFIT PLAN]				   as [BENEFIT PLAN]				 , 
       ahs.[Exp_INTERNAL/EXTERNAL INDICATOR]	   as [INTERNAL/EXTERNAL INDICATOR]	 , 
       ahs.Exp_START_DATE				   as START_DATE				 , 
       ahs.Exp_END_DATE					   as END_DATE					 , 
       /* these columns are businesskeys and meta data */
	   ahs.AhsExpEligibilityKey AS SKey, 
       ahs.Exported, 
       ahs.ExportedDate, 
       ahs.ClientMemberKey, 
       ahs.ClientKey, 
       ahs.fctMembershipKey, 
       ahs.LoadDate
    FROM adw.AhsExpEligiblity ahs
    where ahs.exported	= 0;
