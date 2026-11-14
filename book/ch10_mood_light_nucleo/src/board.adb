--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. The RGB LED's red, green and blue legs
--  are on Arduino D5 (PB4), D9 (PC7) and A3 (PB0): TIM3's channels
--  1, 2 and 3. The servo's signal is on D10 (PB6), TIM4's channel 1.
--  The meter counts rising edges on A0 (PA0) with TIM2; a jumper
--  from D7 (PA8), which carries SYSCLK / 16 (MCO), gives it
--  something to measure. There is no spare alarm, so the meter's
--  gate is the time from Start_Meter to Read_Meter, measured with
--  Keel.Time: about a second in the mood light, so it reads to
--  1 Hz. The console is RTT.
with Keel;               use type Keel.Status;
with Keel.Clock;         use type Keel.Clock.Frequency;
with Keel.Clock.STM32G4; use Keel.Clock.STM32G4;
with Keel.GPIO.STM32G4;  use Keel.GPIO.STM32G4;
with Keel.PWM.STM32G4;   use Keel.PWM.STM32G4;
with Keel.Time.Bare;
with Keel.Trace;
with Settings;

package body Board is

   --  True for a common-anode LED, whose legs light when low
   Common_Anode : constant Boolean := False;

   subtype Output is Keel.PWM.STM32G4.Output;

   Red   : Output (TIM3, 1, B, 4);
   Green : Output (TIM3, 2, C, 7);
   Blue  : Output (TIM3, 3, B, 0);
   Arm   : Output (TIM4, 1, B, 6);
   Meter : Counter;

   --  DS12288, Table 13: TIM3 and TIM4 on these pins are AF2
   Timer_AF : constant Alternate_Function := 2;

   Opened : Time := 0;

   Target : constant Keel.Clock.Frequency := 150_000_000;

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
      PLL_Setting : Keel.Clock.PLL_Config;
      Found : Boolean;
      Light : Setting;
      Pulse : Setting;
   begin
      Keel.Trace.Initialize;
      Keel.Clock.Solve (PLL, HSI16, Target, False, PLL_Setting, Found);
      if Found then
         Run_From_PLL (PLL_Setting, Stat);
         Check (Stat, "PLL");
      end if;
      Keel.Time.Bare.Start (Sys_Frequency);

      --  Trailing edge: Keel offers no phase-correct mode here
      Solve (Timer_Limits, Hertz (Sys_Frequency), "1 kHz",
             Trailing_Edge, Light, Stat);
      Check (Stat, "LED setting");
      Claim (Red, Light, Timer_AF, Stat, Inverted => Common_Anode);
      Check (Stat, "PB4");
      Claim (Green, Light, Timer_AF, Stat, Inverted => Common_Anode);
      Check (Stat, "PC7");
      Claim (Blue, Light, Timer_AF, Stat, Inverted => Common_Anode);
      Check (Stat, "PB0");

      Solve (Timer_Limits, Hertz (Sys_Frequency), "50 Hz",
             Trailing_Edge, Pulse, Stat);
      Check (Stat, "servo setting");
      Claim (Arm, Pulse, Timer_AF, Stat);
      Check (Stat, "PB6");

      Claim (Meter, Stat);
      Check (Stat, "PA0");
      Start_Clock_Out (Stat);
      Check (Stat, "PA8");

      Put_Line ("mood_light: SYSCLK" & Sys_Frequency'Image & " Hz");
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

   procedure Start_Meter is
   begin
      Start (Meter);
      Opened := Now;
   end Start_Meter;

   --  Edges over the time since Start_Meter: never waits
   procedure Read_Meter (Hz : out Natural; Stat : out Keel.Status) is
      Gate  : constant Time_Span := Now - Opened;
      Edges : Natural;
   begin
      Stop (Meter);
      Edges := Value (Meter);
      Hz := 0;
      if Wrapped (Meter) then
         Stat := Keel.Not_Supported;
      elsif Gate <= 0 then
         Stat := Keel.Timeout;
      else
         Hz := Natural (Long_Long_Integer (Edges) * 1_000_000
                        / Long_Long_Integer (Gate));
         Stat := Keel.Ok;
      end if;
   end Read_Meter;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
