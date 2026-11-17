procedure Handler is
   C : Character;
begin
   Keel.Cortex_M.DMB;
   Note_Errors;
   --  RXNE is RXFNE with the FIFO on: something to read
   while R.ISR.RXNE loop
      C := Character'Val (Natural (R.RDR.RDR) mod 256);
      if Is_Full (RX) then
         Stats.Dropped := Bump (Stats.Dropped);
      else
         Push (RX, C);
         Stats.Received := Bump (Stats.Received);
      end if;
   end loop;
   --  TXE is TXFNF: room in the transmit FIFO
   if Armed then
      while R.ISR.TXE and then not Is_Empty (TX) loop
         Pop (TX, C);
         R.TDR := (TDR => Character'Pos (C), others => <>);
         Stats.Sent := Bump (Stats.Sent);
      end loop;
      if Is_Empty (TX) then
         R.CR1.TXEIE := False;
         Armed := False;
      end if;
   end if;
   Keel.Cortex_M.DMB;
end Handler;
