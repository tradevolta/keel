--  SPDX-License-Identifier: Apache-2.0
--  The buffers the DMA works in, at library level, in .bss.
with Interfaces;       use Interfaces;
with Keel.DMA.Buffers;
with Trigger;

package Buffers is
   --  The sampler's ring: 4096 samples of 16 bits, 8 KB. The DMA
   --  wraps its write address on 2**13 bytes, so the ring starts on
   --  a multiple of 8 KB.
   Ring_Slots : constant := 4_096;
   Ring_Wrap  : constant := 13;

   package Samples is new Keel.DMA.Buffers (Trigger.Sample, Ring_Slots);
   type Aligned_Ring is limited record
      B : Samples.Buffer;
   end record
     with Alignment => 2**Ring_Wrap;
   Ring_Box : Aligned_Ring;
   Ring : Samples.Buffer renames Ring_Box.B;

   --  The benchmark's four blocks of 4 KB
   Block_Words : constant := 1_024;
   package Words is new Keel.DMA.Buffers (Unsigned_32, Block_Words);
   A, B, C, D : Words.Buffer;
end Buffers;
