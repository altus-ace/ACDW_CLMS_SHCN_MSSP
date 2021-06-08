
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ValidateClaimHeaderAdiToAdw]
	-- Add the parameters for the stored procedure here
		 @MBI_Num			VARCHAR(20)
		,@PrimServiceDate	DATE
		,@SeqClaimID		VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @MbrHalrBase    tinyint = 0
		DECLARE @MbrDemo	    tinyint = 0

CREATE TABLE #TmpClaimsMember (MemberNo VARCHAR(50) Not Null, EventDate DATE Not Null, MedicareClaimNo VARCHAR(20) Not Null, primary key (MemberNo, MedicareClaimNo))
INSERT INTO #TmpClaimsMember (MemberNo, EventDate, MedicareClaimNo)
	VALUES (@MBI_Num,@PrimServiceDate,@SeqClaimID)

SELECT 'MemberClaim_ToBeSearched' Source, t.MemberNo, t.MedicareClaimNo
FROM #TmpClaimsMember t
WHERE ((@MBI_Num = '0' ) or (@MBI_Num <> '0' and t.MemberNo = @MBI_Num));

IF @MbrHalrBase = 1 
BEGIN
    SELECT 'MsspMbrs_Halrbase' AS Source, *
    FROM [adi].[Steward_MSSPAnnualmembership_HALRBASE] Mbr_HalrBase 
        JOIN #TmpClaimsMember t 
    	   ON Mbr_HalrBase.MedicareBeneficiaryID = t.MemberNo
    --		  and Mbr_HalrBase.HealthInsuranceClaimNBR = t.MedicareClaimNo
    WHERE ((@MBI_Num = '0' ) or (@MBI_Num <> '0' and t.MemberNo = @MBI_Num))
END;

IF @MbrDemo = 1 
BEGIN
    SELECT DISTINCT 'MsspBeneFiciaryDemographics' Source, demo.DataDate, demo.MedicareBeneficiaryID, demo.*
    FROM [adi].[Steward_MSSPBeneficiaryDemographic] Demo
        JOIN #TmpClaimsMember t 
    	   ON demo.MedicareBeneficiaryID = t.MemberNo  
    	   --and demo.HealthInsuranceClaimNBR = t.MedicareClaimNo	   
    WHERE ((@MBI_Num = '0' ) or (@MBI_Num <> '0' and t.MemberNo = @MBI_Num))
    ORDER BY demo.MedicareBeneficiaryID
    ;
END;


If OBJECT_ID('tempdb..#TmpPartAClmAdiKeys') is NULL
BEGIN 
    CREATE TABLE #TmpPartAClmAdiKeys (aRowKey INT NOT NULL IDENTITY(1,1) PRimary Key, LatestClmHdr_SrcAdiKey INT , LatestClaim_Used_SrcAdiKey INT );
END
ELSE truncate table #tmpPartAClmAdiKeys;
    INSERT INTO #TmpPartAClmAdiKeys(LatestClmHdr_SrcAdiKey, LatestClaim_Used_SrcAdiKey)
    SELECT DeDup.SrcAdiKey LatestClmHdr_SrcAdiKey , LatestClmHdr_SuperKey.LatestClaimAdiKey LatestClaim_Used_SrcAdiKey
    FROM [adi].[Steward_MSSPPartAClaim] PartAHdr
        JOIN #TmpClaimsMember t 
    	   ON PartAHdr.MedicareBeneficiaryID = t.MemberNo
    		  and PartAHdr.ClaimID = t.MedicareClaimNo	   
        LEFT JOIN ast.[ClaimHeader_01_Deduplicate] DeDup
    	   ON PartAHdr.MSSPPartAClaimKey = DeDup.SrcAdiKey
        LEFT JOIN ast.ClaimHeader_02_ClaimSuperKey  SuperKey
    	   --ON PartAHdr.MSSPPartAClaimKey = DeDup.SrcAdiKey
    	   ON PartAHdr.CMSCertificationNBR = SuperKey.PRVDR_OSCAR_NUM
    		  AND PartAHdr.MedicareBeneficiaryID = SuperKey.BENE_EQTBL_BIC_HICN_NUM
    		  AND PartAHdr.ClaimStartDTS = SuperKey.CLM_FROM_DT
    		  AND PartAHdr.ClaimEndDTS   = SuperKey.CLM_THRU_DT 	   
			  AND PartAHdr.ClaimTypeCD   = SuperKey.ClaimTypeCode
        LEFT JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader LatestClmHdr_SuperKey
    	   ON SuperKey.clmSKey = LatestClmHdr_SuperKey.clmSKey
			and LatestClmHdr_SuperKey.LatestClaimAdiKey = LatestClmHdr_SuperKey.ReplacesAdiKey
        LEFT JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader LatestClmHdr_FromAdi 
    	   ON PartAHdr.MSSPPartAClaimKey = LatestClmHdr_SuperKey.LatestClaimAdiKey
			AND LatestClmHdr_SuperKey.LatestClaimAdiKey = LatestClmHdr_SuperKey.ReplacesAdiKey
    WHERE ((@MBI_Num = '0' ) or (@MBI_Num <> '0' and t.MemberNo = @MBI_Num))
    ORDER BY PartAHdr.MedicareBeneficiaryID

SELECT 'PartAHdr' As Source, t.MemberNo Searched_MemberNo, t.MedicareClaimNo Searched_MedicareClaimNo, Dedup.srcAdiKey DeDupHdr_SrcAdiKey, SuperKey.clmSKey AceCalcd_SuperKey, LatestClmHdr_FromAdi.LatestClaimAdiKey LatestClmHdr_SrcAdiKey
    , LatestClmHdr_SuperKey.LatestClaimAdiKey LatestClaim_Used_SrcAdiKey
    ,PartAHdr.*
FROM [adi].[Steward_MSSPPartAClaim] PartAHdr
    JOIN #TmpClaimsMember t 
	   ON PartAHdr.MedicareBeneficiaryID = t.MemberNo
		  and PartAHdr.ClaimID = t.MedicareClaimNo	   
    LEFT JOIN ast.[ClaimHeader_01_Deduplicate] DeDup
	   ON PartAHdr.MSSPPartAClaimKey = DeDup.SrcAdiKey
    LEFT JOIN ast.ClaimHeader_02_ClaimSuperKey  SuperKey
	   --ON PartAHdr.MSSPPartAClaimKey = DeDup.SrcAdiKey
	   ON PartAHdr.CMSCertificationNBR = SuperKey.PRVDR_OSCAR_NUM
		  AND PartAHdr.MedicareBeneficiaryID = SuperKey.BENE_EQTBL_BIC_HICN_NUM
		  AND PartAHdr.ClaimStartDTS = SuperKey.CLM_FROM_DT
		  AND PartAHdr.ClaimEndDTS   = SuperKey.CLM_THRU_DT
		  AND PartAHdr.ClaimTypeCD   = SuperKey.ClaimTypeCode
    LEFT JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader LatestClmHdr_SuperKey
	   ON SuperKey.clmSKey = LatestClmHdr_SuperKey.clmSKey
		and LatestClmHdr_SuperKey.LatestClaimAdiKey = LatestClmHdr_SuperKey.ReplacesAdiKey
    LEFT JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader LatestClmHdr_FromAdi 
	   ON PartAHdr.MSSPPartAClaimKey = LatestClmHdr_SuperKey.LatestClaimAdiKey
		and LatestClmHdr_SuperKey.LatestClaimAdiKey = LatestClmHdr_SuperKey.ReplacesAdiKey
WHERE ((@MBI_Num = '0' ) or (@MBI_Num <> '0' and t.MemberNo = @MBI_Num))
ORDER BY PartAHdr.MedicareBeneficiaryID

--SELECT * FROM #TmpPartAClmAdiKeys

SELECT 'PartAClmsSearched' AS Source, *
FROM adi.Steward_MSSPPartAClaim PartAHdr
    RIGHT JOIN #TmpPartAClmAdiKeys AdiKeys ON PartAHdr.MSSPPartAClaimKey = AdiKeys.LatestClmHdr_SrcAdiKey
UNION ALL
SELECT 'PartAClmsUsed' AS Source, *
FROM adi.Steward_MSSPPartAClaim PartAHdr
    RIGHT JOIN #TmpPartAClmAdiKeys AdiUsed ON PartAHdr.MSSPPartAClaimKey = AdiUsed.LatestClaim_Used_SrcAdiKey

END

DROP TABLE #TmpClaimsMember 
/***
EXEC adi.ValidateClaimHeaderAdiToAdw '9TA2TP6TY08','2020-01-05','90963225325'
***/
