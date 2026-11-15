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
