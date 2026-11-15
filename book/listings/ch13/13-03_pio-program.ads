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
