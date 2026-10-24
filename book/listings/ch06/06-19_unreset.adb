procedure Unreset is
   Timer0_Only : constant RESET_TIMER_Field :=
     (As_Array => True, Arr => [0 => True, 1 => False]);
begin
   Reset_Bits.Clear
     (RESETS_Periph.RESET,
      (Reset_Bits.No_Bits with delta
         IO_BANK0   => True,
         PADS_BANK0 => True,
         TIMER      => Timer0_Only));
   loop
      declare
         Done : constant RESET_DONE_Register :=
           RESETS_Periph.RESET_DONE;
      begin
         exit when Done.IO_BANK0 and then Done.PADS_BANK0
           and then Done.TIMER.Arr (0);
      end;
   end loop;
end Unreset;
