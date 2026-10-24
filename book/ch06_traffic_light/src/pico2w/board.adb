--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board: red on GP15, amber on GP14, green on GP13, and
--  TIMER0 counting microseconds. Every register is a generated one.
with RP2350_SVD.Atomic;
with RP2350_SVD.IO_BANK0;   use RP2350_SVD.IO_BANK0;
with RP2350_SVD.PADS_BANK0; use RP2350_SVD.PADS_BANK0;
with RP2350_SVD.RESETS;     use RP2350_SVD.RESETS;
with RP2350_SVD.SIO_Pins;   use RP2350_SVD.SIO_Pins;
with RP2350_SVD.TICKS;      use RP2350_SVD.TICKS;
with RP2350_SVD.TIMER0;     use RP2350_SVD.TIMER0;

package body Board is

   Pin_Of : constant array (Lamp) of Pin :=
     [Red => 15, Amber => 14, Green => 13];

   function Pins (Lamps : Lamp_Set) return Pin_Set is
     [for P in Pin =>
        (for some L in Lamp => Lamps (L) and then Pin_Of (L) = P)];

   All_Lamps : constant Pin_Set := Pins ([others => True]);

   --  clk_ref runs from the 12 MHz crystal (runtime startup); the
   --  tick generator divides it down to one tick per microsecond.
   Ref_Clock : constant Hertz := "12 MHz";
   Tick_Rate : constant Hertz := "1 MHz";

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

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

   --  Output pads: no pull-down, not isolated, the rest at reset
   Output_Pad : constant GPIO_Register :=
     (PDE => False, ISO => False, others => <>);

   procedure Initialize is
   begin
      Unreset;

      --  One tick per microsecond for TIMER0
      TICKS_Periph.TIMER0_CYCLES.TIMER0_CYCLES :=
        TIMER0_CYCLES_TIMER0_CYCLES_Field (Ref_Clock / Tick_Rate);
      TICKS_Periph.TIMER0_CTRL.ENABLE := True;

      --  Each pin's function select has its own type: sio_15 is a
      --  GPIO15_CTRL_FUNCSEL_Field and fits no other pin.
      IO_BANK0_Periph.GPIO15_CTRL := (FUNCSEL => sio_15, others => <>);
      IO_BANK0_Periph.GPIO14_CTRL := (FUNCSEL => sio_14, others => <>);
      IO_BANK0_Periph.GPIO13_CTRL := (FUNCSEL => sio_13, others => <>);

      PADS_BANK0_Periph.GPIO15 := Output_Pad;
      PADS_BANK0_Periph.GPIO14 := Output_Pad;
      PADS_BANK0_Periph.GPIO13 := Output_Pad;

      Output_Clear (All_Lamps);
      Enable_Output (All_Lamps);
   end Initialize;

   procedure Show (Lamps : Lamp_Set) is
   begin
      Output_Clear (All_Lamps and not Pins (Lamps));
      Output_Set (Pins (Lamps));
   end Show;

   --  TIMERAWL is a count, not a mask: it gets a count type of its own
   type Count is mod 2**32;

   function Now return Count is (Count (TIMER0_Periph.TIMERAWL));

   procedure Wait (D : Micro_Seconds) is
      Start : constant Count := Now;
   begin
      --  Modular subtraction: correct across the 2**32 us wrap
      while Now - Start < Count (D) loop
         null;
      end loop;
   end Wait;
end Board;
