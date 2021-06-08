CREATE PROCEDURE adw.p_AceValidate_GetCountNewClaimsFromLastLoad
AS 
    SELECT bh.LatestClaimAdiKey
    FROm ast.ClaimHeader_03_LatestEffectiveClaimsHeader bh
    EXCEPT
    SELECT clmHdrUrn
    FROm ast.bk_ClaimHeader_03_LatestEffectiveClaimsHeader bh
    WHERE loadDate = (SELECT MAX(LoadDate) FROM ast.bk_ClaimHeader_03_LatestEffectiveClaimsHeader bh);
