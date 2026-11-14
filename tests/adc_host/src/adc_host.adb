--  SPDX-License-Identifier: Apache-2.0
--  Keel.ADC and Keel.DAC on the host: codes to volts, oversampling a
--  noisy input, the RP2350's temperature sensor, and the PWM-DAC's
--  levels and filter, checked against values worked out by hand.
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;
with Keel;                 use Keel;
with Keel.ADC;             use Keel.ADC;
with Keel.ADC.Chip_Limits; use Keel.ADC.Chip_Limits;
with Keel.DAC;             use Keel.DAC;
with Keel.PWM;             use Keel.PWM;
with Keel.PWM.Chip_Limits; use Keel.PWM.Chip_Limits;
with Keel.Units;           use Keel.Units;

procedure ADC_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   --  Volts'Image is " 1.650": drop the space
   function Img (V : Volts) return String is
      S : constant String := V'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   function Img (T : Celsius) return String is
      S : constant String := T'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   ADC  : constant Scale := RP2350_ADC;
   VSYS : constant Scale := (RP2350_ADC with delta Divider => 3);

   --  A noisy input at True_V: each sample is the nearest code to
   --  True_V plus noise of up to 2 codes either way, from a fixed
   --  sequence so every run prints the same
   Seed : Natural := 12_345;

   function Noisy_Sample (True_V : Float) return Natural is
      Exact : constant Float := True_V / 3.3 * 4096.0;
      Noise : Float;
   begin
      Seed := (Seed * 1_103 + 12_345) mod 65_536;
      Noise := Float (Seed) / 65_536.0 * 4.0 - 2.0;
      return Natural (Float'Rounding (Exact + Noise));
   end Noisy_Sample;

   procedure Oversampled (True_V : Float; K : Extra_Bits) is
      Total : Natural := 0;
   begin
      for I in 1 .. Samples_For (K) loop
         Total := Total + Noisy_Sample (True_V);
      end loop;
      Put_Line
        ((if Samples_For (K) < 10 then "   "
          elsif Samples_For (K) < 100 then "  " else " ")
         & Samples_For (K)'Image
         & (if K = 0 then " sample, " else " samples,")
         & Integer'Image (12 + K) & " bits: "
         & Img (To_Volts (ADC, Oversample (ADC, Total, K), K)) & " V");
   end Oversampled;

   type Codes is array (Positive range <>) of Code;
   Plain   : constant Codes := [0, 1, 1_241, 2_048, 4_095];
   Battery : constant Codes := [1_241, 1_489, 1_861];
   Sensor  : constant Codes := [800, 876, 891, 900];

   Sys  : constant Hertz := "150 MHz";
   PWM_DAC : Setting;
   Stat : Status;
begin
   Put_Line ("RP2350 ADC, 12 bits, 3.3 V reference:");
   for C of Plain loop
      Put_Line ("  code" & C'Image & ": " & Img (To_Volts (ADC, C))
                & " V");
   end loop;
   Put_Line ("VSYS through the divide-by-3:");
   for C of Battery loop
      Put_Line ("  code" & C'Image & ": " & Img (To_Volts (VSYS, C))
                & " V");
   end loop;

   Put_Line ("A noisy input at 1.2340 V:");
   for K in Extra_Bits loop
      Oversampled (1.2340, K);
   end loop;

   Put_Line ("Temperature sensor:");
   for C of Sensor loop
      Put_Line ("  code" & C'Image & ": "
                & Img (To_Volts (ADC, C)) & " V, "
                & Img (Temperature (RP2350_Sensor, To_Volts (ADC, C)))
                & " C");
   end loop;

   Solve (RP2350_Slice, Sys, "150 kHz", Trailing_Edge, PWM_DAC, Stat);
   Put_Line ("PWM-DAC, 150 kHz from 150 MHz: top"
             & Top (PWM_DAC)'Image);
   Put_Line ("  10 kOhm and 100 nF: corner"
             & Natural (Corner (10_000, 100))'Image & " Hz, ripple "
             & Img (Ripple (3.3, "150 kHz", 10_000, 100)) & " V");

   --  4095 * 3300 / 4096 is 3299.2 mV
   Check ("code 4095 is 3.299 V", To_Volts (ADC, 4_095) = 3.299);
   Check ("code 2048 is 1.650 V", To_Volts (ADC, 2_048) = 1.650);
   --  1489 * 9900 / 4096 is 3598.9 mV
   Check ("VSYS code 1489 is 3.599 V", To_Volts (VSYS, 1_489) = 3.599);
   Check ("16 samples give 14 bits: 4 * 2048 is 1.650 V",
          To_Volts (ADC, Oversample (ADC, 16 * 2_048, 2), 2) = 1.650);
   Check ("the top of 16 bits is 4095 * 16",
          Oversample (ADC, 256 * 4_095, 4) = 65_520);
   Check ("the mean of 2048 and 2049 rounds up to 2049",
          Mean (ADC, 4_097, 2) = 2_049);
   Check ("0.706 V is 27.00 C",
          Temperature (RP2350_Sensor, 0.706) = 27.0);
   --  The datasheet's example: code 891 at 3.3 V is 20.1 C; 891 is
   --  0.718 V to 1 mV, and 12 mV / 1.721 mV is 6.97 degrees
   Check ("code 891 is 20.03 C",
          Temperature (RP2350_Sensor, To_Volts (ADC, 891)) = 20.03);
   Check ("150 kHz PWM-DAC is div 16/16, top 999",
          Stat = Ok and then Div (PWM_DAC) = 16
          and then Top (PWM_DAC) = 999);
   Check ("1.65 V is level 500",
          PWM_Level (PWM_DAC, 3.3, 1.65) = 500);
   Check ("3.3 V and above is Top + 1, always high",
          PWM_Level (PWM_DAC, 3.3, 4.0) = 1_000);
   --  1e9 / (2 pi * 1e6) is 159.15
   Check ("10 kOhm and 100 nF: corner 159 Hz",
          Corner (10_000, 100) = 159.0);
   --  3300 mV * 1e9 / (4 * 150e3 * 1e6) is 5.5 mV
   Check ("ripple at 150 kHz is 0.006 V",
          Ripple (3.3, "150 kHz", 10_000, 100) = 0.006);

   if Failures > 0 then
      Put_Line (Natural'Image (Failures) & " failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end ADC_Host;
