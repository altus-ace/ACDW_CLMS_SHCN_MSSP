CREATE VIEW adw.[z_tmp_Readmissions]
AS (
SELECT b.*
FROM [adw].[FctInpatientVisits] b 
WHERE b.ClaimType in ('60','61')
AND b.InstType NOT IN ('IP-CAH')
)