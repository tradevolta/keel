function Last_Cause return Reset_Cause is
begin
   Capture;
   if (Flags and (IWDG or WWDG)) /= 0 then
      return Watchdog_Timeout;
   elsif (Flags and SFT) /= 0 then
      return Software;
   elsif (Flags and BOR) /= 0 then
      return Power_On;
   elsif (Flags and (LPWR or OBL)) /= 0 then
      return Unknown;
   elsif (Flags and PIN) /= 0 then
      return Reset_Pin;
   else
      return Unknown;
   end if;
end Last_Cause;
