--  SPDX-License-Identifier: Apache-2.0
--  Keel.PIO: programs for the RP2350's programmable I/O, as data. A
--  PIO program is up to 32 instructions of 16 bits each, run by a
--  state machine one instruction a cycle (RP2350 datasheet, 11.1).
--  Keel.PIO.Assembler builds the instructions from Ada calls, so a
--  program is a constant that the compiler and GNATprove check, and
--  the chip's driver, Keel.PIO.RP2350, loads and runs it. Nothing
--  here touches a register: the host tests and the prover see the
--  same programs as the board.
package Keel.PIO
  with Pure, SPARK_Mode
is
   type Instruction is mod 2**16;
   --  A word through a FIFO
   type Word is mod 2**32;

   --  A slot in a block's 32-instruction memory
   type Address is range 0 .. 31;
   type Instruction_Array is array (Address range <>) of Instruction;

   --  The opcode, bits 15 to 13 (datasheet 11.4, Table 1014). PUSH
   --  and PULL share one; bit 7 tells them apart.
   type Opcode is
     (Jmp_Op, Wait_Op, In_Op, Out_Op, Push_Pull_Op, Mov_Op, Irq_Op,
      Set_Op);

   function Opcode_Of (I : Instruction) return Opcode is
     (Opcode'Val (I / 2**13));

   --  A JMP's target, bits 4 to 0
   function Target_Of (I : Instruction) return Address is
     (Address (I mod 32));

   --  JMP targets are slots, counted from the start of memory. A
   --  program is written from slot 0 and loaded at Offset, so each
   --  JMP's target moves by Offset; every other instruction stays.
   function Relocated (I : Instruction; Offset : Address)
     return Instruction
   is
     (if Opcode_Of (I) = Jmp_Op
      then I - I mod 32
           + Instruction ((Target_Of (I) + Offset) mod 32)
      else I)
     with Pre  => Integer (Target_Of (I)) + Integer (Offset) <= 31,
          Post => Opcode_Of (Relocated'Result) = Opcode_Of (I)
                  and then (if Opcode_Of (I) = Jmp_Op
                            then Target_Of (Relocated'Result)
                                 = Target_Of (I) + Offset
                            else Relocated'Result = I);

   --  Side-set: up to 5 bits of an instruction's delay field drive
   --  pins as it runs. Optional side-set spends one of them on an
   --  enable bit (datasheet 11.5.1).
   subtype Side_Count is Natural range 0 .. 5;

   --  A program of Last + 1 instructions, from slot 0
   type Program (Last : Address) is record
      Code : Instruction_Array (0 .. Last);
      --  After the instruction at Wrap, the next is Wrap_Target's:
      --  a loop that costs no cycle (.wrap_target and .wrap)
      Wrap_Target   : Address := 0;
      Wrap          : Address := 0;
      --  The side-set the program was assembled for
      Side_Bits     : Side_Count := 0;
      Side_Optional : Boolean := False;
   end record;

   --  Wrap is in the program, after Wrap_Target, every JMP lands in
   --  it, and the side-set fits the delay field
   function Well_Formed (P : Program) return Boolean is
     (P.Wrap_Target <= P.Wrap
      and then P.Wrap <= P.Last
      and then P.Side_Bits + Boolean'Pos (P.Side_Optional) <= 5
      and then (for all I of P.Code =>
                  (if Opcode_Of (I) = Jmp_Op
                   then Target_Of (I) <= P.Last)));

   --  A state machine's clock divider: Int + Frac / 256, from 1.0 to
   --  65536.0 (datasheet 11.5.5). The machine runs one cycle every
   --  Int + Frac / 256 system clock cycles.
   type Divider is record
      Int  : Positive range 1 .. 65_536 := 1;
      Frac : Natural range 0 .. 255 := 0;
   end record;

   --  The divider that runs a machine at Rate cycles a second from a
   --  Clock-Hz system clock: Clock / Rate, rounded down to 1/256.
   --  Exact when Rate divides 256 * Clock.
   function Divider_For (Clock, Rate : Positive) return Divider
     with Pre  => Rate <= Clock and then Clock / Rate <= 65_535,
          Post => Long_Long_Integer (Divider_For'Result.Int) * 256
                  + Long_Long_Integer (Divider_For'Result.Frac)
                  = Long_Long_Integer (Clock) * 256
                    / Long_Long_Integer (Rate);
end Keel.PIO;
