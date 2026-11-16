procedure Initialize is
   Spare : constant Keel.Interrupts.IRQ := 46;  --  SPAREIRQ_IRQ_0
begin
   Awake_EN0 := From_EN0 (CLOCKS_Periph.SLEEP_EN0);
   Awake_EN1 := From_EN1 (CLOCKS_Periph.SLEEP_EN1);

   if (Words.Read (Words.CHIP_RESET) and Had_Swcore_PD) /= 0 then
      if AON.Alarm_Fired then
         Woke := Alarm;
      elsif (Words.Read (Words.PWRUP0) and Pwrup_Status) /= 0 then
         Woke := Wake_Pin;
      else
         Woke := Other;
      end if;
   end if;
   --  Disarm both wake sources, so the next power down starts
   --  clean: the Pico SDK's powman_disable_all_wakeups
   AON.Clear_Alarm;
   Words.Write (Words.PWRUP0, 16#3F#);
   Words.Write (Words.PWRUP0, 16#3F# or Pwrup_Status);

   --  After a watchdog reset the Pico SDK sleeps once, woken at
   --  once by a spare interrupt (runtime_init_rp2350_sleep_fix),
   --  before any real sleep. Keel does the same.
   if WATCHDOG_Periph.REASON.TIMER
     or else WATCHDOG_Periph.REASON.FORCE
   then
      Disable_Interrupts;
      Keel.Interrupts.Clear_Pending (Spare);
      Keel.Interrupts.Enable (Spare);
      Keel.Interrupts.Set_Pending (Spare);
      WFI;
      Keel.Interrupts.Disable (Spare);
      Keel.Interrupts.Clear_Pending (Spare);
      Enable_Interrupts;
   end if;
end Initialize;
