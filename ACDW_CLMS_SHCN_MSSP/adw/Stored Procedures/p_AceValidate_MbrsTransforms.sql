
CREATE PROCEDURE adw.p_AceValidate_MbrsTransforms

AS
/*MemberValidation Handler..
adi -> adw. adw -> export
ClientMemberKey
NPI
Plan
Member Validity
Client
*/

--1 Validating from adi - adw

--Member Count
		SELECT		COUNT(ClientMemberKey) TotalMbrCntForCurrentMonth
		FROM		adw.FctMembership 
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))

		IF @@ROWCOUNT>0  SELECT 'Current Month Member Count' AS MemberCount
		
		--Count Active Members--Member, Pcp EffectiveDate, Plan
		BEGIN
		SELECT		A_ClientMemberKey AS ActiveMbr
					, B_NPI As ActiveNPI
					, LOB AS CuurentLOB
					, EffectiveDate AS PCPEffectiveDate
					, ExpirationDate AS PCPExpirationDate
		FROM		(
		SELECT		a.ClientMemberKey as A_ClientMemberKey
					,b.NPI as B_NPI
					,a.NPI as A_NPI
					,b.LOB
					,b.EffectiveDate
					,b.ExpirationDate
					,a.MbrYear
					,a.MbrMonth
					,b.RowEffectiveDate
					,b.RowExpirationDate
					,a.Active
					, ROW_NUMBER() OVER (PARTITION BY b.NPI, a.ClientMemberKey, a.LOB, RowEffectiveDate,RowExpirationDate, b.EffectiveDate,b.ExpirationDate
						ORDER BY EffectiveDate DESC ) RwnCnt
		FROM		adw.FctMembership a
		JOIN		ACECAREDW.[adw].[fctProviderRoster] b
		ON			a.NPI = b.NPI
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))
		AND			b.ClientKey = (SELECT ClientKey FROM lst.List_Client WHERE ClientShortName = 'SHCN_MSSP')
		AND			GETDATE() BETWEEN RowEffectiveDate AND RowExpirationDate
		AND			b.LOB = 'Medicare Advantage'
					)src
		WHERE		src.RwnCnt =1
		
		IF @@ROWCOUNT>0 SELECT 'This is MemberPcp Relationship and Pcp EffectiveDate' AS Result

		END
		--Validate for biz rules --Cuurent attribute of Member
		BEGIN

		SELECT		ClientMemberKey,Gender,MbrYear,MbrMonth,PlanName,LOB
					,Contract, ClientRiskScore, Active
		FROM		adw.FctMembership a
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))

		IF @@ROWCOUNT>0 SELECT 'This is the current attribute of the Member' AS Outcome
		
		END
		
		--2 Validating from adw to Export-- Ensuring Export file src matches AHS Destination Layout
		--Validating NPI Record

		BEGIN

		Select		ClientMemberKey, RwEffectiveDate,RwExpirationDate,MbrYear
					,MbrYear,PcpPracticeTIN
		From		adw.FctMembership a
		WHERE		NPI = ''
		AND			MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))

		IF @@ROWCOUNT >=1 SELECT 'Wrong Output' 
		
		END
		--Validating Tin Record
		BEGIN

		SELECT		ClientMemberKey, RwEffectiveDate,RwExpirationDate,MbrYear,NPI,PcpPracticeTIN 
		FROM		adw.FctMembership 
		WHERE		PcpPracticeTIN = ''
		AND			MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))
		
		IF @@ROWCOUNT >=1 SELECT 'Wrong Output' AS Result
		
		END
		--Member Plan Validity for the current month
		BEGIN
		SELECT		ClientMemberKey
					, LOB,PlanName
					, Contract
					, MemberCurrentEffectiveDate
					, MemberCurrentExpirationDate
					, MbrYear,MbrMonth
		FROM		adw.FctMembership 
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))
		
		IF @@ROWCOUNT >=1 SELECT 'Members Attribute and EffectiveDate' AS Result

		END
		-- Validating empty strings

		BEGIN
		Select		ClientMemberKey, RwEffectiveDate,RwExpirationDate,MbrYear
					,MbrYear,PcpPracticeTIN
		From		adw.FctMembership a
		WHERE		NPI = ''
		AND			ClientMemberKey = ''
		OR			LOB = ''
		OR			PlanName = ''
		OR			Contract = ''
		OR			RwEffectiveDate = ''
		OR			RwExpirationDate = ''
		OR			MbrYear = ''
		OR			MbrMonth = ''

		IF @@ROWCOUNT >=1 SELECT 'Wrong Output' AS Result
		IF @@ROWCOUNT <=0 SELECT 'Nill Return is Right Output' AS Result

		END
		--Members  Enrollment validity
		BEGIN

		SELECT		ClientMemberKey, MbrYear
					,MbrMonth, MemberCurrentEffectiveDate
					,MemberCurrentExpirationDate
		FROM		adw.FctMembership
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))
		AND			MemberCurrentEffectiveDate >= CONVERT(DATE, GETDATE())

		IF @@ROWCOUNT >=1 SELECT 'Members Enrollment is in the Future'
		IF @@ROWCOUNT <=0 SELECT 'Nill Return is Right Output' AS Result
		
		END
		

		--Members  Termination validity
		BEGIN

		SELECT		ClientMemberKey, MbrYear
					,MbrMonth, MemberCurrentEffectiveDate
					,MemberCurrentExpirationDate
		FROM		adw.FctMembership
		WHERE		MbrYear =  (SELECT YEAR(CONVERT(DATE,GETDATE()))) 
		AND			MbrMonth = (SELECT MONTH(CONVERT(DATE,GETDATE())))
		AND			MemberCurrentExpirationDate <= CONVERT(DATE, GETDATE())

		IF @@ROWCOUNT >=1 SELECT 'Members Enrollment is in the Future'
		IF @@ROWCOUNT <=0 SELECT 'Nill Return is Right Output' AS Result
		
		END

