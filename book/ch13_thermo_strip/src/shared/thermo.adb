--  SPDX-License-Identifier: Apache-2.0
package body Thermo
  with SPARK_Mode
is
   --  Tenths of a degree in each half of the scale
   Span : constant := 100;

   --  Tenths of a degree from From to T, rounded to the nearest and
   --  at most Span
   function Tenths (T, From : Celsius) return Natural is
     (Natural'Min (Span, Natural ((T - From) * 10)))
     with Pre => T >= From and then T - From <= 10.0;

   function Colour_For (T : Celsius) return Colour is
   begin
      if T <= Cold then
         return Blue;
      elsif T < Mild then
         return Blend (Blue, Green,
                       Tenths (T, Cold), Span);
      elsif T < Warm then
         return Blend (Green, Red,
                       Tenths (T, Mild), Span);
      else
         return Red;
      end if;
   end Colour_For;

   function Strip_For (A, B : Celsius) return Strip_Colours is
     ([for I in Strip_Colours'Range =>
         Blend (Colour_For (A), Colour_For (B), I - 1, LEDs - 1)]);
end Thermo;
