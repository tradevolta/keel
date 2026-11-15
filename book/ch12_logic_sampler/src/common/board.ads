--  SPDX-License-Identifier: Apache-2.0
--  What the sampler needs from a board. The body has its pins in its
--  comments.
with Interfaces;
with Keel.ADC.RP2350; use Keel.ADC.RP2350;
with Keel.DMA.RP2350; use Keel.DMA.RP2350;
with Keel.Time;       use Keel.Time;

package Board is
   --  The input the sampler watches: GP27, ADC input 1
   Probe : constant Channel_Set := [1 => True, others => False];

   --  The sampler's DMA channel, and the benchmark's two
   Sampler : constant Keel.DMA.RP2350.Channel := 0;
   Bench_A : constant Keel.DMA.RP2350.Channel := 1;
   Bench_B : constant Keel.DMA.RP2350.Channel := 2;

   --  Start the clocks, the time base, the console, the cycle
   --  counter, the ADC and its input, the test signal and the DMA.
   --  Stops the program, after a message, if any of them fails.
   procedure Initialize;

   function Now return Time;
   procedure Wait_Until (Deadline : Time);

   --  Core clock cycles, from the DWT counter (Chapter 4)
   function Cycles return Interfaces.Unsigned_32;

   --  Dropped if the console has no room
   procedure Put_Line (Text : String);
   --  Waits up to a second for room first: for the capture's lines
   procedure Put_Line_Waiting (Text : String);
end Board;
