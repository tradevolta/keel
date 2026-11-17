procedure Register_All is
   procedure Add (Name, Usage : String; Run : not null Handler) is
      Stat : Status;
   begin
      Register (Name, Usage, Run, Stat);
      pragma Assert (Stat = Ok);
   end Add;
begin
   Add ("gpio", "gpio <pin> [on|off|toggle|read]", Gpio'Access);
   Add ("pwm", "pwm <pin> <percent>", Pwm'Access);
   Add ("adc", "adc <input>|temp", Adc'Access);
   Add ("clock", "clock", Clock'Access);
   Add ("reset-reason", "reset-reason", Reset_Reason'Access);
   Add ("reboot", "reboot", Reboot'Access);
   Add ("uart", "uart", Uart'Access);
   Add ("nmea", "nmea <sentence>", Nmea'Access);
   Add ("log", "log [debug|info|warn|error]", Log_Level'Access);
end Register_All;
