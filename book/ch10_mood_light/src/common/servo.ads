--  SPDX-License-Identifier: Apache-2.0
--  The SG92R hobby servo: a pulse every 20 ms, 1000 us wide for one
--  end of its travel and 2000 us for the other
with Angle_Source; use Angle_Source;
with Keel.Units;   use Keel.Units;

package Servo is
   Shortest : constant Micro_Seconds := 1_000.0;
   Longest  : constant Micro_Seconds := 2_000.0;

   function Width (A : Degrees) return Micro_Seconds is
     (Shortest + (Longest - Shortest) * A / 180);
end Servo;
