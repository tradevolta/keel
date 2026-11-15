--  Empty M's FIFOs and restart it (CTRL's SM_RESTART): the ISR,
--  the shift counters, the delay and any stalled instruction are
--  cleared, and the next OUT pulls. The OSR, X, Y and PC stay.
procedure Restart (B : Block; M : Machine)
  with Pre => Is_Claimed (B, M);

procedure Start (B : Block; M : Machine)
  with Pre => Is_Claimed (B, M);
procedure Stop (B : Block; M : Machine)
  with Pre => Is_Claimed (B, M);

--  Run I at once, without its delay (datasheet 11.5.7). A JMP
--  moves the program counter; a stopped machine stays stopped.
procedure Execute (B : Block; M : Machine; I : Instruction)
  with Pre => Is_Claimed (B, M);
