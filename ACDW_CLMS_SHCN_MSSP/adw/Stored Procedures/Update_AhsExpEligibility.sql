CREATE PROCEDURE adw.Update_AhsExpEligibility( @ExportDate Date)
AS 
begin

    UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
    --SELECT Elig.*
    FROM dbo.vw_Exp_AH_Eligibility vwElig
    JOIN adw.AhsExpEligiblity elig on vwElig.SKey = elig.AhsExpEligibilityKey

END
