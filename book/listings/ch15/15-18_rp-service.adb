procedure Service (P : Port_Id) is
   R   : UART0_Peripheral renames Regs (P).all;
   MIS : constant UARTMIS_Register := R.UARTMIS;
   W   : UARTDR_Register;
   C   : Character;
begin
   Keel.Cortex_M.DMB;
   if State (P).How = Interrupt then
      --  Empty the receive FIFO into RX; each character carries
      --  its own error bits (12.1.3.2.3)
      while not R.UARTFR.RXFE loop
         W := R.UARTDR;
         Note_Errors (P, W.FE, W.PE, W.BE, W.OE);
         if Is_Full (RX (P)) then
            Stats (P).Dropped := Bump (Stats (P).Dropped);
         else
            Push (RX (P), Character'Val (W.DATA));
            Stats (P).Received := Bump (Stats (P).Received);
         end if;
      end loop;
   else
      --  The DMA took the characters; only the flags are left
      Note_Errors (P, MIS.FEMIS, MIS.PEMIS, MIS.BEMIS, MIS.OEMIS);
   end if;
   R.UARTICR :=
     (RTIC | FEIC | PEIC | BEIC | OEIC => True, others => <>);

   --  Fill the transmit FIFO from TX; when TX is empty, stop
   --  the transmit interrupt until Write arms it again
   if Armed (P) then
      while not R.UARTFR.TXFF and then not Is_Empty (TX (P)) loop
         Pop (TX (P), C);
         R.UARTDR := (DATA => Character'Pos (C), others => <>);
         Stats (P).Sent := Bump (Stats (P).Sent);
      end loop;
      if Is_Empty (TX (P)) then
         R.UARTIMSC.TXIM := False;
         Armed (P) := False;
      end if;
   end if;
   Keel.Cortex_M.DMB;
end Service;
