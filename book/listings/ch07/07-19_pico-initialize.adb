--  A refused pin stops the game: say which, then wait for reset
procedure Check (Stat : Status; What : String) is
begin
   if Stat /= Ok then
      Keel.Trace.Put_Line
        ("reaction_time: " & What & ": " & Stat'Image);
      loop
         null;
      end loop;
   end if;
end Check;

procedure Initialize is
   Stat : Status;
begin
   Keel.Trace.Initialize;
   Start_Timer;
   Enable;
   Claim (Go_Lamp, (Initial => Low, Slew => Slow), Stat);
   Check (Stat, "GP15");
   Claim (Lamp_A, (Initial => Low, Slew => Slow), Stat);
   Check (Stat, "GP14");
   Claim (Lamp_B, (Initial => Low, Slew => Slow), Stat);
   Check (Stat, "GP13");
   Claim (Button_A, (Bias => Pull_Up), Stat);
   Check (Stat, "GP16");
   Claim (Button_B, (Bias => Pull_Up), Stat);
   Check (Stat, "GP17");
   Last_Tick := Now;
end Initialize;
