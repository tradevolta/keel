--  With interrupts masked, a wrap's handler can't run: if the
--  wrap is pending, count it here, and read the counter again
--  in case it wrapped after the first read
function Clock return Time is
   Masked : constant Boolean := Interrupts_Disabled;
   Ms     : Unsigned_64;
   Left   : Unsigned_32;
begin
   Disable_Interrupts;
   Ms := Ticks;
   Left := SYST_CVR;
   if (ICSR and PENDSTSET) /= 0 then
      Left := SYST_CVR;
      Ms := Ms + 1;
   end if;
   if not Masked then
      Enable_Interrupts;
   end if;
   return Time (Unsigned_64'Min
                  (Ms * 1_000
                   + Unsigned_64 ((Reload - Left) / Per_Us),
                   Unsigned_64 (Max_Clock)));
end Clock;
