--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. The RGB LED's red, green and blue legs are on
--  GP0, GP1 and GP2 (PWM slices 0 and 1), each through a 220 ohm
--  resistor, and its common cathode goes to ground. The servo's
--  signal is on GP4 (slice 2), its power from VBUS. The meter
--  counts rising edges on GP7 (slice 3's B pin); a jumper from GP21,
--  which carries clk_sys / 1000, gives it something to measure.
--  TIMER0's alarm 0 times the meter's gate, 100 ms, so the meter
--  reads to 10 Hz. The console is RTT.
with Keel;              use type Keel.Status;
with Keel.Clock;        use type Keel.Clock.Frequency;
with Keel.Clock.RP2350; use Keel.Clock.RP2350;
with Keel.GPIO.RP2350;
with Keel.Interrupts;   use Keel.Interrupts;
with Keel.PWM.RP2350;   use Keel.PWM.RP2350;
with Keel.Sync.Bare;    use Keel.Sync.Bare;
with Keel.Time.Bare;
with Keel.Timer.RP2350; use Keel.Timer.RP2350;
with Keel.Trace;
with RP2350_SVD;        use type RP2350_SVD.Byte;
with RP2350_SVD.QMI;    use RP2350_SVD.QMI;
with Settings;

package body Board is

   --  True for a common-anode LED, whose legs light when low
   Common_Anode : constant Boolean := False;

   subtype Output is Keel.PWM.RP2350.Output;

   Red   : Output (0);
   Green : Output (1);
   Blue  : Output (2);
   Arm   : Output (4);
   Meter : Counter (7);
   Gate  : Alarm (0);

   --  A 100 ms gate: ten a second, so the meter reads to 10 Hz
   Gate_Time : constant Time_Span := Milliseconds (100);
   Per_Gate  : constant := 10;

   --  Shared with the handler. The program writes Opened before it
   --  sets the alarm, and reads Edges and Over after Closed.
   Opened   : Time := 0;
   Counting : Boolean := False;
   Edges    : Count := 0;
   Over     : Boolean := False;
   Closed   : Event;

   --  TIMER0_IRQ_0 (0): the gate opens, then closes 100 ms later.
   --  The second alarm counts from the first one's time, not from
   --  when its handler ran, so both edges of the gate see the same
   --  delay and the delay cancels.
   procedure Gate_Handler
     with Export, Convention => C, External_Name => "keel_isr_0";

   procedure Gate_Handler is
   begin
      Acknowledge (Gate);
      if not Counting then
         Start (Meter);
         Counting := True;
         Set (Gate, Opened + Gate_Time);
      else
         Stop (Meter);
         Counting := False;
         Edges := Value (Meter);
         Over := Wrapped (Meter);
         Signal (Closed);
      end if;
   end Gate_Handler;

   --  The Pico 2 W's flash is rated to a 133 MHz SCK, which is
   --  clk_sys / QMI M0_TIMING.CLKDIV (Chapter 8)
   Flash_Max : constant Keel.Clock.Frequency := 133_000_000;
   Target    : constant Keel.Clock.Frequency := 150_000_000;

   function Flash_Divisor return Keel.Clock.Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Keel.Clock.Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   procedure Check (Stat : Keel.Status; What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("mood_light: " & What & ": "
                              & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat  : Keel.Status;
      PLL   : Keel.Clock.PLL_Config;
      Found : Boolean;
      Light : Setting;
      Pulse : Setting;
   begin
      Keel.Trace.Initialize;
      Start_Crystal (Stat);
      Check (Stat, "crystal");
      Keel.Clock.Solve (PLL_SYS, Crystal, Target, False, PLL, Found);
      if Found and then Target / Flash_Divisor <= Flash_Max then
         Run_From_PLL (PLL, Stat);
         Check (Stat, "pll_sys");
      end if;
      Keel.Time.Bare.Start (Crystal);
      Keel.GPIO.RP2350.Enable;
      Keel.PWM.RP2350.Enable;

      --  Phase correct: the three legs' pulses share a centre
      Solve (Slice_Limits, Hertz (Sys_Frequency), "1 kHz",
             Phase_Correct, Light, Stat);
      Check (Stat, "LED setting");
      Claim (Red, Light, Stat, Inverted => Common_Anode);
      Check (Stat, "GP0");
      Claim (Green, Light, Stat, Inverted => Common_Anode);
      Check (Stat, "GP1");
      Claim (Blue, Light, Stat, Inverted => Common_Anode);
      Check (Stat, "GP2");

      Solve (Slice_Limits, Hertz (Sys_Frequency), "50 Hz",
             Trailing_Edge, Pulse, Stat);
      Check (Stat, "servo setting");
      Claim (Arm, Pulse, Stat);
      Check (Stat, "GP4");

      Claim (Meter, Stat);
      Check (Stat, "GP7");
      Start_Clock_Out (1_000, Stat);
      Check (Stat, "GP21");
      Claim (Gate, Stat);
      Check (Stat, "alarm 0");
      Set_Priority (IRQ_Of (0), 8);
      Clear_Pending (IRQ_Of (0));
      Keel.Interrupts.Enable (IRQ_Of (0));

      Put_Line ("mood_light: clk_sys" & Sys_Frequency'Image & " Hz");
      Put_Line ("mood_light: LED " & Settings.Image (Light));
      Put_Line ("mood_light: servo " & Settings.Image (Pulse));
   end Initialize;

   function Now return Time is (Keel.Time.Bare.Clock);

   procedure Wait_Until (Deadline : Time) is
   begin
      Keel.Time.Bare.Wait_Until (Deadline);
   end Wait_Until;

   procedure Set_Color (Red, Green, Blue : Duty) is
   begin
      Set_Level (Board.Red, Level_For (Setting_Of (Board.Red), Red));
      Set_Level (Board.Green,
                 Level_For (Setting_Of (Board.Green), Green));
      Set_Level (Board.Blue,
                 Level_For (Setting_Of (Board.Blue), Blue));
   end Set_Color;

   procedure Set_Pulse (Width : Micro_Seconds) is
   begin
      Set_Level (Arm, Width_Level (Setting_Of (Arm), Width));
   end Set_Pulse;

   --  The gate opens 1 ms from now, in the alarm's handler
   procedure Start_Meter is
   begin
      Opened := Now + Milliseconds (1);
      Set (Gate, Opened);
   end Start_Meter;

   procedure Read_Meter (Hz : out Natural; Stat : out Keel.Status) is
   begin
      Hz := 0;
      Wait (Closed, Now + Milliseconds (150), Stat);
      if Stat = Keel.Ok and then Over then
         Stat := Keel.Not_Supported;
      elsif Stat = Keel.Ok then
         Hz := Edges * Per_Gate;
      end if;
   end Read_Meter;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
