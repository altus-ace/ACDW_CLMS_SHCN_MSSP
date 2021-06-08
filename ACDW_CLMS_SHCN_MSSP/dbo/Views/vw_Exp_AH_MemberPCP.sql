
/* view for exporting members by pcp */
CREATE VIEW [dbo].[vw_Exp_AH_MemberPCP]
AS
    /* version history:
04/26/2020 - initial export create by RA
10/19/2020: GK = added support to get latestRecords as the Max RowEffective and RowExpiration dates from the Fct.
	   */
    SELECT DISTINCT 
           mbr.ClientMemberKey AS MEMBER_ID, 
           lc.ClientShortName AS [CLIENT_ID], 
           mbr.NPI AS [MEMBER_PCP], 
           'PCP' AS [PROVIDER_RELATIONSHIP_TYPE],   
           lc.CS_Export_LobName AS [LOB], 
           '2020-01-01' AS [PCP_EFFECTIVE_DATE], 
           '2099-12-31' AS [PCP_TERM_DATE], 
           'A' AS [MEMBER_PCP_ADDITIONAL_INFORMATION_1]
   FROM [adw].FctMembership mbr
         INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
	    INNER JOIN (SELECT MAX(mbr.RwEffectiveDate) mbrRwEff, Max(mbr.RwExpirationDate) MbrRwExp from Adw.FctMembership mbr) LatestRecords
		  ON mbr.RwEffectiveDate = LatestRecords.mbrRwEff
			 and mbr.RwExpirationDate = LatestRecords.MbrRwExp
    WHERE mbr.Active = 1	  

