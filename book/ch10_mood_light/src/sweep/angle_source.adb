--  SPDX-License-Identifier: Apache-2.0
--  The stand-in: a triangle wave, 100 frames up and 100 down
package body Angle_Source is

   procedure Initialize is null;

   function Angle (Frame : Natural) return Degrees is
      Phase : constant Natural := Frame mod 200;
   begin
      if Phase < 100 then
         return Phase * 180 / 100;
      else
         return (200 - Phase) * 180 / 100;
      end if;
   end Angle;
end Angle_Source;
