--  SPDX-License-Identifier: Apache-2.0
--  Keel.Watchdog: a countdown that resets the chip unless the program
--  feeds it in time, and the record of why the chip last started.
--  The counter is data, and Solve finds the setting for a timeout:
--  GNATprove proves that the watchdog never fires before the timeout
--  asked for, and at most one prescaled tick after it. The chip
--  packages, Keel.Watchdog.RP2350 and Keel.Watchdog.STM32G4, drive
--  the hardware.
package Keel.Watchdog
  with Pure, SPARK_Mode, No_Elaboration_Code_All
is
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

   --  A countdown watchdog. Its counter's clock runs at Clock hertz,
   --  divided by 2**Shift, Shift from Min_Shift to Max_Shift. The
   --  counter loads Reload, at most Max_Reload, and resets the chip
   --  after Reload counts, or Reload + 1 if Plus_One.
   type Counter_Limits is record
      Clock      : Positive range 1_000 .. 100_000_000;
      Min_Shift  : Natural range 0 .. 16;
      Max_Shift  : Natural range 0 .. 16;
      Max_Reload : Positive range 1 .. 2**24 - 1;
      Plus_One   : Boolean;
   end record
     with Predicate => Min_Shift <= Max_Shift;

   type Setting is record
      Shift  : Natural range 0 .. 16 := 0;
      Reload : Natural range 0 .. 2**24 - 1 := 0;
   end record;

   --  A timeout in milliseconds, up to an hour
   subtype Timeout_Ms is Positive range 1 .. 3_600_000;

   subtype Ticks_Count is Long_Long_Integer range 0 .. 2**50;

   --  2**Shift, as a table: no run-time exponent routine
   type Power_Table is array (0 .. 16) of Ticks_Count;
   Pow2 : constant Power_Table :=
     [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1_024, 2_048, 4_096,
      8_192, 16_384, 32_768, 65_536];

   --  Clock ticks before the watchdog fires
   function Ticks (L : Counter_Limits; S : Setting) return Ticks_Count
   is ((Long_Long_Integer (S.Reload)
        + (if L.Plus_One then 1 else 0)) * Pow2 (S.Shift));

   --  Clock ticks in T milliseconds, rounded up
   function Ticks_For (L : Counter_Limits; T : Timeout_Ms)
     return Ticks_Count
   is ((Long_Long_Integer (T) * Long_Long_Integer (L.Clock) + 999)
       / 1_000);

   function Fits (L : Counter_Limits; S : Setting) return Boolean is
     (S.Shift in L.Min_Shift .. L.Max_Shift
      and then S.Reload <= L.Max_Reload);

   --  The setting for T, with the smallest prescaler that reaches it.
   --  Found is False if even the largest setting is too short.
   procedure Solve
     (L : Counter_Limits; T : Timeout_Ms; S : out Setting;
      Found : out Boolean)
     with Post =>
       (if Found
        then Fits (L, S)
             and then Ticks (L, S) >= Ticks_For (L, T)
             and then Ticks (L, S) - Pow2 (S.Shift) < Ticks_For (L, T)
        else Ticks (L, (L.Max_Shift, L.Max_Reload))
               < Ticks_For (L, T));

   --  What a chip's watchdog provides
   generic
      --  Count down from T; reset the chip unless fed in time.
      --  Not_Supported: the counter cannot reach T.
      with procedure Start (T : Timeout_Ms; Stat : out Status);
      --  Start the countdown again from the top
      with procedure Feed;
      --  Why the chip last started
      with function Last_Cause return Reset_Cause;
   package Signature is
      pragma Warnings (Off, Start);
      pragma Warnings (Off, Feed);
      pragma Warnings (Off, Last_Cause);
   end Signature;
end Keel.Watchdog;
