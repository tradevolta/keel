--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. Lamps: Go on GP15, winner A on GP14, winner
--  B on GP13. Buttons to ground: A on GP16, B on GP17, with the
--  pads' pull-ups. TIMER0 counts microseconds; the console is RTT.
with Keel;                      use Keel;
with Keel.GPIO;                 use Keel.GPIO;
with Keel.GPIO.Input_Signature;
with Keel.GPIO.Output_Signature;
with Keel.GPIO.RP2350;          use Keel.GPIO.RP2350;
with Keel.Trace;
with Keel.Units;                use Keel.Units;
with Panel;
with RP2350_SVD.Atomic;
with RP2350_SVD.RESETS;         use RP2350_SVD.RESETS;
with RP2350_SVD.TICKS;          use RP2350_SVD.TICKS;
with RP2350_SVD.TIMER0;         use RP2350_SVD.TIMER0;

package body Board is

   --  The pins on the Pico 2 W's header. GP23, GP24, GP25 and GP29
   --  are wired to the wireless chip, not to the header.
   subtype Header_Pin is Pin_Id
     with Static_Predicate => Header_Pin in 0 .. 22 | 26 .. 28;

   Go_Pin       : constant Header_Pin := 15;
   Lamp_A_Pin   : constant Header_Pin := 14;
   Lamp_B_Pin   : constant Header_Pin := 13;
   Button_A_Pin : constant Header_Pin := 16;
   Button_B_Pin : constant Header_Pin := 17;

   Go_Lamp  : Output_Pin (Go_Pin);
   Lamp_A   : Output_Pin (Lamp_A_Pin);
   Lamp_B   : Output_Pin (Lamp_B_Pin);
   Button_A : Input_Pin (Button_A_Pin);
   Button_B : Input_Pin (Button_B_Pin);

   package Lamp_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
   package Button_Pins is new Keel.GPIO.Input_Signature (Input_Pin);
   package The_Panel is new Panel
     (Lamp_Pins, Button_Pins,
      Go_Lamp, Lamp_A, Lamp_B, Button_A, Button_B);

   --  clk_ref is the 12 MHz crystal (runtime startup): one tick per
   --  microsecond for TIMER0, as in Chapter 6
   Ref_Clock : constant Hertz := "12 MHz";
   Tick_Rate : constant Hertz := "1 MHz";

   type Count is mod 2**32;
   function Now return Count is (Count (TIMER0_Periph.TIMERAWL));
   Last_Tick : Count := 0;

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   procedure Start_Timer is
      Timer0_Only : constant RESET_TIMER_Field :=
        (As_Array => True, Arr => [0 => True, 1 => False]);
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta TIMER => Timer0_Only));
      loop
         exit when RESETS_Periph.RESET_DONE.TIMER.Arr (0);
      end loop;
      TICKS_Periph.TIMER0_CYCLES.TIMER0_CYCLES :=
        TIMER0_CYCLES_TIMER0_CYCLES_Field (Ref_Clock / Tick_Rate);
      TICKS_Periph.TIMER0_CTRL.ENABLE := True;
   end Start_Timer;

   --  A refused pin stops the game: say which, then wait for reset
   procedure Check (Stat : Status; What : String) is
   begin
      if Stat /= Ok then
         Keel.Trace.Put_Line
           ("reaction_time: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat : Status;
   begin
      Keel.Trace.Initialize;
      Start_Timer;
      Enable;
      Claim (Go_Lamp, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "GP15");
      Claim (Lamp_A, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "GP14");
      Claim (Lamp_B, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "GP13");
      Claim (Button_A, (Bias => Pull_Up), Stat);
      Check (Stat, "GP16");
      Claim (Button_B, (Bias => Pull_Up), Stat);
      Check (Stat, "GP17");
      Last_Tick := Now;
   end Initialize;

   procedure Next_Tick is
   begin
      --  Modular subtraction: right across the 2**32 us wrap
      while Now - Last_Tick < 1_000 loop
         null;
      end loop;
      Last_Tick := Last_Tick + 1_000;
   end Next_Tick;

   function Clock return Natural is (Natural (Now mod 2**31));

   function Presses return Players renames The_Panel.Presses;
   procedure Show (L : Lamps) renames The_Panel.Show;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
