--  SPDX-License-Identifier: Apache-2.0
--  What the monitor needs from a board. The body has its pins in its
--  comments.
with Keel.ADC.RP2350; use Keel.ADC.RP2350;
with Keel.Time;       use Keel.Time;
with Keel.Units;      use Keel.Units;

package Board is
   --  The ADC's inputs, by what is wired to them
   Light    : constant Channel := 0;
   Loopback : constant Channel := 1;
   Sine     : constant Channel := 2;
   Battery  : constant Channel := 3;
   Chip     : constant Channel := Temperature_Sensor;

   --  The monitor's slow inputs, sampled round robin
   Slow : constant Channel_Set :=
     [Light | Loopback | Battery | Chip => True, others => False];
   Sine_Only : constant Channel_Set :=
     [Sine => True, others => False];

   --  As many LEDs as the bar has
   subtype Lit_Count is Natural range 0 .. 8;

   --  Start the clocks, the time base, the console, the ADC and its
   --  inputs, the PWM DAC and the LED bar. Stops the program, after
   --  a message, if any of them fails.
   procedure Initialize;

   function Now return Time;
   procedure Wait_Until (Deadline : Time);

   --  The PWM DAC's output, on GP16 through its RC filter
   procedure Set_DAC (V : Volts);

   --  Light the first Lit LEDs of the bar, the rest off
   procedure Show (Lit : Lit_Count);

   procedure Put_Line (Text : String);
end Board;
