type Direction is (Shift_Left, Shift_Right);
--  Join the FIFOs into one of 8 words, for TX or for RX
type FIFO_Join is (No_Join, Join_TX, Join_RX);
subtype Threshold is Positive range 1 .. 32;

--  How a state machine runs: its clock, its pins (each a base and
--  a count), how its shift registers shift, and when it pulls and
--  pushes on its own
type Machine_Config is record
   Clock          : Divider := (Int => 1, Frac => 0);
   Out_Base       : Pin_Id := 0;
   Out_Count      : Natural range 0 .. 32 := 0;
   Set_Base       : Pin_Id := 0;
   Set_Count      : Natural range 0 .. 5 := 0;
   Side_Base      : Pin_Id := 0;
   In_Base        : Pin_Id := 0;
   Jmp_Pin        : Pin_Id := 0;
   Out_Shift      : Direction := Shift_Right;
   In_Shift       : Direction := Shift_Right;
   Autopull       : Boolean := False;
   Pull_Threshold : Threshold := 32;
   Autopush       : Boolean := False;
   Push_Threshold : Threshold := 32;
   FIFO           : FIFO_Join := No_Join;
end record;

--  Stop M, set it up for P loaded at Offset (its wrap and its
--  side-set come from P), empty its FIFOs, restart it and its
--  clock, and jump to Offset. It runs from there at Start.
procedure Configure
  (B      : Block;
   M      : Machine;
   P      : Program;
   Offset : Address;
   Config : Machine_Config)
  with Pre => Is_Claimed (B, M)
              and then Integer (Offset) + Integer (P.Last) <= 31;
