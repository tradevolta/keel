--  Why the chip last started, as far as the chip can tell
type Reset_Cause is
  (Power_On,          --  power arrived, or the supply browned out
   Reset_Pin,         --  RUN (RP2350) or NRST (STM32G4) held low
   Debugger,          --  a reset request from the debug probe
   Software,          --  the program asked for a reset
   Watchdog_Timeout,  --  the watchdog counted down to zero
   Watchdog_Forced,   --  the program triggered the watchdog
   Power_Up,          --  a power-down state ended: a reboot
   Unknown);
