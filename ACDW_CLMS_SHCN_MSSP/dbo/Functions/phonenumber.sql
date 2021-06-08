
CREATE function [dbo].[phonenumber](@MemberHomePhone VARCHAR(20))
returns bigint
as
BEGIN
Declare @count int=1;
WHILE(@count<=20)
BEGIN
SET @MemberHomePhone = REPLACE(@MemberHomePhone,SUBSTRING(@MemberHomePhone,PATINDEX('%[^0-9]%',@MemberHomePhone), 1),'');
set @count=@count+1;
END  
return(@MemberHomePhone);
END;

