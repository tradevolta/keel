--  SPDX-License-Identifier: Apache-2.0
with Interfaces;

package Scratch is
   --  A buffer in SCRATCH_X, aligned as a DMA ring would need. It
   --  is NOLOAD: nothing initializes it.
   Samples : array (1 .. 64) of Interfaces.Unsigned_32
     with Linker_Section => ".scratch_x", Alignment => 256;
end Scratch;
