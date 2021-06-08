
CREATE PROCEDURE adw.p_AceValidate_QMTransforms

AS

BEGIN

SELECT			Count(ClientMemberKey) RecCnt, QmMsrID, QmCntCat
FROM			adw.QM_ResultByMember_History
WHERE			QMDate = DATEFROMPARTS(Year(Getdate()),Month(Getdate()),15)
GROUP BY		QmMsrID, QmCntCat
ORDER BY		QmMsrID, QmCntCat

END


BEGIN

SELECT			Count(ClientMemberKey) RecCnt, QmMsrID, QmCntCat
FROM			[adw].[QM_ResultByValueCodeDetails_History]
WHERE			QMDate = DATEFROMPARTS(Year(Getdate()),Month(Getdate()),15)
AND				QmCntCat <> 'DEN'
GROUP BY		QmMsrID, QmCntCat
ORDER BY		QmMsrID, QmCntCat

END




