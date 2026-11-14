--  SPDX-License-Identifier: Apache-2.0
--  Keel.Time and Keel.PWM on the host: time arithmetic, a table of
--  PWM settings for both chips, and the levels for duties and
--  widths, checked against values worked out by hand.
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;
with Keel;                 use Keel;
with Keel.PWM;             use Keel.PWM;
with Keel.PWM.Chip_Limits; use Keel.PWM.Chip_Limits;
with Keel.Time;
with Keel.Units;           use Keel.Units;

procedure Timer_Host is
   use type Keel.Time.Time;
   use type Keel.Time.Time_Span;

   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   function Img (N : Integer) return String is
      S : constant String := N'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   --  One row: the want, then Div (in sixteenths), Top and what
   --  the setting makes, or the status
   procedure Row
     (L : Counter_Limits; Clock, Want : Hertz; M : Shape)
   is
      S    : Setting;
      Stat : Status;
   begin
      Solve (L, Clock, Want, M, S, Stat);
      Put (Img (Integer (Want)) & " Hz"
           & (if M = Phase_Correct then " phase correct:"
              else " trailing edge:"));
      if Stat = Ok then
         Put_Line ("  div " & Img (Div (S)) & "/16, top "
                   & Img (Top (S)) & ", makes "
                   & Img (Integer (Output (S))) & " Hz");
      else
         Put_Line ("  " & Stat'Image);
      end if;
   end Row;

   --  Does Solve find exactly Div D and Top T?
   function Gives
     (L : Counter_Limits; Clock, Want : Hertz; M : Shape;
      D : Sixteenths; T : Keel.PWM.Count) return Boolean
   is
      S    : Setting;
      Stat : Status;
   begin
      Solve (L, Clock, Want, M, S, Stat);
      return Stat = Ok and then Div (S) = D and then Top (S) = T;
   end Gives;

   function Refuses
     (L : Counter_Limits; Clock, Want : Hertz; M : Shape)
      return Boolean
   is
      S    : Setting;
      Stat : Status;
   begin
      Solve (L, Clock, Want, M, S, Stat);
      return Stat = Not_Supported;
   end Refuses;

   function Solved
     (L : Counter_Limits; Clock, Want : Hertz; M : Shape)
      return Setting
   is
      S    : Setting;
      Stat : Status;
   begin
      Solve (L, Clock, Want, M, S, Stat);
      pragma Assert (Stat = Ok);
      return S;
   end Solved;

   type Wants is array (Positive range <>) of Hertz;
   Table : constant Wants := [1.0, 50.0, 1_000.0, 25_000.0];

   Sys : constant Hertz := "150 MHz";

   LED   : constant Setting :=
     Solved (RP2350_Slice, Sys, "1 kHz", Phase_Correct);
   Servo : constant Setting :=
     Solved (RP2350_Slice, Sys, "50 Hz", Trailing_Edge);

   T0 : constant Keel.Time.Time := 1_000_000;
begin
   Put_Line ("RP2350 slice from 150 MHz:");
   for W of Table loop
      Row (RP2350_Slice, Sys, W, Trailing_Edge);
      Row (RP2350_Slice, Sys, W, Phase_Correct);
   end loop;
   Put_Line ("STM32G474 timer from 150 MHz:");
   for W of Table loop
      Row (STM32G474_Timer, Sys, W, Trailing_Edge);
   end loop;

   Check ("20 ms is 20_000 us",
          Keel.Time.Milliseconds (20) = 20_000);
   Check ("1 s + 20 ms - 1 s is 20 ms",
          (T0 + Keel.Time.Milliseconds (20)) - T0 = 20_000);
   Check ("a span can be negative",
          T0 - (T0 + Keel.Time.Microseconds (5)) = -5);

   --  By hand: 16 * 150e6 / (65_535 * 2_000) is 18.3, so Div 19;
   --  2.4e9 / (19 * 2_000) is 63_157.9, so Top + 1 is 63_158
   Check ("RP2350 1 kHz phase correct is div 19/16, top 63157",
          Gives (RP2350_Slice, Sys, "1 kHz", Phase_Correct,
                 19, 63_157));
   --  2.4e9 / (65_535 * 50) is 732.5, so Div 733; 2.4e9 / 36_650
   --  is 65_484.3
   Check ("RP2350 50 Hz is div 733/16, top 65483",
          Gives (RP2350_Slice, Sys, "50 Hz", Trailing_Edge,
                 733, 65_483));
   Check ("RP2350 refuses 1 Hz (divider past 256)",
          Refuses (RP2350_Slice, Sys, "1 Hz", Trailing_Edge));
   Check ("RP2350 refuses 200 MHz (fewer than 2 counts)",
          Refuses (RP2350_Slice, Sys, "200 MHz", Trailing_Edge));
   --  Div 37 rounds up to 48, a whole 3; 2.4e9 / 48_000 is 50_000
   Check ("STM32 1 kHz is div 48/16, top 49999",
          Gives (STM32G474_Timer, Sys, "1 kHz", Trailing_Edge,
                 48, 49_999));
   Check ("STM32 50 Hz is div 736/16, top 65216",
          Gives (STM32G474_Timer, Sys, "50 Hz", Trailing_Edge,
                 736, 65_216));
   Check ("STM32 makes 1 Hz (PSC up to 65_536)",
          not Refuses (STM32G474_Timer, Sys, "1 Hz", Trailing_Edge));
   Check ("STM32 refuses phase correct",
          Refuses (STM32G474_Timer, Sys, "1 kHz", Phase_Correct));

   Check ("duty 0.0 is level 0", Level_For (LED, 0.0) = 0);
   Check ("duty 0.5 is level 31579", Level_For (LED, 0.5) = 31_579);
   Check ("duty 1.0 is Top + 1, always high",
          Level_For (LED, 1.0) = Top (LED) + 1);
   --  1500 us * 150 MHz * 16 / (733 * 1e6) is 4_911.3
   Check ("1500 us is level 4911",
          Width_Level (Servo, "1500 us") = 4_911);
   Check ("a whole period or more is Top + 1",
          Width_Level (Servo, "25 ms") = Top (Servo) + 1);

   if Failures > 0 then
      Put_Line (Natural'Image (Failures) & " failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Timer_Host;
