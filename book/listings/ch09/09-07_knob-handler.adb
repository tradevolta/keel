--  Shared with the handler: touched by the program only between
--  Enter_Critical and Leave_Critical
Knob    : Decoder (Low => Volume'First, High => Volume'Last);
Press   : Boolean := False;
Changed : Event;

function Contacts return Phase is
  (Phase_Of (A => Get (A) = High, B => Get (B) = High));

--  IO_IRQ_BANK0 (21): an edge on A, B or the switch
procedure IO_Bank0_Handler
  with Export, Convention => C, External_Name => "keel_isr_21";

procedure IO_Bank0_Handler is
begin
   --  Clear first: an edge during the read latches again
   Acknowledge (A, Both);
   Acknowledge (B, Both);
   Update (Knob, Contacts);
   if Seen (Switch).Falling then
      Acknowledge (Switch, Both);
      Press := True;
   end if;
   Signal (Changed);
end IO_Bank0_Handler;
