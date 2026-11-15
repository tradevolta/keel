function Jmp
  (Target : Address;
   Cond   : Condition := Always;
   Side   : Side_Value := No_Side;
   Idle   : Natural := 0) return Instruction
  with Pre  => Fits (Side, Idle),
       Post => Opcode_Of (Jmp'Result) = Jmp_Op
               and then Target_Of (Jmp'Result) = Target;
