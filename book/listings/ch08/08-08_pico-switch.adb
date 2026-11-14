procedure Switch (P : Plan; Stat : out Status) is
begin
   case P.Kind is
      when From_Reference =>
         Run_From_Crystal;
         Stat := Ok;
      when From_PLL =>
         if Output (P.Setting) / Flash_Divisor > Flash_Max then
            Run_From_Crystal;
            Stat := Not_Supported;
         else
            Run_From_PLL (P.Setting, Stat);
         end if;
      when Refused =>
         Run_From_Crystal;
         Stat := Not_Supported;
   end case;
   --  The I2C block runs on clk_sys: keep it at 100 kHz
   Power_Monitor.Retime (Sys_Frequency);
end Switch;
