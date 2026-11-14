--  SPDX-License-Identifier: Apache-2.0
--  The mood light's colors: a hue on the color wheel as red, green
--  and blue brightness, and the gamma table that turns a brightness
--  into the duty the eye sees as that brightness.
with Keel.PWM;

package Colors is
   --  Degrees around the wheel: red at 0, green at 120, blue at 240
   type Hue is mod 360;

   subtype Brightness is Natural range 0 .. 255;

   type RGB is record
      Red, Green, Blue : Brightness;
   end record;

   --  Cross-fade between neighboring primaries: the three always
   --  add up to 255
   function Wheel (H : Hue) return RGB;

   --  The duty that looks like brightness B: (B / 255) ** 2.2
   function Gamma (B : Brightness) return Keel.PWM.Duty;
end Colors;
