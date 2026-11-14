--  Edge interrupts, on IO_IRQ_BANK0 of processor 0 (datasheet
--  9.5). The pad latches each edge until it is acknowledged.
type Edges is record
   Falling, Rising : Boolean := False;
end record;

--  Raise IO_IRQ_BANK0 on these edges of P, and on no others
procedure Watch (P : Input_Pin; On : Edges)
  with Pre => Is_Claimed (P);

--  The watched edges latched on P (PROC0_INTS)
function Seen (P : Input_Pin) return Edges
  with Pre => Is_Claimed (P);

--  Clear the latched edges in Which (INTR, write 1 to clear)
procedure Acknowledge (P : Input_Pin; Which : Edges)
  with Pre => Is_Claimed (P);
