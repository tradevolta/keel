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
