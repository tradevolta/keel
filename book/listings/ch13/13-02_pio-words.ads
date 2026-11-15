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
