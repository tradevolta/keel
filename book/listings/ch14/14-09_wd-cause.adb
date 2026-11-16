function Last_Cause return Reset_Cause is
   Reason : constant REASON_Register := WATCHDOG_Periph.REASON;
   Ours   : constant Boolean :=
     WATCHDOG_Periph.SCRATCH0 = Armed_Mark;
   Flags  : constant UInt32 := Words.Read (Words.CHIP_RESET);

   function Had (Bit : Natural) return Boolean is
     ((Shift_Right (Flags, Bit) and 1) = 1);
begin
   --  REASON is cleared by every chip-level reset, so if it is
   --  set, the watchdog's own reset came after them all
   if Reason.TIMER and then Ours then
      return Watchdog_Timeout;
   elsif Reason.FORCE and then Ours then
      return Watchdog_Forced;
   elsif Had (25) then             --  HAD_SWCORE_PD
      return Power_Up;
   elsif Had (28) or else Had (24) or else Had (23)
     or else Had (22)              --  HAD_WATCHDOG_RESET_*
   then
      --  A watchdog reset Keel didn't arm: the bootrom's reboot
      --  after a UF2 copy (5.2.2), a reset software asked for
      return Software;
   elsif Had (27) or else Had (21) or else Had (19) then
      return Debugger;             --  HZD, RESCUE, DP_RESET_REQ
   elsif Had (18) then             --  HAD_RUN_LOW
      return Reset_Pin;
   elsif Had (17) or else Had (16) then
      return Power_On;             --  HAD_BOR, HAD_POR
   else
      return Unknown;
   end if;
end Last_Cause;
