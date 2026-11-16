procedure Dormant_Until (Deadline : Keel.Time.Time) is
   Ms : constant Natural := Ms_Until (Deadline, 2);
   Start_us : constant Keel.Time.Time := Bare.Clock;
   Start_ms : Keel.RTC.Epoch_Ms;
   Stat : Status;
begin
   if Ms = 0 or else not AON.Running
     or else not Keel.Clock.RP2350.Crystal_Running
   then
      Sleep_Until (Deadline);
      return;
   end if;
   Disable_Interrupts;
   AON.Use_LPOSC;
   Start_ms := AON.Now;
   Keel.Clock.RP2350.Prepare_Dormant;
   AON.Set_Alarm (Start_ms + Keel.RTC.Epoch_Ms (Ms));
   Gate (Keep_POWMAN, 0);
   Set_Deep_Sleep (True);
   Keel.Clock.RP2350.Enter_Dormant;
   Set_Deep_Sleep (False);
   Ungate;
   AON.Clear_Alarm;
   Keel.Clock.RP2350.Restart_After_Dormant (Stat);
   if Stat = Ok then
      AON.Use_Crystal;
   end if;
   --  TIMER0 stood still: add what the always-on timer counted
   Bare.Catch_Up
     (Keel.Time."+" (Start_us,
        Keel.Time.Time_Span (AON.Now - Start_ms) * 1_000));
   Enable_Interrupts;
end Dormant_Until;
