--  SPDX-License-Identifier: Apache-2.0
package body Keel.DAC
  with SPARK_Mode
is
   type Wide is range -(2**63 - 1) .. 2**63 - 1;

   function Millivolts (V : Volts) return Wide is
     (Wide (V / Volts'(0.001)))
     with Pre => V in -100.0 .. 100.0;

   --  1E9 / (2 pi), for C in nanofarads
   Inverse_Two_Pi : constant Wide := 159_154_943;

   function Corner (R : Ohms; C : Nanofarads) return Hertz is
      RC : constant Wide := Wide (R) * Wide (C);
      F  : constant Wide := (2 * Inverse_Two_Pi + RC) / (2 * RC);
   begin
      pragma Assert (F <= Inverse_Two_Pi);
      return Hertz'(1.0) * Integer (F);
   end Corner;

   function Ripple (Supply : Volts; F : Hertz; R : Ohms;
                    C : Nanofarads) return Volts
   is
      --  Millivolts: Supply * 1E9 / (4 F R C), C in nanofarads
      Den : constant Wide :=
        4 * Wide (F / Hertz'(1.0)) * Wide (R) * Wide (C);
      Mv  : constant Wide :=
        (2 * Millivolts (Supply) * 1_000_000_000 + Den) / (2 * Den);
   begin
      return Volts'(0.001) * Integer (Wide'Min (Mv, 5_000));
   end Ripple;

   function PWM_Level (S : Keel.PWM.Setting; Supply, V : Volts)
     return Keel.PWM.Count
   is
      Full : constant Wide := Wide (Keel.PWM.Top (S)) + 1;
      Su   : constant Wide := Millivolts (Supply);
      Mv   : constant Wide := Wide'Min (Millivolts (V), Su);
   begin
      return Keel.PWM.Count ((2 * Mv * Full + Su) / (2 * Su));
   end PWM_Level;
end Keel.DAC;
