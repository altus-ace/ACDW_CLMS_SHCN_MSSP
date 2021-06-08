
CREATE PROCEDURE [adw].[PupdPhoneNumbersInFctMembership](@EffectiveDate DATE)

AS


UPDATE	adw.FctMembership
SET		MemberCellPhone = b.MemberCellPhone
		,MemberHomePhone = b.MemberHomePhone
		,MemberPhone = b.MemberPhone  --SELECT a.mbryear,a.mbrmonth, a.ClientMemberKey,a.MemberCellPhone,a.MemberHomePhone,a.MemberPhone,b.ClientMemberKey,b.MemberCellPhone,b.MemberHomePhone,b.MemberPhone
FROM	adw.fctmembership a
JOIN	ast.MbrStg2_MbrData b
ON		a.ClientMemberKey = b.ClientMemberKey
AND		a.MBI = b.MBI
WHERE	a.RwEffectiveDate>=@EffectiveDate

