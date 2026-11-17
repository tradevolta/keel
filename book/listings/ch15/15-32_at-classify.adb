function Classify (Line : String; Command : String) return Kind is
begin
   if Line'Length = 0 then
      return Blank;
   elsif Line = "OK" then
      return Ok;
   elsif Line = "ERROR" then
      return Error;
   elsif Has_Error_Code (Line) then
      return Error_Code;
   elsif Answers (Line, Command) then
      return Information;
   elsif Line (Line'First) = '+' then
      return Unsolicited;
   elsif Line (Line'First) = '>' then
      return Prompt;
   elsif Starts_With (Line, "AT") or else Starts_With (Line, "at")
   then
      return Echo;
   else
      return Text;
   end if;
end Classify;
