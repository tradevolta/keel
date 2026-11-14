--  SPDX-License-Identifier: Apache-2.0
--  Where the servo's angle comes from. src/sweep/ is a stand-in that
--  sweeps from 0 to 180 degrees and back every 4 s; Chapter 11 adds
--  src/pot/, a potentiometer read by the ADC. ANGLE in the project
--  file picks one.
package Angle_Source is
   subtype Degrees is Natural range 0 .. 180;

   procedure Initialize;

   --  The angle for frame number Frame; frames come 50 a second
   function Angle (Frame : Natural) return Degrees;
end Angle_Source;
