--  A 100 ms gate: ten a second, so the meter reads to 10 Hz
Gate_Time : constant Time_Span := Milliseconds (100);
Per_Gate  : constant := 10;

--  Shared with the handler. The program writes Opened before it
--  sets the alarm, and reads Edges and Over after Closed.
Opened   : Time := 0;
Counting : Boolean := False;
Edges    : Count := 0;
Over     : Boolean := False;
Closed   : Event;

--  TIMER0_IRQ_0 (0): the gate opens, then closes 100 ms later.
--  The second alarm counts from the first one's time, not from
--  when its handler ran, so both edges of the gate see the same
--  delay and the delay cancels.
procedure Gate_Handler
  with Export, Convention => C, External_Name => "keel_isr_0";

procedure Gate_Handler is
begin
   Acknowledge (Gate);
   if not Counting then
      Start (Meter);
      Counting := True;
      Set (Gate, Opened + Gate_Time);
   else
      Stop (Meter);
      Counting := False;
      Edges := Value (Meter);
      Over := Wrapped (Meter);
      Signal (Closed);
   end if;
end Gate_Handler;
