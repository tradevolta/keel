--  Look with interrupts masked, and sleep still masked: an
--  interrupt that arrives between the look and the WFI stays
--  pending, and a pending interrupt ends the WFI. Unmasking then
--  lets its handler run before the next look.
procedure Wait (E : in out Event) is
begin
   loop
      Disable_Interrupts;
      exit when E.Set;
      WFI;
      Enable_Interrupts;
   end loop;
   E.Set := False;
   Enable_Interrupts;
end Wait;
