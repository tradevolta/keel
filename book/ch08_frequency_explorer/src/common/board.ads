--  SPDX-License-Identifier: Apache-2.0
--  What the frequency explorer needs from a board. Each board
--  directory has its own body; its pins are in its comments.
with Keel;       use Keel;
with Keel.Clock; use Keel.Clock;
with Explorer;   use Explorer;

package Board is
   --  The clock tree's numbers: the PLL's limits, its reference
   --  and the four steps the button walks through
   function Limits return PLL_Limits;
   function Reference return Frequency;
   type Step is range 1 .. 4;
   function Target (S : Step) return Frequency;

   --  Start the reference clock, the clock out and the console.
   --  Stops the program, after a message, if anything fails.
   procedure Initialize;

   --  Wait for the start of the next millisecond. The tick comes
   --  from the reference, so it does not change with clk_sys.
   procedure Next_Tick;

   --  Sample the button (once per tick): True when it went down
   function Pressed return Boolean;

   --  Run clk_sys as P says. Not_Supported: the board refuses the
   --  step (P is Refused, or the board's own limits say no).
   --  Timeout: the PLL did not lock. Either way clk_sys then runs
   --  from the reference.
   procedure Switch (P : Plan; Stat : out Status);

   --  clk_sys as the chip's own frequency counter sees it, or a
   --  note that the chip has none
   function Measured_Image return String;

   --  The supply current, or a note that there is no reading
   function Supply_Image return String;

   procedure Put_Line (Text : String);
end Board;
