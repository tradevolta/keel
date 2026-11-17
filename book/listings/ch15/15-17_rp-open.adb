--  Through reset, then the divisor; the LCR_H write latches
--  IBRD and FBRD (12.1.3.2), so it comes after them
Reset_Bits.Set
  (RESETS_Periph.RESET,
   (Reset_Bits.No_Bits with delta UART => (False, Bit)));
Reset_Bits.Clear
  (RESETS_Periph.RESET,
   (Reset_Bits.No_Bits with delta UART => (False, Bit)));
loop
   exit when RESETS_Periph.RESET_DONE.UART.Arr (Port_Id'Pos (P));
end loop;
R.UARTIBRD := (BAUD_DIVINT => UInt16 (D / 64), others => <>);
R.UARTFBRD := (BAUD_DIVFRAC => UInt6 (D mod 64), others => <>);
R.UARTLCR_H :=
  (WLEN => UInt2 (Natural (F.Bits) - 5),
   FEN  => True,
   STP2 => F.Stops = 2,
   PEN  => F.Check /= None,
   EPS  => F.Check = Even,
   others => <>);

--  The receive side
case How is
   when Polled =>
      null;
   when Interrupt =>
      --  A FIFO half full, or a pause of 32 bit times with
      --  anything in it (12.1.6.4), wakes the handler
      R.UARTIMSC := (RXIM | RTIM => True, others => <>);
   when DMA =>
      Bytes.Lend (DMA_Ring (P).B, Ring);
      R.UARTDMACR := (RXDMAE => True, others => <>);
      Keel.DMA.RP2350.Start
        (Channel,
         (From     => Register (R.UARTDR'Address),
          To       => Ring,
          Size     => Keel.DMA.Byte,
          Count    => Ring_Size,
          Paced_By => RX_Request (P),
          Mode     => Keel.DMA.RP2350.Repeat,
          Wrap     => 8,
          Notify   => True,
          others   => <>),
         Stat);
      if Stat /= Ok then
         return;
      end if;
      DMA_Tail (P) := 0;
      R.UARTIMSC :=
        (FEIM | PEIM | BEIM | OEIM => True, others => <>);
end case;

--  The handler reads State, so State is set before the
--  interrupt can come
State (P) := (Open => True, How => How, D => D,
              Channel => Channel);
Select_Function (TX, UART_Function);
Select_Function (RX, UART_Function);
R.UARTCR := (UARTEN | TXE | RXE => True, others => <>);
if How /= Polled then
   Keel.Interrupts.Set_Priority (IRQ (P), Priority);
   Keel.Interrupts.Enable (IRQ (P));
end if;
Stat := Ok;
