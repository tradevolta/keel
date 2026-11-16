procedure Start
  (T : Timeout_Ms; Stat : out Status;
   Pause_On_Debug : Boolean := True)
is
   S     : Setting;
   Found : Boolean;
begin
   Solve (Limits, T, S, Found);
   if not Found then
      Stat := Not_Supported;
      return;
   end if;

   WATCHDOG_Periph.CTRL.ENABLE := False;
   --  A 1 us tick from clk_ref, the 12 MHz crystal (8.5)
   TICKS_Periph.WATCHDOG_CTRL.ENABLE := False;
   TICKS_Periph.WATCHDOG_CYCLES.WATCHDOG_CYCLES :=
     WATCHDOG_CYCLES_WATCHDOG_CYCLES_Field
       (Keel.Clock.RP2350.Crystal / 1_000_000);
   TICKS_Periph.WATCHDOG_CTRL.ENABLE := True;

   --  A timeout resets everything but the two oscillators
   WDSEL_Bits.Set
     (PSM_Periph.WDSEL,
      (WDSEL_Register'(others => <>) with delta
         PROC_COLD => True, OTP => True, RESETS => True,
         CLOCKS => True, PSM_READY => True, BUSFABRIC => True,
         ROM => True, BOOTRAM => True,
         SRAM => (As_Array => False, Val => 16#3FF#),
         XIP => True, SIO => True, ACCESSCTRL => True,
         PROC => (As_Array => False, Val => 2#11#)));

   WATCHDOG_Periph.SCRATCH0 := Armed_Mark;
   WATCHDOG_Periph.CTRL :=
     (PAUSE_JTAG => Pause_On_Debug,
      PAUSE_DBG  => (As_Array => False,
                     Val => (if Pause_On_Debug then 2#11# else 0)),
      ENABLE     => False,
      others     => <>);
   Load_Value := LOAD_LOAD_Field (S.Reload);
   Feed;
   WATCHDOG_Periph.CTRL.ENABLE := True;
   Stat := Ok;
end Start;
