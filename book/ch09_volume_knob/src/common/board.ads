--  SPDX-License-Identifier: Apache-2.0
--  What the volume knob needs from a board. Each board directory
--  has its own body; its pins are in its comments. The board's
--  interrupt handler decodes the encoder and signals a change.
with Keel.Quadrature;

package Board is
   --  The knob's range: 32 counts, 8 detents of a typical encoder
   subtype Volume is Keel.Quadrature.Count range 0 .. 32;

   --  As many LEDs as the bar has
   subtype Lit_Count is Natural range 0 .. 8;

   --  Start the console, the encoder pins, the LEDs and the
   --  interrupt. Stops the program, after a message, if any fails.
   procedure Initialize;

   --  Sleep until the handler has seen the knob move or the push
   --  switch close since the last call
   procedure Wait_For_Change;

   --  The handler's numbers, read together in a critical section
   procedure Read (Position : out Volume; Misses : out Natural);

   --  The push switch closed since the last call
   function Pressed return Boolean;

   --  Light the first Lit LEDs of the bar, the rest off
   procedure Show (Lit : Lit_Count);

   procedure Put_Line (Text : String);
end Board;
