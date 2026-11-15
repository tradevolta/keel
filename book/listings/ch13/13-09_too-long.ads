--  SPDX-License-Identifier: Apache-2.0
--  Two mistakes GNATprove catches before the program runs: a delay
--  that does not fit beside two bits of optional side-set, and an
--  instruction that forgets the side-set its program must give.
with Keel.PIO; use Keel.PIO;
with Keel.PIO.Assembler;

package Too_Long
  with SPARK_Mode
is
   package Asm is new Keel.PIO.Assembler
     (Side_Bits => 2, Side_Optional => True);
   package Strict is new Keel.PIO.Assembler (Side_Bits => 1);

   --  Three bits of the field are side-set: at most [3]
   Slow : constant Instruction :=
     Asm.Set (Asm.Pins, 1, Side => 2, Idle => 7);

   --  Side-set is not optional here: every instruction gives it
   Bare : constant Instruction := Strict.Jmp (0);
end Too_Long;
