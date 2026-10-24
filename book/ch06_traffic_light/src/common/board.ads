--  SPDX-License-Identifier: Apache-2.0
--  What the state machine needs from a board: three lamps and a clock.
--  Each board directory has its own body.
with Keel.Units; use Keel.Units;
with Traffic;    use Traffic;

package Board is
   --  Take the pins and the timer out of reset and set them up.
   procedure Initialize;

   --  Light exactly the lamps in Lamps.
   procedure Show (Lamps : Lamp_Set);

   --  Busy-wait for D from the microsecond timer.
   procedure Wait (D : Micro_Seconds);
end Board;
