--  SPDX-License-Identifier: Apache-2.0
package body Keel.ADC
  with SPARK_Mode
is
   --  Wide enough for every product here
   type Wide is range -(2**63 - 1) .. 2**63 - 1;

   --  V in whole millivolts
   function Millivolts (V : Volts) return Wide is
     (Wide (V / Volts'(0.001)))
     with Pre => V in -100.0 .. 100.0;

   Powers : constant array (0 .. 20) of Power :=
     [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1_024, 2_048, 4_096,
      8_192, 16_384, 32_768, 65_536, 131_072, 262_144, 524_288,
      1_048_576];

   function Two_To (N : Natural) return Power is (Powers (N));

   function Oversample (S : Scale; Total : Natural; K : Extra_Bits)
     return Code is
     (Natural'Min (Total / Two_To (K), Top (S, K)));

   function Mean (S : Scale; Total : Natural; N : Sample_Count)
     return Code
   is
      T : constant Wide := Wide (Total);
      Nearest : constant Wide := (2 * T + Wide (N)) / (2 * Wide (N));
   begin
      return Code (Wide'Min (Nearest, Wide (Top (S))));
   end Mean;

   function To_Volts (S : Scale; Value : Code; K : Extra_Bits := 0)
     return Volts
   is
      Steps : constant Wide := Wide (Two_To (S.Bits + K));
      Ref   : constant Wide := Millivolts (S.Reference);
      Mv    : Wide;
   begin
      pragma Assert (Ref in 500 .. 5_000);
      Mv := (2 * Wide (Value) * Ref * Wide (S.Divider) + Steps)
              / (2 * Steps);
      return Volts'(0.001) * Integer (Wide'Min (Mv, 100_000));
   end To_Volts;

   function Temperature (D : Diode_Sensor; V : Volts) return Celsius
   is
      --  Hundredths of a degree from T_Ref: microvolts from At_Ref,
      --  times 100, over the slope
      Delta_Uv : constant Wide :=
        (Millivolts (V) - Millivolts (D.At_Ref)) * 1_000;
      Centi : Wide := Wide (D.T_Ref) * 100
                      + Delta_Uv * 100 / Wide (D.Slope);
   begin
      Centi := Wide'Max (-27_315, Wide'Min (Centi, 100_000));
      return Celsius'(0.01) * Integer (Centi);
   end Temperature;
end Keel.ADC;
