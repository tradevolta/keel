procedure Power_Down_Until (Deadline : Keel.Time.Time) is
   Ms : constant Natural := Ms_Until (Deadline, 2);
   State : Reg;
begin
   if Ms = 0 or else not AON.Running then
      Sleep_Until (Deadline);
      return;
   end if;
   Disable_Interrupts;
   --  Nothing pending may end the WFI below
   Keel.Interrupts.Disable (3);
   Keel.Interrupts.Clear_Pending (3);

   AON.Use_LPOSC;
   Words.Set_Bits (Words.VREG_CTRL, VREG_Unlock);
   --  Boot to the program, not a POWMAN boot vector (5.2.3)
   for I in 0 .. 3 loop
      Words.Write (Words.BOOT0 + Words.Offset (4 * I), 0);
   end loop;
   Words.Clear_Bits (Words.SEQ_CFG, Pwrup_SRAM_Bits);

   AON.Set_Alarm
     (AON.Now + Keel.RTC.Epoch_Ms (Ms), Power_Up => True);
   if Pin_Set then
      Words.Write (Words.PWRUP0, Wake_Pin_Source or Pwrup_Edge);
      Words.Write (Words.PWRUP0,
                   Wake_Pin_Source or Pwrup_Edge or Pwrup_Status);
      Words.Write (Words.PWRUP0,
                   Wake_Pin_Source or Pwrup_Edge or Pwrup_Enable);
   end if;

   --  Ask for P1.7 (6.2.3.1); WAITING stays set until the
   --  processors sleep
   Words.Clear_Bits (Words.STATE, State_Ignored);
   Words.Write (Words.STATE, P1_7 * 2**4);
   State := Words.Read (Words.STATE);
   for Try in 1 .. 500 loop
      exit when (State and State_Waiting) /= 0
        or else (State and (State_Ignored or State_Bad_Sw_Req)) /= 0;
      State := Words.Read (Words.STATE);
   end loop;
   if (State and State_Waiting) = 0 then
      --  Refused: a pending power-up request or a debugger
      AON.Clear_Alarm;
      Keel.Interrupts.Enable (3);
      Enable_Interrupts;
      Sleep_Until (Deadline);
      return;
   end if;
   Set_Deep_Sleep (True);
   loop
      WFI;
   end loop;
end Power_Down_Until;
