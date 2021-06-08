
CREATE PROCEDURE	[adw].[pdwMbr_31_Load_MemberMonth_ConsolidationMSSP] -- [adw].[pdwMbr_31_Load_MemberMonth_ConsolidationMSSP]'2021-03-10',16
					(@LoadDate DATE, @ClientKey INT)

AS

BEGIN

		INSERT INTO		 ACECAREDW.[dbo].[TmpAllMemberMonths]
						([MemberMonth]
						,[CLientKey]
						,[LOB]
						,[ClientMemberKey]
						,[PCP_NPI]
						,[PLAN_ID]
						,[PLAN_CODE]
						,[SUBGRP_ID]
						,[SUBGRP_NAME]
						,[PCP_PRACTICE_TIN]
						,[PCP_PRACTICE_NAME]
						,[MEMBER_FIRST_NAME]
						,[MEMBER_LAST_NAME]
						,[GENDER]
						,[AGE]
						,[DATE_OF_BIRTH]
						,[MEMBER_HOME_ADDRESS]
						,[MEMBER_HOME_ADDRESS2]
						,[MEMBER_HOME_CITY]
						,[MEMBER_HOME_STATE]
						,[MEMBER_HOME_ZIP]
						,[MEMBER_HOME_PHONE]
						,[IPRO_ADMIT_RISK_SCORE]
						,[RunDate]
						,[RunBy])  --  DECLARE @LoadDate DATE = '2021-03-10' DECLARE @ClientKey INT = 16
			 SELECT   --- SHCN MSSP
						@LoadDate MemberMonth,
						a.CLientKey,
						a.LOB,
						a.ClientMemberKey,
						a.NPI, 
						a.PlanID,
						a.ProductCode,
						a.SubgrpID,
						a.SubgrpName,
						a.PcpPracticeTIN,
						a.ProviderPracticeName,
						a.FirstName,
						a.LastName,
						a.GENDER,
						a.CurrentAge, 
						a.DOB,
						a.MemberHomeAddress,
						a.MemberHomeAddress1,
						a.MemberHomeCity,
						a.MemberHomeState,
						a.MemberHomeZip,
						a.MemberPhone,
						a.ClientRiskScore,
						GETDATE() [RunDate],
						SUSER_NAME() [RunBy]
			FROM		(
							SELECT   
											@LoadDate MemberMonth,
											a.CLientKey,
											a.PLANID AS LOB,
											a.ClientMemberKey,
											a.NPI, 
											a.PlanID,
											a.ProductCode,
											a.SubgrpID,
											a.SubgrpName,
											a.PcpPracticeTIN,
											a.ProviderPracticeName,
											a.FirstName,
											a.LastName,
											a.GENDER,
											a.CurrentAge, 
											a.DOB,
											a.MemberHomeAddress,
											a.MemberHomeAddress1,
											a.MemberHomeCity,
											a.MemberHomeState,
											a.MemberHomeZip,
											a.MemberPhone,
											a.ClientRiskScore,
											GETDATE() [RunDate],
											SUSER_NAME() [RunBy]
											,ROW_NUMBER()OVER(PARTITION BY a.ClientMemberKey ORDER BY ClientMemberKey)RwCnt
								FROM		adw.FctMembership a  -- @LoadDate
								WHERE		ClientKey =  @ClientKey -- 9
								AND			LoadDate = @LoadDate
								AND			Active = 1
					 )a
			WHERE	a.RwCnt = 1

		
	END

	