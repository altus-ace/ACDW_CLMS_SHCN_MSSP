create procedure adw.test
    (@OT VARCHAR(30) output)
as 
BEGIN
    
    SELECT @OT= OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
    RETURN
END