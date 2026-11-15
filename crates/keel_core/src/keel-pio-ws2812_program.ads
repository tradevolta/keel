--  SPDX-License-Identifier: Apache-2.0
--  The WS2812 program: one data pin, driven by side-set. Each bit is
--  10 cycles: high for T1, then high (a 1) or low (a 0) for T2, then
--  low for T3. Run the machine at 10 cycles a bit, 8 MHz for 800
--  kbit/s, shifting OUT left with autopull at 24 bits, and put each
--  pixel's 24 GRB bits at the top of a word. After the datasheet's
--  example, 11.6.2. The host test checks the words against pioasm's.
with Keel.PIO.Assembler;

package Keel.PIO.WS2812_Program
  with SPARK_Mode
is
   package Asm is new Keel.PIO.Assembler (Side_Bits => 1);
   use Asm;

   T1 : constant := 3;
   T2 : constant := 3;
   T3 : constant := 4;
   Cycles_Per_Bit : constant := T1 + T2 + T3;

   --  Labels
   Bit_Loop : constant Address := 0;
   Do_Zero  : constant Address := 3;

   Code : constant Program :=
     (Last          => 3,
      Code          =>
        [Out_To (X, 1, Side => 0, Idle => T3 - 1),
         Jmp (Do_Zero, X_Zero, Side => 1, Idle => T1 - 1),
         --  Do_One: stay high
         Jmp (Bit_Loop, Side => 1, Idle => T2 - 1),
         --  Do_Zero: go low
         Nop (Side => 0, Idle => T2 - 1)],
      Wrap_Target   => Bit_Loop,
      Wrap          => Do_Zero,
      Side_Bits     => 1,
      Side_Optional => False);
end Keel.PIO.WS2812_Program;
