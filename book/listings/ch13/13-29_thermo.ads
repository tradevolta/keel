--  SPDX-License-Identifier: Apache-2.0
--  Thermo: two temperatures as colours on an 8-LED strip. Each
--  temperature has a colour, blue at 15 degrees C, green at 25, red
--  at 35 and beyond, and the strip fades from probe A's at LED 1 to
--  probe B's at LED 8. Shared: the host test runs it too.
with Keel.Units;          use Keel.Units;
with Keel.Drivers.WS2812; use Keel.Drivers.WS2812;

package Thermo
  with SPARK_Mode
is
   LEDs : constant := 8;
   subtype Strip_Colours is Colour_Array (1 .. LEDs);

   Cold : constant Celsius := 15.0;
   Mild : constant Celsius := 25.0;
   Warm : constant Celsius := 35.0;

   Blue  : constant Colour := (Red => 0, Green => 0, Blue => 255);
   Green : constant Colour := (Red => 0, Green => 255, Blue => 0);
   Red   : constant Colour := (Red => 255, Green => 0, Blue => 0);

   --  Blue up to Cold, blue to green to Mild, green to red to Warm,
   --  red beyond: in steps of a tenth of a degree
   function Colour_For (T : Celsius) return Colour;

   --  LED 1 shows A's colour, LED 8 B's, and the six between blend
   function Strip_For (A, B : Celsius) return Strip_Colours;
end Thermo;
