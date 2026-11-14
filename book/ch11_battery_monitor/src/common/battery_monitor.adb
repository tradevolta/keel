--  SPDX-License-Identifier: Apache-2.0
--  The battery and light monitor. Twice a second it samples its slow
--  inputs round robin, 16 times each, and oversamples them to 14
--  bits: the light on the LDR, the PWM DAC read back, VSYS through
--  its divide-by-3 and the chip's temperature. Then it captures
--  100 ms of the sine from the NUCLEO, and steps the DAC.
with Board;           use Board;
with Buffers;
with Keel;            use type Keel.Status;
with Keel.ADC;        use Keel.ADC;
with Keel.ADC.RP2350; use Keel.ADC.RP2350;
with Keel.Time;       use Keel.Time;
with Keel.Units;      use Keel.Units;
with Readings;        use Readings;

procedure Battery_Monitor is
   Period : constant Time_Span := Milliseconds (500);

   --  16 samples of each slow input give 2 extra bits
   Extra : constant Extra_Bits := 2;

   Sine_Rate : constant Hertz := 10_000.0;

   --  VSYS reaches the pin through R5 and R6, a divide-by-3
   VSYS_Scale : constant Scale := (Converter with delta Divider => 3);

   --  The PWM DAC's steps, one each period
   Steps : constant array (1 .. 5) of Volts :=
     [0.5, 1.0, 1.5, 2.0, 2.5];
   Step  : Positive := 1;

   Next   : Time;
   Total  : Sums;
   Each   : Natural;
   Errors : Natural;
   Stat   : Keel.Status;

   function V (Input : Channel; S : Scale := Converter) return Volts is
     (To_Volts (S, Oversample (S, Total (Input), Extra), Extra));

   function Img (X : Volts) return String is (X'Image);
   function Percent (X : Volts) return Natural is
     (Natural (X / Volts'(0.033)));
begin
   Board.Initialize;
   Set_DAC (Steps (Step));
   Next := Now;
   loop
      Next := Next + Period;
      Wait_Until (Next);

      Capture (Slow, 40_000.0, Buffers.Slow, Errors, Stat);
      if Stat = Keel.Ok then
         Split (Slow, Buffers.Slow, Total, Each);
         Show (Lit_Count'Min (8, Percent (V (Light)) * 9 / 100));
         Put_Line
           ("monitor: VSYS" & Img (V (Battery, VSYS_Scale))
            & " V, light" & Percent (V (Light))'Image & " %, DAC"
            & Img (Steps (Step)) & " V set," & Img (V (Loopback))
            & " V read, chip"
            & Celsius'Image (Temperature (Sensor, V (Chip))) & " C");
      else
         Put_Line ("monitor: slow inputs: " & Stat'Image);
      end if;

      Capture (Sine_Only, Sine_Rate, Buffers.Sine, Errors, Stat);
      if Stat = Keel.Ok then
         declare
            W : constant Wave := Measure (Buffers.Sine, Sine_Rate);
         begin
            Put_Line
              ("monitor: sine" & Img (To_Volts (Converter, W.Low))
               & " V to" & Img (To_Volts (Converter, W.High))
               & " V, mean" & Img (To_Volts (Converter, W.Mean))
               & " V," & Natural (W.Frequency)'Image & " Hz");
         end;
      else
         Put_Line ("monitor: sine: " & Stat'Image);
      end if;

      Step := Step mod Steps'Length + 1;
      Set_DAC (Steps (Step));
   end loop;
end Battery_Monitor;
