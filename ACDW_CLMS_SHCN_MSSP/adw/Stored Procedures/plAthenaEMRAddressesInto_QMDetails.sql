

CREATE	PROCEDURE	[adw].[plAthenaEMRAddressesInto_QMDetails](@QMDATE DATE)

AS

BEGIN

		INSERT INTO adw.QM_ResultByValueCodeDetails_History(
				ClientKey
				,ClientMemberKey
				,ValueCodeSystem
				,ValueCode
				,ValueCodePrimarySvcDate
				,QmMsrID
				,QmCntCat
				,QMDate
				,SEQ_CLAIM_ID
				,SVC_TO_DATE
				,SVC_PROV_NPI
				,Adikey
				,srcfilename
				,aditablename)
		SELECT	DISTINCT a.ClientKey
				,a.ClientMemberKey
				,'AthenaGapReport'  AS ValueCodeSystem ---srcData
				,'0'			    AS ValueCode
				,b.AddressedDate	AS ValueCodePrimarySvcDate
				,a.QmMsrId		    
				,CASE a.QmCntCat 
					WHEN 'COP' THEN 'ADD' ELSE 'NA'
					END QmCntCat
				,a.QMDate			    
				,'0'			    AS SEQ_CLAIM_ID
				,'1900-01-01'		AS SVC_TO_DATE
				,b.NPI				AS SVC_PROV_NPI
				,b.Adikey
				,b.srcfilename
				,b.aditablename
				--,ROW_NUMBER()OVER(PARTITION BY a.ClientMemberKey,b.AddressedDate,a.QmMsrId	ORDER BY a.QMDATE DESC)RwCnt
		FROM	adw.QM_ResultByMember_History a
		JOIN	adw.QM_Addressed b
		ON		a.ClientMemberKey = b.ClientMemberKey
		AND		a.QmMsrId = b.QmMsrId
		AND		a.QMDate = @QMDATE -- '2021-05-15' --
		AND		b.QMDate = @QMDATE  ---'2021-05-15'
		WHERE	a.QmCntCat = 'COP'
		AND		a.Addressed = 1
		ORDER BY a.ClientMemberKey, b.AddressedDate
		

			
	END

	