--  DMA_IRQ_0: every channel's interrupt is routed here (INTE0).
--  Clear what is pending, by writing it back to INTS0, then count
--  and signal each channel in it (datasheet 12.6.5).
procedure IRQ_0_Handler
  with Export, Convention => C, External_Name => "keel_isr_10";

procedure IRQ_0_Handler is
   Pending : constant UInt16 := DMA_Periph.INTS0.INTS0;
begin
   DMA_Periph.INTS0 := (INTS0 => Pending, others => <>);
   for Ch in Channel loop
      if (Pending and Bit (Ch)) /= 0 then
         Done_N (Ch) := Done_N (Ch) + 1;
         Signal (Ended (Ch));
      end if;
   end loop;
end IRQ_0_Handler;
