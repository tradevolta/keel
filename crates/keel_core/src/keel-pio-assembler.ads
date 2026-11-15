--  SPDX-License-Identifier: Apache-2.0
--  Keel.PIO.Assembler: PIO instructions as Ada function calls. Each
--  returns the 16 bits that the Pico SDK's pioasm makes from the same
--  line (RP2350 datasheet, 11.4). Instantiate it with the program's
--  side-set: Side_Bits pins, and Side_Optional if an instruction may
--  leave them alone, which costs one more bit.
--
--  Every instruction has a 5-bit field, bits 12 to 8: the side-set
--  value at the top (with its enable bit above it, if optional) and
--  the delay below, the idle cycles after the instruction runs. So a
--  program with more side-set has less delay: the preconditions say
--  how much, and GNATprove checks each instruction of a program.
generic
   Side_Bits     : Side_Count := 0;
   Side_Optional : Boolean := False;
package Keel.PIO.Assembler
  with Pure, SPARK_Mode
is
   pragma Compile_Time_Error
     (Side_Bits + Boolean'Pos (Side_Optional) > 5,
      "side-set and its enable bit take at most 5 bits");

   Field_Bits : constant Natural :=
     Side_Bits + Boolean'Pos (Side_Optional);
   Max_Idle   : constant Natural := 2**(5 - Field_Bits) - 1;
   Max_Side   : constant Natural := 2**Side_Bits - 1;

   --  A side-set value, or No_Side
   subtype Side_Value is Integer range -1 .. 31;
   No_Side : constant Side_Value := -1;

   --  Side and Idle fit the field. Without side-set there is no
   --  value to give; with it, each instruction must give one,
   --  unless it is optional.
   function Fits (Side : Side_Value; Idle : Natural) return Boolean is
     (Idle <= Max_Idle
      and then (if Side_Bits = 0 then Side = No_Side
                else Side <= Max_Side
                     and then (Side /= No_Side or else Side_Optional)));

   --  The JMP conditions, in encoding order
   type Condition is
     (Always, X_Zero, X_Decrement, Y_Zero, Y_Decrement, X_Not_Y,
      Pin, OSR_Not_Empty);

   --  What WAIT waits on; Jmp_Pin is an RP2350 addition
   type Wait_Source is (GPIO, Pins, IRQ, Jmp_Pin);
   subtype Wait_Index is Natural range 0 .. 31;

   type In_Source is (Pins, X, Y, Zeros, ISR, OSR);
   for In_Source use
     (Pins => 0, X => 1, Y => 2, Zeros => 3, ISR => 6, OSR => 7);

   type Out_Destination is
     (Pins, X, Y, Discard, Pindirs, PC, ISR, Exec);

   --  IN and OUT shift 1 to 32 bits
   subtype Bit_Count is Positive range 1 .. 32;

   type Mov_Destination is (Pins, X, Y, Pindirs, Exec, PC, ISR, OSR);
   type Mov_Source is (Pins, X, Y, Zeros, Status_Bits, ISR, OSR);
   for Mov_Source use
     (Pins => 0, X => 1, Y => 2, Zeros => 3, Status_Bits => 5, ISR => 6,
      OSR => 7);
   type Mov_Operation is (None, Invert, Bit_Reverse);

   --  Which block's flag an IRQ index names (the RP2350 adds the
   --  neighbours)
   type Irq_Mode is (This_Block, Previous_Block, Relative, Next_Block);
   subtype Irq_Index is Natural range 0 .. 7;

   type Set_Destination is (Pins, X, Y, Pindirs);
   for Set_Destination use (Pins => 0, X => 1, Y => 2, Pindirs => 4);
   subtype Set_Data is Natural range 0 .. 31;

   function Jmp
     (Target : Address;
      Cond   : Condition := Always;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Jmp'Result) = Jmp_Op
                  and then Target_Of (Jmp'Result) = Target;

   function Wait
     (Polarity : Boolean;
      Source   : Wait_Source;
      Index    : Wait_Index;
      Side     : Side_Value := No_Side;
      Idle     : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle)
                  and then (if Source = IRQ then Index <= 7),
          Post => Opcode_Of (Wait'Result) = Wait_Op;

   function In_From
     (Source : In_Source;
      Count  : Bit_Count;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (In_From'Result) = In_Op;

   function Out_To
     (Dest  : Out_Destination;
      Count : Bit_Count;
      Side  : Side_Value := No_Side;
      Idle  : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Out_To'Result) = Out_Op;

   --  Push the ISR to the RX FIFO: if Block, wait for room; if
   --  If_Full, only once the ISR holds the push threshold's bits
   function Push
     (If_Full : Boolean := False;
      Block   : Boolean := True;
      Side    : Side_Value := No_Side;
      Idle    : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Push'Result) = Push_Pull_Op;

   --  Pull a word from the TX FIFO into the OSR
   function Pull
     (If_Empty : Boolean := False;
      Block    : Boolean := True;
      Side     : Side_Value := No_Side;
      Idle     : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Pull'Result) = Push_Pull_Op;

   function Mov
     (Dest   : Mov_Destination;
      Source : Mov_Source;
      Op     : Mov_Operation := None;
      Side   : Side_Value := No_Side;
      Idle   : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Mov'Result) = Mov_Op;

   --  Set (or, if Clear, clear) IRQ flag Index; if Wait, then wait
   --  until something clears it
   function Irq
     (Index : Irq_Index;
      Clear : Boolean := False;
      Wait  : Boolean := False;
      Mode  : Irq_Mode := This_Block;
      Side  : Side_Value := No_Side;
      Idle  : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle) and then not (Clear and Wait),
          Post => Opcode_Of (Irq'Result) = Irq_Op;

   function Set
     (Dest : Set_Destination;
      Data : Set_Data;
      Side : Side_Value := No_Side;
      Idle : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Set'Result) = Set_Op;

   --  No operation: pioasm's nop is mov y, y
   function Nop
     (Side : Side_Value := No_Side;
      Idle : Natural := 0) return Instruction
     with Pre  => Fits (Side, Idle),
          Post => Opcode_Of (Nop'Result) = Mov_Op;
end Keel.PIO.Assembler;
