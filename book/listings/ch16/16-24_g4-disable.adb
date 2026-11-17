--  The procedure for disabling the SPI (42.5.9): the transmit
--  FIFO empty, the last frame out, SPE off, then the receive FIFO
--  read empty. Reading DR and then SR clears an overrun (42.5.11).
procedure Disable is
   Junk : Unsigned_8;
   Flags : SR_Register;
begin
   loop
      exit when R.SR.FTLVL = 0;
   end loop;
   loop
      exit when not R.SR.BSY;
   end loop;
   R.CR1.SPE := False;
   loop
      exit when R.SR.FRLVL = 0;
      Junk := DR8;
   end loop;
   Flags := R.SR;
   pragma Unreferenced (Junk, Flags);
end Disable;
