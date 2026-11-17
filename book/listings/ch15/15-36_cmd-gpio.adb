--  gpio <pin> [on|off|toggle|read]
procedure Gpio (Args : Arguments) is
   Act   : Board.Pin_Action := Board.Read;
   Level : Boolean;
   Stat  : Status;
begin
   if Count (Args) not in 2 .. 3 then
      Show_Usage ("gpio");
      return;
   elsif Count (Args) = 3 then
      declare
         W : constant String := Word (Args, 3);
      begin
         if W = "on" then
            Act := Board.On;
         elsif W = "off" then
            Act := Board.Off;
         elsif W = "toggle" then
            Act := Board.Toggle;
         elsif W /= "read" then
            Show_Usage ("gpio");
            return;
         end if;
      end;
   end if;
   Board.Pin (Word (Args, 2), Act, Level, Stat);
   if Stat /= Ok then
      Put_Line ("gpio: " & Word (Args, 2) & " can't " & Verb (Act)
                & "; pins: " & Board.Pin_Names);
   else
      Put_Line (Word (Args, 2) & ": "
                & (if Level then "high" else "low"));
   end if;
end Gpio;
