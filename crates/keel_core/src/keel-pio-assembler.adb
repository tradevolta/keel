--  SPDX-License-Identifier: Apache-2.0
package body Keel.PIO.Assembler
  with SPARK_Mode
is
   --  Bits 15 to 8: the opcode and the side-set/delay field
   function Head (Op : Opcode; Side : Side_Value; Idle : Natural)
     return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Head'Result mod 256 = 0
                  and then Opcode_Of (Head'Result) = Op;

   function Head (Op : Opcode; Side : Side_Value; Idle : Natural)
     return Instruction
   is
      --  The side-set value above the delay, its enable bit on top
      Field : constant Natural :=
        (if Side = No_Side then Idle
         else Idle + Side * 2**(5 - Field_Bits)
              + Boolean'Pos (Side_Optional) * 16);
   begin
      pragma Assert (Field < 32);
      return Instruction (Opcode'Pos (Op)) * 2**13
        + Instruction (Field) * 2**8;
   end Head;

   function Code (B : Boolean) return Instruction is
     (if B then 1 else 0);

   function Jmp
     (Target : Address;
      Cond   : Condition := Always;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
   is (Head (Jmp_Op, Side, Idle)
       + Instruction (Condition'Pos (Cond)) * 32
       + Instruction (Target));

   function Wait
     (Polarity : Boolean;
      Source   : Wait_Source;
      Index    : Wait_Index;
      Side     : Side_Value := No_Side;
      Idle     : Natural := 0) return Instruction
   is (Head (Wait_Op, Side, Idle) + Code (Polarity) * 128
       + Instruction (Wait_Source'Pos (Source)) * 32
       + Instruction (Index));

   --  IN and OUT encode a count of 32 as 0
   function In_From
     (Source : In_Source;
      Count  : Bit_Count;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
   is (Head (In_Op, Side, Idle)
       + Instruction (In_Source'Enum_Rep (Source)) * 32
       + Instruction (Count mod 32));

   function Out_To
     (Dest  : Out_Destination;
      Count : Bit_Count;
      Side  : Side_Value := No_Side;
      Idle  : Natural := 0) return Instruction
   is (Head (Out_Op, Side, Idle)
       + Instruction (Out_Destination'Pos (Dest)) * 32
       + Instruction (Count mod 32));

   function Push
     (If_Full : Boolean := False;
      Block   : Boolean := True;
      Side    : Side_Value := No_Side;
      Idle    : Natural := 0) return Instruction
   is (Head (Push_Pull_Op, Side, Idle) + Code (If_Full) * 64
       + Code (Block) * 32);

   function Pull
     (If_Empty : Boolean := False;
      Block    : Boolean := True;
      Side     : Side_Value := No_Side;
      Idle     : Natural := 0) return Instruction
   is (Head (Push_Pull_Op, Side, Idle) + 128 + Code (If_Empty) * 64
       + Code (Block) * 32);

   function Mov
     (Dest   : Mov_Destination;
      Source : Mov_Source;
      Op     : Mov_Operation := None;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
   is (Head (Mov_Op, Side, Idle)
       + Instruction (Mov_Destination'Pos (Dest)) * 32
       + Instruction (Mov_Operation'Pos (Op)) * 8
       + Instruction (Mov_Source'Enum_Rep (Source)));

   function Irq
     (Index : Irq_Index;
      Clear : Boolean := False;
      Wait  : Boolean := False;
      Mode  : Irq_Mode := This_Block;
      Side  : Side_Value := No_Side;
      Idle  : Natural := 0) return Instruction
   is (Head (Irq_Op, Side, Idle) + Code (Clear) * 64
       + Code (Wait) * 32 + Instruction (Irq_Mode'Pos (Mode)) * 8
       + Instruction (Index));

   function Set
     (Dest : Set_Destination;
      Data : Set_Data;
      Side : Side_Value := No_Side;
      Idle : Natural := 0) return Instruction
   is (Head (Set_Op, Side, Idle)
       + Instruction (Set_Destination'Enum_Rep (Dest)) * 32
       + Instruction (Data));

   function Nop
     (Side : Side_Value := No_Side;
      Idle : Natural := 0) return Instruction
   is (Mov (Y, Y, None, Side, Idle));
end Keel.PIO.Assembler;
