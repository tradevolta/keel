--  SPDX-License-Identifier: Apache-2.0
--  The logic sampler's input, simulated: GP16's 500 Hz square wave
--  through 10 kohm into 100 nF, sampled at 500 kS/s by a 12-bit ADC
--  with 3.3 V full scale, plus a little noise. And a ring of 4096
--  samples, as on the board, that the fake engine fills.
with Keel.DMA.Buffers;
with Trigger;    use Trigger;

package Sim is
   Rate   : constant := 500_000;
   Period : constant := 1_000;  --  samples in 2 ms, one cycle

   --  The code the ADC gives for sample N, counted from a rising
   --  edge of the square wave, once the capacitor has settled
   function Code (N : Natural) return Sample;

   Ring_Slots : constant := 4_096;
   Ring_Wrap  : constant := 13;

   package Samples is new Keel.DMA.Buffers (Sample, Ring_Slots);

   --  A record takes the Alignment, as in the board's Buffers
   type Aligned_Ring is limited record
      B : Samples.Buffer;
   end record
     with Alignment => 2**Ring_Wrap;
   Ring_Box : Aligned_Ring;
   Ring : Samples.Buffer renames Ring_Box.B;
end Sim;
