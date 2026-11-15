--  SPDX-License-Identifier: Apache-2.0
--  The benchmark's four blocks of 4 KB, at library level, in .bss:
--  16 KB would not fit on the stack.
with Interfaces; use Interfaces;
with Keel.DMA.Buffers;

package Bench_Buffers is
   Block_Words : constant := 1_024;
   package Words is new Keel.DMA.Buffers (Unsigned_32, Block_Words);
   A, B, C, D : Words.Buffer;
end Bench_Buffers;
