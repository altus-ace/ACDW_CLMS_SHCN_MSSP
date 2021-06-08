CREATE PROCEDURE adw.p_AceValidate_ClaimsTransforms
AS 
    DECLARE @DiagCodeWithoutDot INT;
    DECLARE @ClmHdrDrgCodeToLong INT;
    DECLARE @ClmDtlRevCodeToLong INT;
    DECLARE @ClmDtlSumPaidAmountDiffFromHdr INT;

    SELECT @DiagCodeWithoutDot = count(*)
    FROM adw.Claims_Diags d
    where ISNULL(d.diagCodeWithoutDot, '') = ''

    SELECT @ClmHdrDrgCodeToLong =  COUNT(ClmsHdrs.SEQ_CLAIM_ID)
    FROM adw.Claims_Headers ClmsHdrs		
    WHERE not clmsHdrs.DRG_CODE IS NULL
	   AND TRY_CONVERT(int, clmsHdrs.DRG_CODE) is not null
	   AND Len(clmsHdrs.DRG_CODE) > 3 ;
    
    SELECT @ClmDtlRevCodeToLong =  details.ClaimsDetailsKey 
    FROM adw.Claims_Details AS details
    WHERE details.REVENUE_CODE <> ''
	   AND LEN(details.REVENUE_CODE) >3;
	 
    SELECT @ClmDtlSumPaidAmountDiffFromHdr  = COUNT(*) 
    FROM (SELECT Hdr.SEQ_CLAIM_ID, Hdr.SUBSCRIBER_ID, Hdr.TOTAL_PAID_AMT , Dtls.SumPaidAmt, Hdr.SrcAdiKey, hdr.SrcAdiTableName HdrAdiTable, Dtls.srcAdiTableName dtlAdiTable
		  FROM (SELECT cd.SUBSCRIBER_ID, cd.SEQ_CLAIM_ID, SUM(cd.PAID_AMT) SumPaidAmt, count(*) cntDtlRows, MAX(cd.SrcAdiTableName) srcAdiTableName
				FROM adw.Claims_Details cd --ON ch.SEQ_CLAIM_ID = cd.SEQ_CLAIM_ID
				    --JOIN (SELECT cl.ClaimID, cl.MedicareBeneficiaryID			
	   			    --        FROM adi.Steward_MSSPPartDClaimLineItem cl
			 	    --	      JOIN ast.pstDeDupClms_PartDPharma d ON cl.MSSPPartDClaimLineItemKey = d.urn
				    --) PartDDetails 
				    --	ON cd.SEQ_CLAIM_ID = PartDDetails.ClaimID
				    -- AND cd.SUBSCRIBER_ID = PartDDetails.MedicareBeneficiaryID					 
				    --and cd.SUBSCRIBER_ID = '9YY0F00CU03'
				GROUP BY cd.SEQ_CLAIM_ID, cd.SUBSCRIBER_ID
				) Dtls
		  JOIN adw.Claims_Headers hdr		  
    			 ON  Dtls.SEQ_CLAIM_ID = hdr.SEQ_CLAIM_ID 
			 and Dtls.SUBSCRIBER_ID = hdr.SUBSCRIBER_ID
		  WHERE Hdr.TOTAL_PAID_AMT <> Dtls.SumPaidAmt
	   ) as ClaimsDiffDtlsHdrSum

    SELECT 
	 ISNULL(@DiagCodeWithoutDot, '') AS cntDiagCodeWithoutDotNull
    , ISNULL(@ClmHdrDrgCodeToLong, 0) cntClaimHeaderDrgCodeLongerThan3
    , ISNULL(@ClmDtlRevCodeToLong, 0)  cntClaimDetailRevCodeLongerThan3
    , ISNULL(@ClmDtlSumPaidAmountDiffFromHdr, 0) cntClaimDetailPaidAmountSumDiffFromHeader
        

