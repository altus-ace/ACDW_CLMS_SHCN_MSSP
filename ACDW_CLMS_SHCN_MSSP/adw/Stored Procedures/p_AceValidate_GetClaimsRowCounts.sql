CREATE  PROCEDURE  adw.[p_AceValidate_GetClaimsRowCounts]
AS 
    SELECT COUNT(*) as Headers  From adw.Claims_Headers 
    SELECT COUNT(*) as details  From adw.Claims_details
    SELECT COUNT(*) as Diags	   From adw.Claims_Diags
    SELECT COUNT(*) as Procs	   From adw.Claims_Procs
    SELECT COUNT(*) as Members  From adw.Claims_Member

    
    /* there should be a count of Zero */    
    SELECT COUNT(hdr.SUBSCRIBER_ID)  HeadersWithOrphanedMembers
	   FROM adw.Claims_Headers hdr
	      LEFT JOIN adw.Claims_Member mbr ON hdr.SUBSCRIBER_ID = mbr.SUBSCRIBER_ID
	   WHERE mbr.SUBSCRIBER_ID is null
	   GROUP BY hdr.SUBSCRIBER_ID 
	;
	
	SELECT dtl.SEQ_CLAIM_ID DetailOrphanedFromHeader
	FROM adw.Claims_Details dtl
	   LEFT JOIN adw.Claims_Headers hdr on dtl.SEQ_CLAIM_ID = hdr.SEQ_CLAIM_ID
     WHERE hdr.SEQ_CLAIM_ID is null
	GROUP BY dtl.SEQ_CLAIM_ID
	;
	 
	SELECT dg.SEQ_CLAIM_ID DiagOrphanedFromHeader
	FROM adw.Claims_Diags dg
	   LEFT JOIN adw.Claims_Headers hdr on dg.SEQ_CLAIM_ID = hdr.SEQ_CLAIM_ID
     WHERE hdr.SEQ_CLAIM_ID is null
	GROUP BY dg.SEQ_CLAIM_ID
	;

	SELECT prc.SEQ_CLAIM_ID ProcsOrphanedFromHeader
	FROM adw.Claims_Procs prc
	   LEFT JOIN adw.Claims_Headers hdr on prc.SEQ_CLAIM_ID = hdr.SEQ_CLAIM_ID
     WHERE hdr.SEQ_CLAIM_ID is null
	GROUP BY prc.SEQ_CLAIM_ID
	;
  
    SELECT count(*) as ast_CH01_DedupCnt FROM ast.ClaimHeader_01_Deduplicate
    SELECT count(*) as ast_CH02_ClaimSuperKey FROM ast.ClaimHeader_02_ClaimSuperKey
    SELECT count(*) as ast_CH03_LtEffClmsHdr  FROM ast.ClaimHeader_03_LatestEffectiveClaimsHeader 
    SELECT count(*) as ast_DeDupClmDetails FROM ast.pstcLnsDeDupUrns DeDupClmDetails 
    SELECT count(*) as ast_pstcDgDeDupUrns FROM ast.pstcDgDeDupUrns
    SELECT count(*) as ast_pstcPrcDeDupUrns FROM ast.pstcPrcDeDupUrns
    SELECT count(*) as ast_pstDeDupClms_PartBPhys FROM ast.pstDeDupClms_PartBPhys
    SELECT count(*) as ast_pstDeDupClms_PartDPharma FROM ast.pstDeDupClms_PartDPharma
