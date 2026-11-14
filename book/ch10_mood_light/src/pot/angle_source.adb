--  SPDX-License-Identifier: Apache-2.0
--  The potentiometer (Chapter 11): its wiper on GP26, ADC input 0,
--  and its ends on 3V3(OUT) and AGND. Each frame reads it 16 times,
--  oversampled to 14 bits, and maps the whole turn to 0 .. 180.
with Keel;              use type Keel.Status;
with Keel.ADC;          use Keel.ADC;
with Keel.ADC.RP2350;   use Keel.ADC.RP2350;
with Keel.Clock;
with Keel.Clock.RP2350; use Keel.Clock.RP2350;
with Keel.Trace;

package body Angle_Source is

   Wiper : constant Channel := 0;
   Extra : constant Extra_Bits := 2;

   procedure Initialize is
      Stat  : Keel.Status;
      PLL   : Keel.Clock.PLL_Config;
      Found : Boolean;
   begin
      --  clk_adc: 48 MHz from pll_usb, solved like pll_sys
      Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, PLL,
                        Found);
      Stat := (if Found then Keel.Ok else Keel.Not_Supported);
      if Stat = Keel.Ok then
         Start_ADC_Clock (PLL, Stat);
      end if;
      if Stat = Keel.Ok then
         Enable (Stat);
      end if;
      if Stat = Keel.Ok then
         Claim (Wiper, Stat);
      end if;
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("mood_light: pot: " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Initialize;

   function Angle (Frame : Natural) return Degrees is
      pragma Unreferenced (Frame);
      Total : Natural := 0;
      C     : Code;
      Stat  : Keel.Status;
   begin
      for I in 1 .. Samples_For (Extra) loop
         Read (Wiper, C, Stat);
         Total := Total + C;
      end loop;
      return Oversample (Converter, Total, Extra) * 180
               / Top (Converter, Extra);
   end Angle;
end Angle_Source;
