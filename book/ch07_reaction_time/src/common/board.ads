--  SPDX-License-Identifier: Apache-2.0
--  What the game needs from a board. Each board directory has its
--  own body; the pins it claims are in its comments.
with Game; use Game;

package Board is
   --  Claim the pins, start the clock and the console. Stops the
   --  program (after a message, where it can) if a pin is refused.
   procedure Initialize;

   --  Wait for the start of the next millisecond
   procedure Next_Tick;

   --  A free-running microsecond count: the seed for the delay
   function Clock return Natural;

   --  Sample the buttons (once per tick) and show the lamps
   function Presses return Players;
   procedure Show (L : Lamps);

   procedure Put_Line (Text : String);
end Board;
