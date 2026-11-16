procedure Sleep_Until (Deadline : Keel.Time.Time) is
begin
   Disable_Interrupts;
   if Bare.Clock < Deadline then
      Bare.Wake_At (Deadline);
      Gate (0, Keep_Timer);
      Set_Deep_Sleep (True);
      WFI;
      Set_Deep_Sleep (False);
      Ungate;
   end if;
   Enable_Interrupts;
end Sleep_Until;
