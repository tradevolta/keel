protected Encoder
  with Interrupt_Priority => System.Interrupt_Priority'First
is
   --  Blocks until the knob has moved, then gives its position
   entry Changed (Position : out Volume);
private
   procedure Handler
     with Attach_Handler =>
            Ada.Interrupts.Names.IO_IRQ_BANK0_Interrupt_CPU_1;

   D     : Decoder (Low => Volume'First, High => Volume'Last);
   Moved : Boolean := False;
end Encoder;
