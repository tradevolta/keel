--  SPDX-License-Identifier: Apache-2.0
--  What the mood light needs from a board. Each board directory has
--  its own body, with its pins in its comments.
with Keel;
with Keel.PWM;   use Keel.PWM;
with Keel.Time;  use Keel.Time;
with Keel.Units; use Keel.Units;

package Board is
   --  Start the clocks, the time base, the console, the LED's three
   --  outputs, the servo and the frequency meter. Stops the program,
   --  after a message, if any of them fails.
   procedure Initialize;

   function Now return Time;
   procedure Wait_Until (Deadline : Time);

   --  The LED's three duties, from 0.0 (off) to 1.0 (full on)
   procedure Set_Color (Red, Green, Blue : Duty);

   --  The servo's pulse: high for Width once a period
   procedure Set_Pulse (Width : Micro_Seconds);

   --  Start a measurement of the meter's input
   procedure Start_Meter;

   --  The frequency the last measurement found. Waits at most
   --  150 ms for it to finish. Timeout: it didn't finish.
   --  Not_Supported: more edges than the counter holds.
   procedure Read_Meter (Hz : out Natural; Stat : out Keel.Status);

   procedure Put_Line (Text : String);
end Board;
