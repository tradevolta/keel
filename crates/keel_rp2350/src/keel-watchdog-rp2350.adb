--  SPDX-License-Identifier: Apache-2.0
with Keel.Clock;          use type Keel.Clock.Frequency;
with RP2350_SVD;          use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.PSM;      use RP2350_SVD.PSM;
with RP2350_SVD.TICKS;    use RP2350_SVD.TICKS;
with RP2350_SVD.WATCHDOG; use RP2350_SVD.WATCHDOG;
with RP2350_SVD.POWMAN_Words;

package body Keel.Watchdog.RP2350 is

   package Words renames RP2350_SVD.POWMAN_Words;
   package WDSEL_Bits is new RP2350_SVD.Atomic (WDSEL_Register);

   --  Keel's mark in watchdog scratch 0: "Keel armed the watchdog".
   --  Scratch 4 to 7 belong to the bootrom's watchdog boot vector
   --  (datasheet 5.2.4), so Keel keeps out of them.
   Armed_Mark : constant UInt32 := 16#4B45_454C#;

   Load_Value : LOAD_LOAD_Field := 0;

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

   procedure Start_Default (T : Timeout_Ms; Stat : out Status) is
   begin
      Start (T, Stat);
   end Start_Default;

   procedure Feed is
   begin
      WATCHDOG_Periph.LOAD := (LOAD => Load_Value, others => <>);
   end Feed;

   procedure Force is
   begin
      WATCHDOG_Periph.SCRATCH0 := Armed_Mark;
      WATCHDOG_Periph.CTRL.TRIGGER := True;
      loop
         null;
      end loop;
   end Force;

   function Remaining_us return Natural is
     (Natural (WATCHDOG_Periph.CTRL.TIME));

   function Chip_Reset_Flags return Natural is
     (Natural (Words.Read (Words.CHIP_RESET)));

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
end Keel.Watchdog.RP2350;
