procedure Read (P : Port_Id; C : out Character; Got : out Boolean) is
   R : UART0_Peripheral renames Regs (P).all;
   W : UARTDR_Register;
   Ahead : DMA_Count;
begin
   C := ASCII.NUL;
   Got := False;
   case State (P).How is
      when Polled =>
         if not R.UARTFR.RXFE then
            W := R.UARTDR;
            Note_Errors (P, W.FE, W.PE, W.BE, W.OE);
            C := Character'Val (W.DATA);
            Got := True;
            Stats (P).Received := Bump (Stats (P).Received);
         end if;

      when Interrupt =>
         Keel.Cortex_M.DMB;
         if not Is_Empty (RX (P)) then
            Pop (RX (P), C);
            Got := True;
         end if;
         Keel.Cortex_M.DMB;

      when DMA =>
         Ahead := DMA_Head (P) - DMA_Tail (P);
         if Ahead > Ring_Size then
            --  The DMA has lapped the program: what the ring holds
            --  is no longer in order. Drop it all.
            Stats (P).Dropped :=
              (if Natural'Last - Stats (P).Dropped < Natural (Ahead)
               then Natural'Last
               else Stats (P).Dropped + Natural (Ahead));
            DMA_Tail (P) := DMA_Tail (P) + Ahead;
         elsif Ahead > 0 then
            C := Character'Val
              (Bytes.Peek (DMA_Ring (P).B,
                           Natural (DMA_Tail (P) mod Ring_Size)));
            DMA_Tail (P) := DMA_Tail (P) + 1;
            Got := True;
            Stats (P).Received := Bump (Stats (P).Received);
         end if;
   end case;
end Read;
