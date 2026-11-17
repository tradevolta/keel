--  Turn the transmit interrupt on, if it is off, and make it
--  pending: it fires only when the FIFO drains past its level
--  (12.1.6.3), and an idle FIFO never does. IMSC is shared with
--  the handler, so its update is the one place with interrupts
--  masked.
procedure Arm (P : Port_Id) is
begin
   Keel.Cortex_M.Disable_Interrupts;
   if not Armed (P) then
      Armed (P) := True;
      Regs (P).UARTIMSC.TXIM := True;
      Keel.Interrupts.Set_Pending (IRQ (P));
   end if;
   Keel.Cortex_M.Enable_Interrupts;
end Arm;

procedure Write (P : Port_Id; Text : String) is
   R : UART0_Peripheral renames Regs (P).all;
begin
   if State (P).How = Polled then
      for C of Text loop
         loop
            exit when not R.UARTFR.TXFF;
         end loop;
         R.UARTDR := (DATA => Character'Pos (C), others => <>);
         Stats (P).Sent := Bump (Stats (P).Sent);
      end loop;
      return;
   end if;

   for C of Text loop
      --  Wait for room: the handler makes it, and its interrupt
      --  ends the WFI
      loop
         Keel.Cortex_M.DMB;
         exit when not Is_Full (TX (P));
         Arm (P);
         Keel.Cortex_M.WFI;
      end loop;
      Push (TX (P), C);
      Keel.Cortex_M.DMB;
   end loop;
   Arm (P);
end Write;
