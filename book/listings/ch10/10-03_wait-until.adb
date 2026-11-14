procedure Wake_At (Deadline : Time) is
   Now : constant Time := Clock;
   Last : constant Time := Time'Min (Deadline, Max_Clock);
   At_Time : constant Time :=
     (if Time_Span'(Last - Now) > 2**31
      then Now + Time_Span'(2**31) else Last);
begin
   --  The alarm compares the low 32 bits for equality
   TIMER0_Periph.ALARM3 := UInt32 (At_Time mod 2**32);
   if Clock >= At_Time then
      --  Too late to match: disarm it, and pend its interrupt
      TIMER0_Periph.ARMED := (ARMED => 2#1000#, others => <>);
      Set_Pending (TIMER0_IRQ_3);
   end if;
end Wake_At;

--  As Keel.Sync.Bare.Wait: look and sleep with interrupts
--  masked, so the alarm cannot fire between the look and the WFI
procedure Wait_Until (Deadline : Time) is
begin
   loop
      Disable_Interrupts;
      exit when Clock >= Deadline;
      Wake_At (Deadline);
      WFI;
      Enable_Interrupts;
   end loop;
   Enable_Interrupts;
end Wait_Until;
