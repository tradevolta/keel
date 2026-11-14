--  SPDX-License-Identifier: Apache-2.0
--  The capture buffers, at library level, in .bss: 4 KB of samples
--  would not fit on the 4 KB main stack (Chapter 5's memory map).
with Keel.ADC.RP2350; use Keel.ADC.RP2350;

package Buffers is
   --  16 samples of each of four slow inputs, round robin
   Slow : Sample_Array (1 .. 64);
   --  100 ms of the sine at 10 kS/s: five periods at 50 Hz
   Sine : Sample_Array (1 .. 1_000);
end Buffers;
