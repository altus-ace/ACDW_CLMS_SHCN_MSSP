

CREATE Procedure [adw].[pdw_UpdateFctMembershipInfoDatafrmAHS]

AS

BEGIN

			
UPDATE		adw.FctMembership
SET			NPI = src2.NPI    ----  select distinct trg.clientmemberkey,trg.npi,src1.mbrMemberKey,src2.mbrMemberKey
FROM		adw.FctMembership trg
JOIN		adw.MbrMember src1
ON			trg.ClientMemberKey = src1.ClientMemberKey
AND			trg.ClientKey = src1.ClientKey
JOIN		adw.MbrPcp src2
ON			src1.mbrMemberKey = src2.mbrMemberKey --this depicts that member is valid and present in our DW
--WHERE		trg.ClientMemberKey = '1DJ8QM8NN36'

END

